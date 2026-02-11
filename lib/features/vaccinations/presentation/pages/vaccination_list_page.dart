import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class VaccinationListPage extends StatelessWidget {
  final int childId;

  const VaccinationListPage({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                ),
              ),
              title: Text('Vaccine ${index + 1}'),
              subtitle: const Text('Administered on 15 Jan 2024'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // View details
              },
            ),
          );
        },
      ),
    );
  }
}
















