import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../../beneficiaries/data/services/beneficiaries_service.dart';
import '../../../beneficiaries/presentation/pages/beneficiary_timeline_page.dart';
import '../../../vaccinations/presentation/pages/vaccination_list_page.dart';
import '../../../documents/presentation/pages/document_locker_page.dart';
import '../../../vaccinations/data/models/vaccination_model.dart';

class ChildDetailPage extends ConsumerStatefulWidget {
  final int childId;

  const ChildDetailPage({
    super.key,
    required this.childId,
  });

  @override
  ConsumerState<ChildDetailPage> createState() => _ChildDetailPageState();
}

class _ChildDetailPageState extends ConsumerState<ChildDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _beneficiaryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBeneficiaryId();
  }

  Future<void> _loadBeneficiaryId() async {
    try {
      final service = ref.read(beneficiariesServiceProvider);
      final children = await service.getChildren();
      final child = children.firstWhere(
        (c) => (c.legacyChildProfileId ?? c.id) == widget.childId,
        orElse: () => children.first,
      );
      setState(() {
        _beneficiaryId = child.id;
      });
    } catch (e) {
      // Handle error
    }
  }

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/children/${widget.childId}/edit');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Vaccinations', icon: Icon(Icons.vaccines)),
            Tab(text: 'Timeline', icon: Icon(Icons.timeline)),
            Tab(text: 'Documents', icon: Icon(Icons.folder)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildVaccinationsTab(),
          _buildTimelineTab(),
          _buildDocumentsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return FutureBuilder<List<dynamic>>(
      future: ref.read(beneficiariesServiceProvider).getChildren(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final children = snapshot.data ?? [];
        final child = children.firstWhere(
          (c) => (c.legacyChildProfileId ?? c.id) == widget.childId,
          orElse: () => children.first,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.child_care,
                          size: 40,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${child.firstName} ${child.lastName}',
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _calculateAge(child.dateOfBirth),
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(child.gender.toUpperCase()),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Next Vaccination Card
              Card(
                color: AppTheme.warningColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppTheme.warningColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Next Vaccination', style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                            const SizedBox(height: 4),
                            Text('Check timeline for upcoming vaccines', 
                              style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          _tabController.animateTo(2); // Switch to Timeline tab
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVaccinationsTab() {
    return VaccinationListPage(childId: widget.childId);
  }

  Widget _buildTimelineTab() {
    if (_beneficiaryId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BeneficiaryTimelinePage(
      beneficiaryId: _beneficiaryId!,
      childId: widget.childId,
    );
  }

  Widget _buildDocumentsTab() {
    return DocumentLockerPage(childId: widget.childId);
  }
}
