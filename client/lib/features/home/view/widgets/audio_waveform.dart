import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWaveform extends StatefulWidget {
  final String path;
  const AudioWaveform({super.key, required this.path});

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    // TODO: implement initState
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void initAudioPlayer() async {
    print("init audio player called");
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: playAndPause,
            icon: Icon(playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid)),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 80),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Pallete.greyColor,
                liveWaveColor: Pallete.gradient2,
                showSeekLine: false,
                spacing: 8),
          ),
        ),
      ],
    );
  }
}
