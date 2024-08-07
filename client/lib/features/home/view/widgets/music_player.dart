import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(currentSong!.thumbnail_url),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            currentSong.artist,
                            style: TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {}, icon: Icon(CupertinoIcons.heart))
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Pallete.whiteColor,
                      inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                      thumbColor: Pallete.whiteColor,
                      trackHeight: 4,
                      overlayShape: SliderComponentShape.noOverlay),
                  child: Slider(
                    value: 0.5,
                    onChanged: (val) {},
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0.05',
                  style: TextStyle(
                      color: Pallete.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  '0.15',
                  style: TextStyle(
                      color: Pallete.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/shuffle.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/previous-song.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.play_circle_fill),
                  iconSize: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/next-song.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/repeat.png',
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/connect-device.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/playlist.png',
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
