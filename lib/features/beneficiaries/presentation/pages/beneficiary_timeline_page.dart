import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../data/models/timeline_model.dart';

class BeneficiaryTimelinePage extends ConsumerStatefulWidget {
  final int beneficiaryId;
  final int? childId;

  const BeneficiaryTimelinePage({
    super.key,
    required this.beneficiaryId,
    this.childId,
  });

  @override
  ConsumerState<BeneficiaryTimelinePage> createState() => _BeneficiaryTimelinePageState();
}

class _BeneficiaryTimelinePageState extends ConsumerState<BeneficiaryTimelinePage> {
  VaccinationTimelineResponse? _timelineData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  Future<void> _loadTimeline() async {
    try {
      final service = ref.read(beneficiariesServiceProvider);
      final timeline = await service.getVaccinationTimeline(widget.beneficiaryId);
      setState(() {
        _timelineData = timeline;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load timeline: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return AppTheme.successColor;
      case 'UPCOMING':
        return AppTheme.warningColor;
      case 'DUE_NEXT':
      case 'FUTURE':
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Icons.check_circle;
      case 'UPCOMING':
        return Icons.schedule;
      default:
        return Icons.calendar_today;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'Administered';
      case 'UPCOMING':
        return 'Due / Upcoming';
      case 'DUE_NEXT':
      case 'FUTURE':
        return 'Due Next';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_timelineData == null || _timelineData!.timeline.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No vaccination timeline available', style: AppTextStyles.body2),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _timelineData!.timeline.length,
      itemBuilder: (context, index) {
        final item = _timelineData!.timeline[index];
        final statusColor = _getStatusColor(item.status);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              if (item.vaccinationId != null) {
                context.push('/vaccinations/${item.vaccinationId}/detail');
              } else {
                context.push(
                  '/vaccinations/detail?beneficiaryId=${widget.beneficiaryId}&vaccineCode=${item.vaccineCode}&doseNumber=${item.doseNumber}',
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Indicator
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(item.status),
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.vaccineName,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dose ${item.doseNumber}',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusLabel(item.status),
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (item.dueDate != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Due: ${item.dueDate.toString().split(' ')[0]}',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

