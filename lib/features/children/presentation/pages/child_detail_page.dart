import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class ChildDetailPage extends StatelessWidget {
  final int childId;

  const ChildDetailPage({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit child
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                      child: const Icon(
                        Icons.child_care,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Child $childId',
                      style: AppTextStyles.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2 years, 3 months old',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActionCard(
                    context,
                    title: 'Vaccination History',
                    subtitle: '12 vaccines recorded',
                    icon: Icons.vaccines,
                    color: AppTheme.successColor,
                    onTap: () => context.push('/vaccinations/$childId'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    title: 'Vaccination Schedule',
                    subtitle: '3 upcoming vaccines',
                    icon: Icons.calendar_today,
                    color: AppTheme.warningColor,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    title: 'Documents',
                    subtitle: '5 files uploaded',
                    icon: Icons.folder,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    context,
                    title: 'QR Code',
                    subtitle: 'View & Share',
                    icon: Icons.qr_code,
                    color: AppTheme.secondaryColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
        )),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}





