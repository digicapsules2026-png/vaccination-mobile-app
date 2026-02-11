import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../../beneficiaries/data/models/beneficiary_model.dart';
import '../../../beneficiaries/data/services/beneficiaries_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Data will be loaded via providers
  }

  @override
  Widget build(BuildContext context) {
    final beneficiariesService = ref.watch(beneficiariesServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination Locker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<BeneficiaryModel>>(
        future: beneficiariesService.getChildren(),
        builder: (context, childrenSnapshot) {
          return FutureBuilder<ParentProfile?>(
            future: beneficiariesService.getParentProfile(),
            builder: (context, parentSnapshot) {
              final isLoading = childrenSnapshot.connectionState == ConnectionState.waiting ||
                  parentSnapshot.connectionState == ConnectionState.waiting;
              final children = childrenSnapshot.data ?? [];
              final parentProfile = parentSnapshot.data;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions Row
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.shopping_cart,
                            title: 'Book Vaccination',
                            color: Colors.green,
                            onTap: () => context.push('/marketplace'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.event,
                            title: 'My Bookings',
                            color: Colors.blue,
                            onTap: () => context.push('/marketplace/bookings'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Two Main Cards - Same Height
                    SizedBox(
                      height: 500,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // My Vaccination Card
                          Expanded(
                            child: _MyVaccinationCard(
                              parentProfile: parentProfile,
                              isLoading: isLoading,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // My Children Card
                          Expanded(
                            child: _MyChildrenCard(
                              children: children,
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// My Vaccination Card - Fixed Height, Never Expands
class _MyVaccinationCard extends StatelessWidget {
  final ParentProfile? parentProfile;
  final bool isLoading;

  const _MyVaccinationCard({
    required this.parentProfile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final vaccinationCount = parentProfile?.vaccinations?.length ?? 0;

    return Card(
      child: InkWell(
        onTap: () {
          if (parentProfile?.beneficiary.id != null) {
            context.push('/beneficiaries/${parentProfile!.beneficiary.id}');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.vaccines, color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'My Vaccination',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : vaccinationCount > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.vaccines,
                                    size: 48,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$vaccinationCount Vaccination${vaccinationCount != 1 ? 's' : ''}',
                                  style: AppTextStyles.h3,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Click to view details',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.vaccines,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No vaccinations recorded yet',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// My Children Card - Can Expand/Show Children
class _MyChildrenCard extends StatefulWidget {
  final List<BeneficiaryModel> children;
  final bool isLoading;

  const _MyChildrenCard({
    required this.children,
    required this.isLoading,
  });

  @override
  State<_MyChildrenCard> createState() => _MyChildrenCardState();
}

class _MyChildrenCardState extends State<_MyChildrenCard> {
  bool _isExpanded = false;

  String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    
    if (years > 0) {
      return '$years year${years != 1 ? 's' : ''}, $months month${months != 1 ? 's' : ''}';
    } else {
      final weeks = (difference.inDays / 7).floor();
      if (weeks > 0) {
        return '$weeks week${weeks != 1 ? 's' : ''}';
      } else {
        return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.child_care, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'My Children',
                        style: AppTextStyles.h3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.children.length}',
                          style: AppTextStyles.body2.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content - Scrollable
          if (_isExpanded)
            Expanded(
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.children.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.child_care_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No children added yet',
                                style: AppTextStyles.body2.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.push('/children/add');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Child'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: widget.children.length,
                          itemBuilder: (context, index) {
                            final child = widget.children[index];
                            final childId = child.legacyChildProfileId ?? child.id;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  context.push('/children/$childId');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${child.firstName} ${child.lastName}',
                                                  style: AppTextStyles.body1.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _calculateAge(child.dateOfBirth),
                                                  style: AppTextStyles.caption.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                              child.gender.toUpperCase(),
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                            backgroundColor:
                                                child.gender.toLowerCase() == 'male'
                                                    ? Colors.blue.withOpacity(0.1)
                                                    : Colors.pink.withOpacity(0.1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
        ],
      ),
    );
  }
}
