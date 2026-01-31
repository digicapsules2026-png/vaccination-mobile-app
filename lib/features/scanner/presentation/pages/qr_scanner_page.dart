import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_theme.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isProcessing = true);

    // Process QR code
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(
              cameraController.torchEnabled
                  ? Icons.flash_on
                  : Icons.flash_off,
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          // Scan overlay
          CustomPaint(
            painter: ScanOverlayPainter(),
            child: Container(),
          ),
          // Instructions
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Place QR code within the frame',
                style: AppTextStyles.body2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final double scanSize = size.width * 0.7;
    final double left = (size.width - scanSize) / 2;
    final double top = (size.height - scanSize) / 2;

    // Draw overlay
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final scanArea = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanSize, scanSize),
        const Radius.circular(12),
      ));

    final overlayPath = Path.combine(
      PathOperation.difference,
      path,
      scanArea,
    );

    canvas.drawPath(overlayPath, paint);

    // Draw corner borders
    final borderPaint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cornerSize = 30.0;

    // Top-left
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerSize, top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerSize),
      borderPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(left + scanSize, top),
      Offset(left + scanSize - cornerSize, top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + scanSize, top),
      Offset(left + scanSize, top + cornerSize),
      borderPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(left, top + scanSize),
      Offset(left + cornerSize, top + scanSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanSize),
      Offset(left, top + scanSize - cornerSize),
      borderPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(left + scanSize, top + scanSize),
      Offset(left + scanSize - cornerSize, top + scanSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + scanSize, top + scanSize),
      Offset(left + scanSize, top + scanSize - cornerSize),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}











