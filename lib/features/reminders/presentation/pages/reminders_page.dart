import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../data/models/reminder_model.dart';

class RemindersPage extends ConsumerStatefulWidget {
  final int beneficiaryId;

  const RemindersPage({
    super.key,
    required this.beneficiaryId,
  });

  @override
  ConsumerState<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<RemindersPage> {
  List<VaccinationReminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final service = ref.read(remindersServiceProvider);
      final reminders = await service.getUpcomingReminders(widget.beneficiaryId, daysInAdvance: 30);
      setState(() {
        _reminders = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reminders: $e')),
        );
      }
    }
  }

  Color _getReminderColor(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.pending:
        return AppTheme.warningColor;
      case ReminderStatus.sent:
        return AppTheme.successColor;
      case ReminderStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getReminderLabel(ReminderType type) {
    switch (type) {
      case ReminderType.beforeDue:
        return 'Before Due Date';
      case ReminderType.onDue:
        return 'On Due Date';
      case ReminderType.afterMissed:
        return 'Missed Reminder';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to reminder settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No upcoming reminders',
                        style: AppTextStyles.body2.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadReminders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      final statusColor = _getReminderColor(reminder.status);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: statusColor,
                            ),
                          ),
                          title: Text(
                            reminder.vaccineName ?? 'Vaccine',
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Due: ${reminder.reminderDate.toString().split(' ')[0]}'),
                              const SizedBox(height: 4),
                              Text(
                                _getReminderLabel(reminder.reminderType),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              reminder.status.toString().split('.').last.toUpperCase(),
                              style: AppTextStyles.caption.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}







