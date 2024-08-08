import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      print("current song is null");
      return const SizedBox();
    }
    print("current song is not null");
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          return MusicPlayer();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeIn));

          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }));
      },
      child: Stack(
        children: [
          Container(
            height: 66,
            decoration: BoxDecoration(
                color: hexToColor(currentSong.hex_code),
                borderRadius: BorderRadius.circular(6)),
            width: MediaQuery.of(context).size.width - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music-image',
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                currentSong.thumbnail_url,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          currentSong.artist,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Pallete.subtitleText),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart)),
                    IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(songNotifier.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill))
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer!.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("stream connection waiting");
                  print(songNotifier.audioPlayer!.duration);
                  print(songNotifier.audioPlayer!.position);

                  return const SizedBox();
                }
                final position = snapshot.data;
                final duration = songNotifier.audioPlayer!.duration;
                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                //print("slider value: ${sliderValue}");
                return Positioned(
                    bottom: 0,
                    left: 6,
                    child: Container(
                      height: 2,
                      width: sliderValue *
                          (MediaQuery.of(context).size.width - 32),
                      decoration: BoxDecoration(color: Pallete.whiteColor),
                    ));
              }),
          Positioned(
              bottom: 0,
              left: 6,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(color: Pallete.inactiveSeekColor),
              ))
        ],
      ),
    );
  }
}
