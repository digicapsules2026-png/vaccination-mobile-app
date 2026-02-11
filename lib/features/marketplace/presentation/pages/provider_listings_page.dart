import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/services_provider.dart';
import '../../data/models/marketplace_models.dart';
import '../../../vaccines/data/models/vaccine_model.dart';
import '../widgets/listing_card.dart';

class ProviderListingsPage extends ConsumerStatefulWidget {
  const ProviderListingsPage({super.key});

  @override
  ConsumerState<ProviderListingsPage> createState() => _ProviderListingsPageState();
}

class _ProviderListingsPageState extends ConsumerState<ProviderListingsPage> {
  List<MarketplaceListingModel> _listings = [];
  List<VaccineModel> _vaccines = [];
  bool _isLoading = true;
  bool _showCreateForm = false;

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

  Future<void> _loadListings() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(marketplaceServiceProvider);
      final listings = await service.getUserListings();

      setState(() {
        _listings = listings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading listings: $e')),
        );
      }
    }
  }

  Future<void> _deleteListing(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(marketplaceServiceProvider);
        await service.deleteListing(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing deleted successfully')),
          );
          _loadListings();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting listing: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _showCreateForm = true),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No listings found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => setState(() => _showCreateForm = true),
                        child: const Text('Create Listing'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _listings.length,
                  itemBuilder: (context, index) {
                    final listing = _listings[index];
                    return ListingCard(
                      listing: listing,
                      vaccines: _vaccines,
                      onTap: () {
                        // TODO: Navigate to edit page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit functionality coming soon')),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

