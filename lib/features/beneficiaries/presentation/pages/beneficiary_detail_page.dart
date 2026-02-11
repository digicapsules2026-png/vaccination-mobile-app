import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/models/beneficiary_model.dart';
import '../../data/models/timeline_model.dart';
import '../../../vaccinations/data/models/vaccination_model.dart';
import '../../../vaccinations/presentation/pages/vaccination_detail_page.dart';
import 'beneficiary_timeline_page.dart';
import '../../../documents/presentation/pages/document_locker_page.dart';

class BeneficiaryDetailPage extends ConsumerStatefulWidget {
  final int beneficiaryId;

  const BeneficiaryDetailPage({
    super.key,
    required this.beneficiaryId,
  });

  @override
  ConsumerState<BeneficiaryDetailPage> createState() => _BeneficiaryDetailPageState();
}

class _BeneficiaryDetailPageState extends ConsumerState<BeneficiaryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BeneficiaryModel? _beneficiary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBeneficiary();
  }

  Future<void> _loadBeneficiary() async {
    try {
      final service = ref.read(beneficiariesServiceProvider);
      final beneficiary = await service.getBeneficiaryById(widget.beneficiaryId);
      setState(() {
        _beneficiary = beneficiary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load beneficiary: $e')),
        );
      }
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_beneficiary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Beneficiary Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Beneficiary not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final isChild = _beneficiary!.type == BeneficiaryType.child;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_beneficiary!.firstName} ${_beneficiary!.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/beneficiaries/${widget.beneficiaryId}/edit');
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
                    child: Icon(
                      _beneficiary!.type == BeneficiaryType.child
                          ? Icons.child_care
                          : Icons.person,
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
                          '${_beneficiary!.firstName} ${_beneficiary!.lastName}',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _calculateAge(_beneficiary!.dateOfBirth),
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(_beneficiary!.gender.toUpperCase()),
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

          // Basic Information
          Text('Basic Information', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('Date of Birth', _beneficiary!.dateOfBirth.toString().split(' ')[0]),
                  const Divider(),
                  _buildInfoRow('Gender', _beneficiary!.gender),
                  if (_beneficiary!.phoneNumber != null) ...[
                    const Divider(),
                    _buildInfoRow('Phone', _beneficiary!.phoneNumber!),
                  ],
                  if (_beneficiary!.email != null) ...[
                    const Divider(),
                    _buildInfoRow('Email', _beneficiary!.email!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2.copyWith(color: Colors.grey[600])),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildVaccinationsTab() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        ref.read(vaccinationsServiceProvider).getAllVaccinations(
          beneficiaryId: widget.beneficiaryId,
        ),
        ref.read(authServiceProvider).getUser(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final results = snapshot.data as List<dynamic>?;
        if (results == null || results.length < 2) {
          return const Center(child: Text('Failed to load data'));
        }
        final vaccinations = results[0] as List<VaccinationModel>;
        final user = results[1] as dynamic?;
        final isParent = user?.role == 'parent' || user?.role == 'individual';

        if (vaccinations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.vaccines_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No vaccinations recorded', style: AppTextStyles.body2),
                if (!isParent) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/vaccinations/new?beneficiaryId=${widget.beneficiaryId}');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Vaccination'),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vaccinations.length,
          itemBuilder: (context, index) {
            final vaccination = vaccinations[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.vaccines, color: AppTheme.successColor),
                title: Text(vaccination.vaccineName ?? 'Unknown Vaccine'),
                subtitle: Text('Dose ${vaccination.doseNumber}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/vaccinations/${vaccination.id}/detail');
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimelineTab() {
    final childId = _beneficiary!.legacyChildProfileId ?? widget.beneficiaryId;
    return BeneficiaryTimelinePage(beneficiaryId: widget.beneficiaryId, childId: childId);
  }

  Widget _buildDocumentsTab() {
    final childId = _beneficiary!.legacyChildProfileId;
    if (childId == null) {
      return const Center(
        child: Text('Documents are only available for child beneficiaries'),
      );
    }
    return DocumentLockerPage(childId: childId);
  }
}












