import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayer> {
  late RiveAnimationController _prevButtonController;
  late RiveAnimationController _nextButtonController;
  late RiveAnimationController _soundWaveController;

  SMIInput<bool>? _playButtonInput;
  Artboard? _playButtonArtboard;

  List<String> imageUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyMnTcLRLUD3-VfyTJ_KJpOszuZ_b0tQ9QTw&usqp=CAU', // Placeholder URL, replace with actual URLs
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxfa9oJikbZ6j5LhHlPIlJOSPlN0zYtBEs_Q&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJIFWFxy-fskMFsNhGdb-g1wlXn0PpJfJvZg&usqp=CAU',
  ];

  int currentIndex = 0; // Index of the current image

  void _playTrackChangeAnimation(RiveAnimationController controller) {
    if (controller.isActive == false) {
      controller.isActive = true;
    }
  }

  void _playPauseButtonAnimation() {
    if (_playButtonInput?.value == false &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = true;
      _toggleWaveAnimation();
    } else if (_playButtonInput?.value == true &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = false;
      _toggleWaveAnimation();
    }
  }

  void _toggleWaveAnimation() => setState(
        () => _soundWaveController.isActive = !_soundWaveController.isActive,
      );

  @override
  void initState() {
    super.initState();
    _prevButtonController = OneShotAnimation(
      'onPrev',
      autoplay: false,
    );
    _nextButtonController = OneShotAnimation(
      'onNext',
      autoplay: false,
    );
    _soundWaveController = SimpleAnimation(
      'loopingAnimation',
      autoplay: false,
    );

    rootBundle.load('assets/PlayPauseButton.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'PlayPauseButton',
      );
      if (controller != null) {
        artboard.addController(controller);
        _playButtonInput = controller.findInput('isPlaying');
      }
      setState(
        () => _playButtonArtboard = artboard,
      );
    });
  }

  // Function to handle "Next" button click
  void _nextButtonClicked() {
    setState(() {
      if (currentIndex < imageUrls.length - 1) {
        currentIndex++;
      }
    });
  }

  // Function to handle "Previous" button click
  void _prevButtonClicked() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrls[currentIndex],
              height: 300,
            ),
            SizedBox(
              height: 60,
            ),
            _playButtonArtboard == null
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) =>
                            _playTrackChangeAnimation(_prevButtonController),
                        onTap: _prevButtonClicked,
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: RiveAnimation.asset(
                            'assets/PrevTrackButton.riv',
                            controllers: [_prevButtonController],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => _playPauseButtonAnimation(),
                        child: SizedBox(
                          height: 125,
                          width: 125,
                          child: Rive(
                            artboard: _playButtonArtboard!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) =>
                            _playTrackChangeAnimation(_nextButtonController),
                        onTap: _nextButtonClicked,
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: RiveAnimation.asset(
                            'assets/NextTrackButton.riv',
                            controllers: [_nextButtonController],
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 100,
                width: 400,
                child: RiveAnimation.asset(
                  'assets/SoundWave.riv',
                  fit: BoxFit.contain,
                  controllers: [
                    _soundWaveController,
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
