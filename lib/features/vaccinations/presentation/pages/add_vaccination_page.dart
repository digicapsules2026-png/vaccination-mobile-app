import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/services_provider.dart';
import '../../../vaccines/data/models/vaccine_model.dart';
import '../../data/models/vaccination_model.dart';

class AddVaccinationPage extends ConsumerStatefulWidget {
  final int? childId;
  final int? beneficiaryId;

  const AddVaccinationPage({
    super.key,
    this.childId,
    this.beneficiaryId,
  });

  @override
  ConsumerState<AddVaccinationPage> createState() => _AddVaccinationPageState();
}

class _AddVaccinationPageState extends ConsumerState<AddVaccinationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _showOptionalVitals = false;

  // Vaccine selection
  List<VaccineModel> _vaccines = [];
  int? _selectedVaccineId;

  // Form fields
  final _vaccineNameController = TextEditingController();
  final _doseNumberController = TextEditingController(text: '1');
  DateTime? _vaccinationDate;
  String _status = 'completed';
  final _administeredByController = TextEditingController();
  final _hospitalIdController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _siteOfAdministrationController = TextEditingController();
  final _routeOfAdministrationController = TextEditingController();
  bool _adverseReaction = false;
  final _reactionDetailsController = TextEditingController();
  final _notesController = TextEditingController();

  // Vitals
  final _temperatureController = TextEditingController();
  String _temperatureUnit = 'C';
  final _weightController = TextEditingController();
  final _heightLengthController = TextEditingController();
  final _pulseRateController = TextEditingController();
  final _oxygenSaturationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vaccinationDate = DateTime.now();
    _loadVaccines();
  }

  @override
  void dispose() {
    _vaccineNameController.dispose();
    _doseNumberController.dispose();
    _administeredByController.dispose();
    _hospitalIdController.dispose();
    _batchNumberController.dispose();
    _manufacturerController.dispose();
    _siteOfAdministrationController.dispose();
    _routeOfAdministrationController.dispose();
    _reactionDetailsController.dispose();
    _notesController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _heightLengthController.dispose();
    _pulseRateController.dispose();
    _oxygenSaturationController.dispose();
    super.dispose();
  }

  Future<void> _loadVaccines() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(vaccinesServiceProvider);
      final vaccines = await service.getVaccines();
      setState(() {
        _vaccines = vaccines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load vaccines: $e')),
        );
      }
    }
  }

  void _onVaccineSelected(int? vaccineId) {
    setState(() {
      _selectedVaccineId = vaccineId;
      if (vaccineId != null) {
        final vaccine = _vaccines.firstWhere((v) => v.id == vaccineId);
        _vaccineNameController.text = vaccine.vaccineName;
        _manufacturerController.text = vaccine.manufacturer ?? '';
        _routeOfAdministrationController.text = vaccine.routeOfAdministration ?? '';
        _siteOfAdministrationController.text = vaccine.siteOfAdministration ?? '';
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _vaccinationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _vaccinationDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!widget.childId && !widget.beneficiaryId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Child ID or Beneficiary ID is required')),
      );
      return;
    }

    if (_selectedVaccineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vaccine')),
      );
      return;
    }

    // Validate vitals
    if (_temperatureController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Temperature is required')),
      );
      return;
    }

    final tempValue = double.tryParse(_temperatureController.text.trim());
    if (tempValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Temperature must be a valid number')),
      );
      return;
    }

    // Convert to Celsius for validation
    final tempInCelsius = _temperatureUnit == 'F' ? (tempValue - 32) * 5 / 9 : tempValue;
    if (tempInCelsius < 35 || tempInCelsius > 42) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Temperature ${_temperatureController.text}°$_temperatureUnit is outside normal range (35-42°C or 95-107.6°F)')),
      );
      return;
    }

    if (_weightController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight is required')),
      );
      return;
    }

    final weightValue = double.tryParse(_weightController.text.trim());
    if (weightValue == null || weightValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight must be a positive number greater than zero')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final service = ref.read(vaccinationsServiceProvider);
      final data = <String, dynamic>{
        if (widget.beneficiaryId != null) 'beneficiary_id': widget.beneficiaryId,
        if (widget.childId != null) 'child_id': widget.childId,
        'vaccine_id': _selectedVaccineId!,
        'vaccine_name': _vaccineNameController.text.trim(),
        'dose_number': int.parse(_doseNumberController.text.trim()),
        'vaccination_date': _vaccinationDate!.toIso8601String().split('T')[0],
        'status': _status,
        'temperature': _temperatureController.text.trim(),
        'temperature_unit': _temperatureUnit,
        'weight': _weightController.text.trim(),
        if (_administeredByController.text.trim().isNotEmpty)
          'administered_by': _administeredByController.text.trim(),
        if (_hospitalIdController.text.trim().isNotEmpty)
          'hospital_id': int.parse(_hospitalIdController.text.trim()),
        if (_batchNumberController.text.trim().isNotEmpty)
          'batch_number': _batchNumberController.text.trim(),
        if (_manufacturerController.text.trim().isNotEmpty)
          'manufacturer': _manufacturerController.text.trim(),
        if (_siteOfAdministrationController.text.trim().isNotEmpty)
          'site_of_administration': _siteOfAdministrationController.text.trim(),
        if (_routeOfAdministrationController.text.trim().isNotEmpty)
          'route_of_administration': _routeOfAdministrationController.text.trim(),
        'adverse_reaction': _adverseReaction,
        if (_reactionDetailsController.text.trim().isNotEmpty)
          'reaction_details': _reactionDetailsController.text.trim(),
        if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
        if (_heightLengthController.text.trim().isNotEmpty)
          'height_length': _heightLengthController.text.trim(),
        if (_pulseRateController.text.trim().isNotEmpty)
          'pulse_rate': int.parse(_pulseRateController.text.trim()),
        if (_oxygenSaturationController.text.trim().isNotEmpty)
          'oxygen_saturation': _oxygenSaturationController.text.trim(),
      };

      await service.createVaccination(data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaccination record created successfully!')),
        );
        // Navigate back
        if (widget.beneficiaryId != null) {
          context.push('/beneficiaries/${widget.beneficiaryId}');
        } else if (widget.childId != null) {
          context.push('/children/${widget.childId}');
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create vaccination: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vaccination Record'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vaccine Information
                    Text('Vaccine Information', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: 'Select Vaccine *',
                                prefixIcon: Icon(Icons.vaccines),
                              ),
                              value: _selectedVaccineId,
                              items: _vaccines.map((vaccine) {
                                return DropdownMenuItem<int>(
                                  value: vaccine.id,
                                  child: Text('${vaccine.vaccineName} (${vaccine.vaccineCode})'),
                                );
                              }).toList(),
                              onChanged: _onVaccineSelected,
                              validator: (value) => value == null ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _vaccineNameController,
                              decoration: const InputDecoration(
                                labelText: 'Vaccine Name *',
                              ),
                              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _doseNumberController,
                                    decoration: const InputDecoration(
                                      labelText: 'Dose Number *',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectDate(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Vaccination Date *',
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                      child: Text(
                                        _vaccinationDate == null
                                            ? 'Select date'
                                            : '${_vaccinationDate!.day}/${_vaccinationDate!.month}/${_vaccinationDate!.year}',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'Status *'),
                              value: _status,
                              items: const [
                                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                                DropdownMenuItem(value: 'scheduled', child: Text('Scheduled')),
                                DropdownMenuItem(value: 'missed', child: Text('Missed')),
                                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                              ],
                              onChanged: (value) => setState(() => _status = value!),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Vitals at Time of Vaccination
                    Card(
                      color: AppTheme.primaryColor.withOpacity(0.05),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.health_and_safety, color: AppTheme.primaryColor),
                                const SizedBox(width: 8),
                                Text('Vitals at Time of Vaccination', style: AppTextStyles.h3),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Vaccination should be avoided if the child has fever (temperature above 37.5°C or 99.5°F).',
                              style: AppTextStyles.caption.copyWith(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 16),
                            // Mandatory Vitals
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _temperatureController,
                                    decoration: InputDecoration(
                                      labelText: 'Temperature * (Required)',
                                      suffixIcon: DropdownButton<String>(
                                        value: _temperatureUnit,
                                        items: const [
                                          DropdownMenuItem(value: 'C', child: Text('°C')),
                                          DropdownMenuItem(value: 'F', child: Text('°F')),
                                        ],
                                        onChanged: (value) => setState(() => _temperatureUnit = value!),
                                      ),
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _weightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Weight (kg) * (Required)',
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Normal range: 36.1-37.5°C (97-99.5°F)',
                              style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            // Optional Vitals
                            ExpansionTile(
                              leading: const Icon(Icons.expand_more),
                              title: const Text('Additional vitals (optional)'),
                              initiallyExpanded: _showOptionalVitals,
                              onExpansionChanged: (expanded) =>
                                  setState(() => _showOptionalVitals = expanded),
                              children: [
                                TextFormField(
                                  controller: _heightLengthController,
                                  decoration: const InputDecoration(
                                    labelText: 'Height / Length (cm)',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _pulseRateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Pulse Rate (bpm)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _oxygenSaturationController,
                                  decoration: const InputDecoration(
                                    labelText: 'Oxygen Saturation SpO₂ (%)',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Administration Details
                    Text('Administration Details', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _administeredByController,
                              decoration: const InputDecoration(
                                labelText: 'Administered By',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _hospitalIdController,
                              decoration: const InputDecoration(
                                labelText: 'Hospital ID',
                                prefixIcon: Icon(Icons.local_hospital),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _siteOfAdministrationController,
                                    decoration: const InputDecoration(
                                      labelText: 'Site of Administration',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _routeOfAdministrationController,
                                    decoration: const InputDecoration(
                                      labelText: 'Route of Administration',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _batchNumberController,
                                    decoration: const InputDecoration(
                                      labelText: 'Batch Number',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _manufacturerController,
                                    decoration: const InputDecoration(
                                      labelText: 'Manufacturer',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSubmit,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Vaccination Record'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}







