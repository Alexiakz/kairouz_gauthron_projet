import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController? _controller;
  bool _hasScanned = false;
  bool _hasError = false;

  bool get _isMobile => Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    if (_isMobile) {
      _controller = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null && barcode!.rawValue!.isNotEmpty) {
      _hasScanned = true;
      Navigator.of(context).pop(barcode.rawValue);
    }
  }

  void _showManualEntry() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saisir un code-barres'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ex : 3017620422003',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(value);
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un code-barres'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            tooltip: 'Saisie manuelle',
            onPressed: _showManualEntry,
          ),
        ],
      ),
      body: _isMobile && !_hasError
          ? Stack(
              children: [
                MobileScanner(
                  controller: _controller!,
                  onDetect: _onDetect,
                  errorBuilder: (_, error, __) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _hasError = true);
                    });
                    return const SizedBox.shrink();
                  },
                ),
                Center(
                  child: Container(
                    width: 280.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40.0,
                  left: 0.0,
                  right: 0.0,
                  child: Center(
                    child: Text(
                      'Placez le code-barres dans le cadre',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(blurRadius: 8.0, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildManualFallback(),
    );
  }

  Widget _buildManualFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined,
                size: 64.0, color: AppColors.grey2),
            const SizedBox(height: 16.0),
            const Text(
              'Cam\u00e9ra non disponible sur cet appareil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: AppColors.grey2),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: _showManualEntry,
              icon: const Icon(Icons.keyboard),
              label: const Text('Saisir le code-barres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
