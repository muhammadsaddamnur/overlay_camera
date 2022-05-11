import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_camera/circular_progress.dart';
import 'package:vector_math/vector_math.dart' as vmath;

// import 'dart:math' as Math;
import 'package:path_drawing/path_drawing.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Main(),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Ktp(title: 'KTP')));
            },
            child: Text('KTP'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfieKtp(title: 'KTP')));
            },
            child: Text('Selfie KTP'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelfieVerif()));
            },
            child: Text('Selfie Verif'),
          ),
        ],
      ),
    );
  }
}

/// ktp
class Ktp extends StatefulWidget {
  const Ktp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Ktp> createState() => _KtpState();
}

class _KtpState extends State<Ktp> {
  late CameraController controller;

  @override
  void initState() {
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        fit: StackFit.expand,
        children: [
          cameraWidget(context, controller),
          rectangleOverlay(context),
          // customOverlay(context),
          Text('sdasndasdkmk')
        ],
      ),
    );
  }
}

/// selfie ktp
class SelfieKtp extends StatefulWidget {
  const SelfieKtp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SelfieKtp> createState() => _SelfieKtpState();
}

class _SelfieKtpState extends State<SelfieKtp> {
  late CameraController controller;

  @override
  void initState() {
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        fit: StackFit.expand,
        children: [
          cameraWidget(context, controller),
          // rectangleOverlay(context),
          customOverlay(context),
          Text('sdasndasdkmk')
        ],
      ),
    );
  }
}

/// selfie verif
class SelfieVerif extends StatefulWidget {
  const SelfieVerif({Key? key}) : super(key: key);

  @override
  State<SelfieVerif> createState() => _SelfieVerifState();
}

class _SelfieVerifState extends State<SelfieVerif> {
  late CameraController controller;
  double _value = 0;

  @override
  void initState() {
    controller = CameraController(
      cameras.length > 1 ? cameras[1] : cameras[0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image.network(
                //   'https://i.redd.it/318zawfomti51.jpg',
                //   fit: BoxFit.cover,
                // ),
                cameraWidget(context, controller),
                circleOverlay(context, _value),
                Text('sdasndasdkmk')
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Slider(
              min: 0.0,
              max: 100.0,
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget cameraWidget(
  context,
  CameraController controller,
) {
  if (!controller.value.isInitialized) {
    return Container();
  }
  CameraValue camera = controller.value;

  // fetch screen size
  final size = MediaQuery.of(context).size;

  // calculate scale depending on screen and camera ratios
  // this is actually size.aspectRatio / (1 / camera.aspectRatio)
  // because camera preview size is received as landscape
  // but we're calculating for portrait orientation
  print(camera);
  var scale = size.aspectRatio * camera.aspectRatio;

  // to prevent scaling down, invert the value
  if (scale < 1) scale = 1 / scale;

  return Transform.scale(
    scale: scale,
    child: Center(
      child: CameraPreview(controller),
    ),
  );
}

/// overlay
///
Widget rectangleOverlay(BuildContext context) {
  return Stack(
    children: [
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Align(
                child: CustomPaint(
                  painter: RectangleFill(),
                  size: Size(335.w, 194.w),
                ),
              ),
              decoration: const BoxDecoration(
                  color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
            ),
          ],
        ),
      ),
      Stack(
        fit: StackFit.expand,
        children: [
          Align(
            child: CustomPaint(
              painter: RectangleOutline(),
              size: Size(335.w, 194.w),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget customOverlay(BuildContext context) {
  return Stack(
    children: [
      ColorFiltered(
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
                          padding: EdgeInsets.only(top: 114.h),
                          child: CustomPaint(
                            painter: CustomFill(),
                            size: Size(178.h, 250.h),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CustomPaint(
                            painter: RectangleFill(),
                            size: Size(228.w, 147.w),
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 114.h),
                        child: CustomPaint(
                          painter: CustomOutline(),
                          size: Size(178.h, 250.h),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomPaint(
                          painter: RectangleOutline(),
                          size: Size(228.w, 147.w),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget circleOverlay(BuildContext context, progress) {
  return Stack(
    children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            Colors.white, BlendMode.srcOut), // This one will create the magic
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 250.h),
                      child: CustomPaint(
                        painter: CircleFill(),
                        size: Size(100.h, 100.h),
                      ),
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 250.h),
                    child: CustomPaint(
                      painter: CircleOutline(progress: progress),
                      size: Size(150.h, 150.h),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 250.h),
                  child: Center(child: Text('data')),
                )
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class CustomFill extends CustomPainter {
  bool? isFilled;
  CustomFill({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    Path path = Path();

    paint.color = Color(0xffffffff).withOpacity(1);
    path = Path();
    path.moveTo(size.width * 0.03, size.height / 4);
    path.lineTo(size.width * 0.03, size.height / 4);
    path.cubicTo(size.width * 0.06, size.height * 0.12, size.width * 0.27, 0,
        size.width * 0.51, 0);
    path.cubicTo(size.width * 0.74, 0, size.width * 0.96, size.height * 0.12,
        size.width * 0.98, size.height / 4);
    path.cubicTo(size.width, size.height * 0.36, size.width * 0.98,
        size.height * 0.44, size.width * 0.97, size.height * 0.47);
    path.cubicTo(size.width * 0.98, size.height * 0.47, size.width,
        size.height * 0.49, size.width, size.height * 0.51);
    path.cubicTo(size.width, size.height * 0.54, size.width, size.height * 0.62,
        size.width * 0.95, size.height * 0.65);
    path.cubicTo(size.width * 0.86, size.height * 0.88, size.width * 0.68,
        size.height * 0.98, size.width * 0.51, size.height);
    path.cubicTo(size.width / 3, size.height * 0.98, size.width * 0.15,
        size.height * 0.88, size.width * 0.06, size.height * 0.65);
    path.cubicTo(size.width * 0.02, size.height * 0.62, size.width * 0.01,
        size.height * 0.54, size.width * 0.01, size.height * 0.51);
    path.cubicTo(size.width * 0.01, size.height * 0.49, size.width * 0.03,
        size.height * 0.47, size.width * 0.04, size.height * 0.47);
    path.cubicTo(size.width * 0.03, size.height * 0.44, size.width * 0.01,
        size.height * 0.36, size.width * 0.03, size.height / 4);
    path.cubicTo(size.width * 0.03, size.height / 4, size.width * 0.03,
        size.height / 4, size.width * 0.03, size.height / 4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomFill oldDelegate) {
    return true;
  }
}

class CustomOutline extends CustomPainter {
  bool? isFilled;
  CustomOutline({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Path path = Path();

    paint.color = Color(0xffffffff).withOpacity(1);
    path = Path();
    path.moveTo(size.width * 0.03, size.height / 4);
    path.lineTo(size.width * 0.03, size.height / 4);
    path.cubicTo(size.width * 0.06, size.height * 0.12, size.width * 0.27, 0,
        size.width * 0.51, 0);
    path.cubicTo(size.width * 0.74, 0, size.width * 0.96, size.height * 0.12,
        size.width * 0.98, size.height / 4);
    path.cubicTo(size.width, size.height * 0.36, size.width * 0.98,
        size.height * 0.44, size.width * 0.97, size.height * 0.47);
    path.cubicTo(size.width * 0.98, size.height * 0.47, size.width,
        size.height * 0.49, size.width, size.height * 0.51);
    path.cubicTo(size.width, size.height * 0.54, size.width, size.height * 0.62,
        size.width * 0.95, size.height * 0.65);
    path.cubicTo(size.width * 0.86, size.height * 0.88, size.width * 0.68,
        size.height * 0.98, size.width * 0.51, size.height);
    path.cubicTo(size.width / 3, size.height * 0.98, size.width * 0.15,
        size.height * 0.88, size.width * 0.06, size.height * 0.65);
    path.cubicTo(size.width * 0.02, size.height * 0.62, size.width * 0.01,
        size.height * 0.54, size.width * 0.01, size.height * 0.51);
    path.cubicTo(size.width * 0.01, size.height * 0.49, size.width * 0.03,
        size.height * 0.47, size.width * 0.04, size.height * 0.47);
    path.cubicTo(size.width * 0.03, size.height * 0.44, size.width * 0.01,
        size.height * 0.36, size.width * 0.03, size.height / 4);
    path.cubicTo(size.width * 0.03, size.height / 4, size.width * 0.03,
        size.height / 4, size.width * 0.03, size.height / 4);
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(
          <double>[5.0, 12],
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomOutline oldDelegate) {
    return true;
  }
}

class RectangleFill extends CustomPainter {
  bool? isFilled;
  RectangleFill({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint2 = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    Path path = Path();

    // Path number 1
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        const Radius.circular(15)));
    canvas.drawPath(path, paint2);
  }

  @override
  bool shouldRepaint(covariant RectangleFill oldDelegate) {
    return true;
  }
}

class RectangleOutline extends CustomPainter {
  bool? isFilled;
  RectangleOutline({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Path path = Path();

    // Path number 1
    paint.color = const Color(0xffffffff).withOpacity(1);
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        const Radius.circular(15)));
    canvas.drawPath(
      dashPath(
        path,
        dashArray: CircularIntervalList<double>(
          <double>[5.0, 12],
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RectangleOutline oldDelegate) {
    return true;
  }
}

class CircleFill extends CustomPainter {
  bool? isFilled;
  CircleFill({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint2 = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;
    Path path = Path();

    // Path number 1
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, 0), radius: size.width / 3));
    canvas.drawPath(path, paint2);
  }

  @override
  bool shouldRepaint(covariant CircleFill oldDelegate) {
    return true;
  }
}

class CircleOutline extends CustomPainter {
  double progress;
  CircleOutline({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint2 = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Path path = Path();

    // Path number 1
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, 0), radius: size.width / 2.7));
    canvas.drawPath(path, paint2);

    /// progress
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, 0),
        width: size.width / 1.35,
        height: size.width / 1.35,
      ),
      vmath.radians(90),
      vmath.radians((progress / 100) * 360),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = Colors.green
        ..strokeWidth = 5,
    );
  }

  @override
  bool shouldRepaint(covariant CircleOutline oldDelegate) {
    return true;
  }
}
