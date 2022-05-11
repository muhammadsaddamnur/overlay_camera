import 'package:flutter/material.dart';
// import 'dart:math' as Math;
import 'package:path_drawing/path_drawing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://i.redd.it/318zawfomti51.jpg',
            fit: BoxFit.cover,
          ),
          rectangleOverlay(context),
          // customOverlay(context),
          Text('sdasndasdkmk')
        ],
      ),
    );
  }
}

Widget rectangleOverlay(BuildContext context) {
  return ColorFiltered(
    colorFilter:
        ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOut),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          child: Align(
            child: CustomPaint(
              painter: Rectangle(),
              size: const Size(335, 194),
            ),
          ),
          decoration: const BoxDecoration(
              color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
        ),
      ],
    ),
  );
}

Widget customOverlay(BuildContext context) {
  return ColorFiltered(
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8),
        BlendMode.srcOut), // This one will create the magic
    child: Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: CustomPaint(
                        painter: Custom(),
                        size: const Size(200, 200),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: CustomPaint(
                        painter: Rectangle(),
                        size: const Size(200, 200),
                      ),
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                    color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class Custom extends CustomPainter {
  bool? isFilled;
  Custom({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Paint paint2 = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    Path path = Path();

    // Path number 1
    paint.color = const Color(0xffffffff).withOpacity(1);
    path = Path();
    path.moveTo(size.width * 1.05, size.height * 1.04);
    path.lineTo(size.width * 1.05, size.height * 1.04);
    path.cubicTo(size.width * 1.05, size.height * 1.04, size.width * 0.55,
        size.height * 0.76, size.width * 0.55, size.height * 0.76);
    path.cubicTo(size.width * 0.55, size.height * 0.76, size.width * 0.05,
        size.height * 1.04, size.width * 0.05, size.height * 1.04);
    path.cubicTo(size.width * 0.05, size.height * 1.04, size.width * 0.05,
        size.height * 0.15, size.width * 0.05, size.height * 0.15);
    path.cubicTo(size.width * 0.05, size.height * 0.12, size.width * 0.07,
        size.height * 0.09, size.width * 0.09, size.height * 0.07);
    path.cubicTo(size.width * 0.12, size.height * 0.05, size.width * 0.16,
        size.height * 0.04, size.width * 0.19, size.height * 0.04);
    path.cubicTo(size.width * 0.19, size.height * 0.04, size.width * 0.91,
        size.height * 0.04, size.width * 0.91, size.height * 0.04);
    path.cubicTo(size.width * 0.95, size.height * 0.04, size.width * 0.98,
        size.height * 0.05, size.width, size.height * 0.07);
    path.cubicTo(size.width * 1.04, size.height * 0.09, size.width * 1.05,
        size.height * 0.12, size.width * 1.05, size.height * 0.15);
    path.cubicTo(size.width * 1.05, size.height * 0.15, size.width * 1.05,
        size.height * 1.04, size.width * 1.05, size.height * 1.04);
    path.cubicTo(size.width * 1.05, size.height * 1.04, size.width * 1.05,
        size.height * 1.04, size.width * 1.05, size.height * 1.04);
    canvas.drawPath(path, paint2);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(
          <double>[5.0, 20],
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

class Rectangle extends CustomPainter {
  bool? isFilled;
  Rectangle({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Paint paint2 = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    Path path = Path();

    // Path number 1
    paint.color = const Color(0xffffffff).withOpacity(1);
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        const Radius.circular(15)));
    canvas.drawPath(path, paint2);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(
          <double>[5.0, 20],
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}



// class Rectangle extends CustomPainter {
//   bool? isFilled;
//   Rectangle({this.isFilled});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.white
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//     Path path = Path();

//     // Path number 1
//     paint.color = const Color(0xffffffff).withOpacity(1);
//     path = Path();
//     path.moveTo(size.width * 1.05, size.height * 1.04);
//     path.lineTo(size.width * 1.05, size.height * 1.04);
//     path.cubicTo(size.width * 1.05, size.height * 1.04, size.width * 0.55,
//         size.height * 0.76, size.width * 0.55, size.height * 0.76);
//     path.cubicTo(size.width * 0.55, size.height * 0.76, size.width * 0.05,
//         size.height * 1.04, size.width * 0.05, size.height * 1.04);
//     path.cubicTo(size.width * 0.05, size.height * 1.04, size.width * 0.05,
//         size.height * 0.15, size.width * 0.05, size.height * 0.15);
//     path.cubicTo(size.width * 0.05, size.height * 0.12, size.width * 0.07,
//         size.height * 0.09, size.width * 0.09, size.height * 0.07);
//     path.cubicTo(size.width * 0.12, size.height * 0.05, size.width * 0.16,
//         size.height * 0.04, size.width * 0.19, size.height * 0.04);
//     path.cubicTo(size.width * 0.19, size.height * 0.04, size.width * 0.91,
//         size.height * 0.04, size.width * 0.91, size.height * 0.04);
//     path.cubicTo(size.width * 0.95, size.height * 0.04, size.width * 0.98,
//         size.height * 0.05, size.width, size.height * 0.07);
//     path.cubicTo(size.width * 1.04, size.height * 0.09, size.width * 1.05,
//         size.height * 0.12, size.width * 1.05, size.height * 0.15);
//     path.cubicTo(size.width * 1.05, size.height * 0.15, size.width * 1.05,
//         size.height * 1.04, size.width * 1.05, size.height * 1.04);
//     path.cubicTo(size.width * 1.05, size.height * 1.04, size.width * 1.05,
//         size.height * 1.04, size.width * 1.05, size.height * 1.04);
//     // canvas.drawPath(path, paint);
//     canvas.drawPath(
//       dashPath(
//         path,
//         dashArray: CircularIntervalList<double>(
//           <double>[5.0, 10],
//         ),
//       ),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant Rectangle oldDelegate) {
//     return true;
//   }
// }
