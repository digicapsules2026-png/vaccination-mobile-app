import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../data/models/facility_analytics_model.dart';
import '../../data/services/facility_analytics_service.dart';

class FacilityAdminDashboardPage extends ConsumerStatefulWidget {
  final int facilityId;

  const FacilityAdminDashboardPage({
    super.key,
    required this.facilityId,
  });

  @override
  ConsumerState<FacilityAdminDashboardPage> createState() => _FacilityAdminDashboardPageState();
}

class _FacilityAdminDashboardPageState extends ConsumerState<FacilityAdminDashboardPage> {
  FacilityAnalyticsModel? _analytics;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final analyticsService = ref.read(facilityAnalyticsServiceProvider);
      final analytics = await analyticsService.getFacilityAnalytics(widget.facilityId);
      setState(() {
        _analytics = analytics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading analytics',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: AppTextStyles.body2.copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAnalytics,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _analytics == null
                  ? const Center(child: Text('No data available'))
                  : RefreshIndicator(
                      onRefresh: _loadAnalytics,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Facility Name
                            Text(
                              _analytics!.facilityName,
                              style: AppTextStyles.h2,
                            ),
                            const SizedBox(height: 24),

                            // KPI Cards
                            _buildKpiGrid(),
                            const SizedBox(height: 24),

                            // Summary Section
                            _buildSummarySection(),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildKpiGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildKpiCard(
          'Vaccinations Today',
          _analytics!.vaccinationsToday.toString(),
          Icons.calendar_today,
          AppTheme.primaryColor,
        ),
        _buildKpiCard(
          'This Month',
          _analytics!.vaccinationsLast30Days.toString(),
          Icons.trending_up,
          Colors.green,
        ),
        _buildKpiCard(
          'Upcoming Due',
          _analytics!.upcomingDueVaccinations.toString(),
          Icons.schedule,
          Colors.orange,
        ),
        _buildKpiCard(
          'Missed',
          _analytics!.missedVaccinations.toString(),
          Icons.error_outline,
          Colors.red,
        ),
        _buildKpiCard(
          'Doctors',
          _analytics!.doctorsCount.toString(),
          Icons.medical_services,
          Colors.blue,
        ),
        _buildKpiCard(
          'Staff',
          _analytics!.staffCount.toString(),
          Icons.people,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(
              value,
              style: AppTextStyles.h2.copyWith(
                color: color,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Total Users', _analytics!.totalUsers.toString()),
            _buildSummaryRow('Vaccinations Completed', _analytics!.vaccinationsCompleted.toString()),
            _buildSummaryRow('Vaccinations Pending', _analytics!.vaccinationsPending.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2,
          ),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


