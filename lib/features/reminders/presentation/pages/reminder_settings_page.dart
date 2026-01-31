import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../data/models/reminder_model.dart';

class ReminderSettingsPage extends ConsumerStatefulWidget {
  final int beneficiaryId;

  const ReminderSettingsPage({
    super.key,
    required this.beneficiaryId,
  });

  @override
  ConsumerState<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends ConsumerState<ReminderSettingsPage> {
  List<NotificationChannel> _selectedChannels = [NotificationChannel.push];
  bool _enableReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable Reminders Toggle
          Card(
            child: SwitchListTile(
              title: const Text('Enable Reminders'),
              subtitle: const Text('Receive notifications for upcoming vaccinations'),
              value: _enableReminders,
              onChanged: (value) {
                setState(() {
                  _enableReminders = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Notification Channels
          Text('Notification Channels', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive push notifications on your device'),
                  value: _selectedChannels.contains(NotificationChannel.push),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedChannels.add(NotificationChannel.push);
                      } else {
                        _selectedChannels.remove(NotificationChannel.push);
                      }
                    });
                  },
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text('SMS'),
                  subtitle: const Text('Receive text message reminders'),
                  value: _selectedChannels.contains(NotificationChannel.sms),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedChannels.add(NotificationChannel.sms);
                      } else {
                        _selectedChannels.remove(NotificationChannel.sms);
                      }
                    });
                  },
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text('Email'),
                  subtitle: const Text('Receive email reminders'),
                  value: _selectedChannels.contains(NotificationChannel.email),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedChannels.add(NotificationChannel.email);
                      } else {
                        _selectedChannels.remove(NotificationChannel.email);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reminder Timing Info
          Card(
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Reminder Schedule',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Reminders are automatically scheduled for:',
                    style: AppTextStyles.body2,
                  ),
                  const SizedBox(height: 8),
                  _buildReminderTiming('7 days before due date'),
                  _buildReminderTiming('1 day before due date'),
                  _buildReminderTiming('On due date'),
                  _buildReminderTiming('7 days after if missed'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: () {
              // Save settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved')),
              );
            },
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTiming(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: AppTheme.successColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.body2)),
        ],
      ),
    );
  }
}







