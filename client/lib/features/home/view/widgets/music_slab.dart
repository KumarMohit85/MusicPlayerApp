import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    if (currentSong == null) {
      return const SizedBox();
    }
    return Row(
      children: [
        Container(
          width: 48,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(currentSong.thumbnail_url))),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          children: [
            Text(
              currentSong.song_name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    );
  }
}
