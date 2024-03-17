import 'package:flutter/material.dart';
import 'package:rive/rive.dart'; // Import Rive package
import 'music_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          // Navigate to the MusicPlayer component when the image is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MusicPlayer()),
          );
        },
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 600,
                width: 600,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the MusicPlayer component when the animation is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MusicPlayer()),
                    );
                  },
                  child: const RiveAnimation.asset(
                    'assets/radioSplashAnimation.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
