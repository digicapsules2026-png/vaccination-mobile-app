import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../features/beneficiaries/data/models/timeline_model.dart';
import '../../features/beneficiaries/data/models/beneficiary_model.dart';

/// Generate PDF immunization report showing only administered vaccines
Future<Uint8List> generateImmunizationReportPDF({
  required BeneficiaryModel beneficiary,
  required VaccinationTimelineResponse timelineData,
}) async {
  final pdf = pw.Document();

  // Filter only administered (COMPLETED) vaccines
  final administeredVaccines = timelineData.timeline
      .where((item) => item.status.toUpperCase() == 'COMPLETED')
      .toList();

  // Date formatter
  final dateFormat = DateFormat('MMMM dd, yyyy');

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (pw.Context context) {
        return [
          // Title
          pw.Header(
            level: 0,
            child: pw.Text(
              'Immunization Report',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Beneficiary Information
          pw.Text(
            'Beneficiary Information',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(4),
            },
            children: [
              _buildTableRow('Name:', '${beneficiary.firstName} ${beneficiary.lastName}'),
              _buildTableRow(
                'Date of Birth:',
                beneficiary.dateOfBirth != null
                    ? dateFormat.format(beneficiary.dateOfBirth)
                    : 'N/A',
              ),
              _buildTableRow('Gender:', beneficiary.gender ?? 'N/A'),
            ],
          ),
          pw.SizedBox(height: 30),

          // Administered Vaccines Section
          pw.Text(
            'Administered Vaccinations (${administeredVaccines.length} total)',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          if (administeredVaccines.isEmpty)
            pw.Text(
              'No administered vaccinations recorded yet.',
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
            )
          else
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(2),
              },
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue,
              ),
              headerHeight: 40,
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue),
                  children: [
                    _buildHeaderCell('Vaccine Name'),
                    _buildHeaderCell('Dose'),
                    _buildHeaderCell('Date Administered'),
                    _buildHeaderCell('Batch Number'),
                    _buildHeaderCell('Manufacturer'),
                  ],
                ),
                // Data rows
                ...administeredVaccines.map((vaccine) {
                  final vaccinatedDate = vaccine.vaccinatedOn != null
                      ? dateFormat.format(vaccine.vaccinatedOn!)
                      : 'N/A';

                  return pw.TableRow(
                    children: [
                      _buildDataCell(vaccine.vaccineName),
                      _buildDataCell(vaccine.dose),
                      _buildDataCell(vaccinatedDate),
                      _buildDataCell(vaccine.batchNumber ?? 'N/A'),
                      _buildDataCell(vaccine.manufacturer ?? 'N/A'),
                    ],
                  );
                }),
              ],
            ),

          pw.Spacer(),

          // Footer
          pw.Footer(
            child: pw.Text(
              'Generated on ${dateFormat.format(DateTime.now())}',
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey,
              ),
            ),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}

pw.TableRow _buildTableRow(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          label,
          style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(value),
      ),
    ],
  );
}

pw.Widget _buildHeaderCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
      ),
    ),
  );
}

pw.Widget _buildDataCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(
      text,
      style: const pw.TextStyle(fontSize: 9),
    ),
  );
}

/// Download PDF report
Future<void> downloadImmunizationReport({
  required BeneficiaryModel beneficiary,
  required VaccinationTimelineResponse timelineData,
}) async {
  final pdfBytes = await generateImmunizationReportPDF(
    beneficiary: beneficiary,
    timelineData: timelineData,
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdfBytes,
  );
}

/// Share PDF report
Future<void> shareImmunizationReport({
  required BeneficiaryModel beneficiary,
  required VaccinationTimelineResponse timelineData,
}) async {
  final pdfBytes = await generateImmunizationReportPDF(
    beneficiary: beneficiary,
    timelineData: timelineData,
  );

  await Printing.sharePdf(
    bytes: pdfBytes,
    filename: 'immunization_report_${beneficiary.firstName}_${beneficiary.lastName}.pdf',
  );
}

