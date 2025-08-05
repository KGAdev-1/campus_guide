import 'package:flutter/material.dart';

class CampusLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const CampusLogo({
    super.key,
    this.size = 100,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: CampusLogoPainter(
            primaryColor: Theme.of(context).colorScheme.primary,
            secondaryColor: Theme.of(context).colorScheme.secondary,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'Campus Guide',
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class CampusLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  CampusLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = isDark ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Main building (center)
    final buildingPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final mainBuilding = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.3,
        height: size.height * 0.5,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(mainBuilding, buildingPaint);

    // Building windows
    final windowPaint = Paint()
      ..color = isDark ? Colors.white : Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        final windowRect = Rect.fromCenter(
          center: Offset(
            center.dx - size.width * 0.05 + (j * size.width * 0.1),
            center.dy - size.height * 0.1 + (i * size.height * 0.08),
          ),
          width: size.width * 0.04,
          height: size.width * 0.04,
        );
        canvas.drawRect(windowRect, windowPaint);
      }
    }

    // Side buildings
    final sideBuildingPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    // Left building
    final leftBuilding = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.25, center.dy + size.height * 0.05),
        width: size.width * 0.2,
        height: size.height * 0.35,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(leftBuilding, sideBuildingPaint);

    // Right building
    final rightBuilding = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.25, center.dy + size.height * 0.05),
        width: size.width * 0.2,
        height: size.height * 0.35,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(rightBuilding, sideBuildingPaint);

    // Navigation compass/pin overlay
    final compassPaint = Paint()
      ..color = isDark ? Colors.orange : Colors.deepOrange
      ..style = PaintingStyle.fill;

    // Compass circle
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.3, center.dy - size.height * 0.3),
      size.width * 0.08,
      compassPaint,
    );

    // Compass needle
    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final needlePath = Path();
    final compassCenter = Offset(center.dx + size.width * 0.3, center.dy - size.height * 0.3);
    needlePath.moveTo(compassCenter.dx, compassCenter.dy - size.width * 0.05);
    needlePath.lineTo(compassCenter.dx - size.width * 0.02, compassCenter.dy + size.width * 0.03);
    needlePath.lineTo(compassCenter.dx + size.width * 0.02, compassCenter.dy + size.width * 0.03);
    needlePath.close();
    canvas.drawPath(needlePath, needlePaint);

    // Path/road
    final pathPaint = Paint()
      ..color = isDark ? Colors.grey.shade600 : Colors.grey.shade400
      ..style = PaintingStyle.fill;

    final pathRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        center.dy + size.height * 0.25,
        size.width * 0.8,
        size.height * 0.08,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(pathRect, pathPaint);

    // Trees (decorative elements)
    final treePaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.fill;

    // Left tree
    canvas.drawCircle(
      Offset(size.width * 0.15, center.dy - size.height * 0.1),
      size.width * 0.06,
      treePaint,
    );

    // Right tree
    canvas.drawCircle(
      Offset(size.width * 0.85, center.dy - size.height * 0.1),
      size.width * 0.06,
      treePaint,
    );

    // Border circle
    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    canvas.drawCircle(center, radius - size.width * 0.01, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
