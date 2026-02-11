import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/services_provider.dart';
import '../../data/models/marketplace_models.dart';
import '../../../vaccines/data/models/vaccine_model.dart';
import '../widgets/listing_card.dart';

class MarketplaceSearchPage extends ConsumerStatefulWidget {
  const MarketplaceSearchPage({super.key});

  @override
  ConsumerState<MarketplaceSearchPage> createState() => _MarketplaceSearchPageState();
}

class _MarketplaceSearchPageState extends ConsumerState<MarketplaceSearchPage> {
  final _searchController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedVaccine;
  double? _minPrice;
  double? _maxPrice;
  String? _facilityType;

  List<MarketplaceListingModel> _listings = [];
  List<VaccineModel> _vaccines = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadVaccines();
    _loadListings();
  }

  Future<void> _loadVaccines() async {
    try {
      final service = ref.read(vaccinesServiceProvider);
      final vaccines = await service.getVaccines();
      setState(() {
        _vaccines = vaccines;
      });
    } catch (e) {
      // Silently fail - vaccines are optional for display
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadListings({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(marketplaceServiceProvider);
      final response = await service.searchListings(
        location: _locationController.text.isEmpty ? null : _locationController.text,
        vaccineId: _selectedVaccine != null ? int.tryParse(_selectedVaccine!) : null,
        priceMin: _minPrice,
        priceMax: _maxPrice,
        facilityType: _facilityType,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        if (reset) {
          _listings = response.items;
        } else {
          _listings.addAll(response.items);
        }
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading listings: $e')),
        );
      }
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiltersBottomSheet(
        onApply: (vaccine, minPrice, maxPrice, facilityType) {
          setState(() {
            _selectedVaccine = vaccine;
            _minPrice = minPrice;
            _maxPrice = maxPrice;
            _facilityType = facilityType;
          });
          _loadListings(reset: true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Vaccination'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Search by location or pincode',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _loadListings(reset: true),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _loadListings(reset: true),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // Listings
          Expanded(
            child: _isLoading && _listings.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _listings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No listings found',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search filters',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadListings(reset: true),
                        child: ListView.builder(
                          itemCount: _listings.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _listings.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final listing = _listings[index];
                            return ListingCard(
                              listing: listing,
                              vaccines: _vaccines,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/marketplace/listing/${listing.id}',
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FiltersBottomSheet extends StatefulWidget {
  final Function(String?, double?, double?, String?) onApply;

  const _FiltersBottomSheet({required this.onApply});

  @override
  State<_FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<_FiltersBottomSheet> {
  String? _selectedVaccine;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _facilityType;

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _minPriceController,
            decoration: const InputDecoration(
              labelText: 'Min Price (₹)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _maxPriceController,
            decoration: const InputDecoration(
              labelText: 'Max Price (₹)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _facilityType,
            decoration: const InputDecoration(
              labelText: 'Facility Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
              DropdownMenuItem(value: 'clinic', child: Text('Clinic')),
              DropdownMenuItem(value: 'health_center', child: Text('Health Center')),
            ],
            onChanged: (value) => setState(() => _facilityType = value),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      _selectedVaccine,
                      _minPriceController.text.isEmpty
                          ? null
                          : double.tryParse(_minPriceController.text),
                      _maxPriceController.text.isEmpty
                          ? null
                          : double.tryParse(_maxPriceController.text),
                      _facilityType,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

