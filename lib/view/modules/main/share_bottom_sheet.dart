import 'package:linkable/environments.dart';
import 'package:flutter/material.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key, required this.shortId});

  final String shortId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: LightColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 32.0,
          right: 32.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LightColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            
            // Icon and title
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: LightColors.accent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: LightColors.border, width: 1),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 32,
                color: LightColors.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              "Share Your Note",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: LightColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              "Scan this QR code to access your note\nfrom any device, anywhere.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: LightColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            
            // QR Code container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: LightColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: LightColors.primaryText.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: QrImageView(
                data: "${EnviromentConstants.redirectUrl}/ref/$shortId",
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                foregroundColor: LightColors.primaryText,
                padding: const EdgeInsets.all(0),
              ),
            ),
            const SizedBox(height: 32),
            
            // Footer text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: LightColors.muted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LightColors.border, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: LightColors.secondaryText,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Always accessible",
                    style: TextStyle(
                      fontSize: 13,
                      color: LightColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
