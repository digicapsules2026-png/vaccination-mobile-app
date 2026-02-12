import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VialScannerPage extends StatefulWidget {
  const VialScannerPage({super.key});

  @override
  State<VialScannerPage> createState() => _VialScannerPageState();
}

class _VialScannerPageState extends State<VialScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? barcode = barcodes.first.rawValue;
    if (barcode != null) {
      Navigator.pop(context, barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Vial Barcode'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text(
              'Scan the barcode on the vaccine vial',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}




















