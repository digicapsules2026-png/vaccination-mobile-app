import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../../../core/utils/vaccine_education.dart';
import '../../data/models/vaccination_model.dart';

class VaccinationDetailPage extends ConsumerStatefulWidget {
  final int vaccinationId;

  const VaccinationDetailPage({
    super.key,
    required this.vaccinationId,
  });

  @override
  ConsumerState<VaccinationDetailPage> createState() => _VaccinationDetailPageState();
}

class _VaccinationDetailPageState extends ConsumerState<VaccinationDetailPage> {
  VaccinationModel? _vaccination;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccination();
  }

  Future<void> _loadVaccination() async {
    try {
      final service = ref.read(vaccinationsServiceProvider);
      final vaccination = await service.getVaccinationById(widget.vaccinationId);
      setState(() {
        _vaccination = vaccination;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load vaccination: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_vaccination == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vaccination Not Found')),
        body: const Center(child: Text('Vaccination not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_vaccination!.vaccineName ?? 'Vaccination Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Administered',
                style: AppTextStyles.body2.copyWith(
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Vaccine Information
            Text('Vaccine Information', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Vaccine Name', _vaccination!.vaccineName ?? 'Unknown'),
                    const Divider(),
                    _buildInfoRow('Dose Number', '${_vaccination!.doseNumber}'),
                    if (_vaccination!.vaccinationDate != null) ...[
                      const Divider(),
                      _buildInfoRow(
                        'Date Administered',
                        _vaccination!.vaccinationDate.toString().split(' ')[0],
                      ),
                    ],
                    if (_vaccination!.batchNumber != null) ...[
                      const Divider(),
                      _buildInfoRow('Batch Number', _vaccination!.batchNumber!),
                    ],
                    if (_vaccination!.manufacturer != null) ...[
                      const Divider(),
                      _buildInfoRow('Manufacturer', _vaccination!.manufacturer!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Why this vaccination
            ExpansionTile(
              leading: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
              title: const Text('Why this vaccination is given'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    VaccineEducation.getEducationContent(_vaccination!.vaccineCode ?? ''),
                    style: AppTextStyles.body2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Vitals (if available)
            if (_vaccination!.temperature != null || _vaccination!.weight != null) ...[
              Text('Vitals at Vaccination', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_vaccination!.temperature != null)
                        _buildInfoRow(
                          'Temperature',
                          '${_vaccination!.temperature} ${_vaccination!.temperatureUnit ?? "°C"}',
                        ),
                      if (_vaccination!.weight != null) ...[
                        if (_vaccination!.temperature != null) const Divider(),
                        _buildInfoRow('Weight', '${_vaccination!.weight} kg'),
                      ],
                      if (_vaccination!.height != null) ...[
                        const Divider(),
                        _buildInfoRow('Height', '${_vaccination!.height} cm'),
                      ],
                      if (_vaccination!.pulseRate != null) ...[
                        const Divider(),
                        _buildInfoRow('Pulse Rate', '${_vaccination!.pulseRate} bpm'),
                      ],
                      if (_vaccination!.oxygenSaturation != null) ...[
                        const Divider(),
                        _buildInfoRow('Oxygen Saturation', '${_vaccination!.oxygenSaturation}%'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
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
}












