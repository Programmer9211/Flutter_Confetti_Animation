import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Confetti Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ConfettiController();
  bool isplaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller.state == ConfettiControllerState.playing) {
        setState(() {
          isplaying = true;
        });
      } else {
        setState(() {
          isplaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                if (isplaying) {
                  controller.stop();
                } else {
                  controller.play();
                }
              },
              child: Text(isplaying ? "Stop" : "Play"),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
          //blastDirection: pi,
          emissionFrequency: 0.2,
          numberOfParticles: 10,
          maxBlastForce: 10,
          gravity: 0.8,
          colors: [
            Colors.green,
            Colors.black,
            Colors.red,
          ],
          createParticlePath: (size) {
            double degToRad(double deg) => deg * (pi / 180.0);

            const numberOfPoints = 5;
            final halfWidth = size.width / 2;
            final externalRadius = halfWidth;
            final internalRadius = halfWidth / 2.5;
            final degreesPerStep = degToRad(360 / numberOfPoints);
            final halfDegreesPerStep = degreesPerStep / 2;
            final path = Path();
            final fullAngle = degToRad(360);
            path.moveTo(size.width, halfWidth);

            for (double step = 0; step < fullAngle; step += degreesPerStep) {
              path.lineTo(halfWidth + externalRadius * cos(step),
                  halfWidth + externalRadius * sin(step));
              path.lineTo(
                  halfWidth + internalRadius * cos(step + halfDegreesPerStep),
                  halfWidth + internalRadius * sin(step + halfDegreesPerStep));
            }
            path.close();
            return path;
          },
        ),
      ],
    );
  }
}
