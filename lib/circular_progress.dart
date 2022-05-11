import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class CoinbitCircularProgressOptions {
  final double? radius;
  final double progress;
  final Color valueColor;
  final Color backgroundColor;
  final double strokeWidth;

  CoinbitCircularProgressOptions({
    this.radius,
    required this.progress,
    this.valueColor = Colors.green,
    this.backgroundColor = Colors.black12,
    this.strokeWidth = 5,
  }) : super();
}

class CoinbitCircularProgress extends StatelessWidget {
  final CoinbitCircularProgressOptions? coinbitCircularProgressOptions;

  const CoinbitCircularProgress({
    Key? key,
    required this.coinbitCircularProgressOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: Size(
            coinbitCircularProgressOptions!.radius ?? constraints.maxWidth / 2,
            coinbitCircularProgressOptions!.radius ?? constraints.maxWidth / 2,
          ),
          painter: CirleBar(
            coinbitCircularProgressOptions: CoinbitCircularProgressOptions(
              progress: coinbitCircularProgressOptions!.progress,
              radius: coinbitCircularProgressOptions!.radius ??
                  constraints.maxWidth / 2,
              valueColor: coinbitCircularProgressOptions!.valueColor,
              backgroundColor: coinbitCircularProgressOptions!.backgroundColor,
              strokeWidth: coinbitCircularProgressOptions!.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class CirleBar extends CustomPainter {
  final CoinbitCircularProgressOptions? coinbitCircularProgressOptions;

  CirleBar({
    this.coinbitCircularProgressOptions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      coinbitCircularProgressOptions!.radius! / 2,
      coinbitCircularProgressOptions!.radius! / 2,
    );

    canvas.drawCircle(
      center,
      coinbitCircularProgressOptions!.radius! / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = coinbitCircularProgressOptions!.backgroundColor
        ..strokeWidth = coinbitCircularProgressOptions!.strokeWidth,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: coinbitCircularProgressOptions!.radius!,
        height: coinbitCircularProgressOptions!.radius!,
      ),
      vmath.radians(90),
      vmath.radians(coinbitCircularProgressOptions!.progress * 360),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = coinbitCircularProgressOptions!.valueColor
        ..strokeWidth = coinbitCircularProgressOptions!.strokeWidth,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
