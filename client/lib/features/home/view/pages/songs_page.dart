import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewmodelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);

    final topGradientColor = currentSong != null
        ? hexToColor(currentSong.hex_code).withOpacity(0.4)
        : const Color(0xFF0D2818);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topGradientColor, Pallete.backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: YOUR LIBRARY & Good evening & Search Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'YOUR LIBRARY',
                          style: TextStyle(
                            color: Pallete.subtitleText,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Good evening',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E2620),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 22),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Recently Played 2-Column Grid
              if (recentlyPlayedSongs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: recentlyPlayedSongs.length > 6 ? 6 : recentlyPlayedSongs.length,
                    itemBuilder: (context, index) {
                      final song = recentlyPlayedSongs[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF242C26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                child: Image.network(
                                  song.thumbnail_url,
                                  width: 54,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 54,
                                    color: Pallete.cardColor,
                                    child: const Icon(Icons.music_note, color: Colors.white54),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.song_name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      song.artist,
                                      style: const TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),

              // Latest today Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Latest today',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: Pallete.subtitleText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Latest today Horizontal List
              ref.watch(getAllSongsProvider).when(
                    data: (songs) {
                      if (songs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                          child: Text(
                            "No songs available. Upload a song to get started!",
                            style: TextStyle(color: Pallete.subtitleText),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: songs.length,
                          padding: const EdgeInsets.only(left: 16.0),
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(currentSongNotifierProvider.notifier)
                                    .updateSong(song);
                              },
                              child: Container(
                                width: 165,
                                margin: const EdgeInsets.only(right: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        song.thumbnail_url,
                                        width: 165,
                                        height: 165,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 165,
                                          height: 165,
                                          color: Pallete.cardColor,
                                          child: const Icon(Icons.music_note, size: 48, color: Colors.white54),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      song.song_name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      song.artist,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Pallete.subtitleText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, st) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Pallete.errorColor),
                        ),
                      ),
                    ),
                    loading: () => const Loader(),
                  ),

              const SizedBox(height: 20),

              // Made for you Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Made for you',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ref.watch(getAllSongsProvider).maybeWhen(
                    data: (songs) {
                      if (songs.isEmpty) return const SizedBox.shrink();
                      final reversedSongs = songs.reversed.toList();
                      return SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: reversedSongs.length,
                          padding: const EdgeInsets.only(left: 16.0),
                          itemBuilder: (context, index) {
                            final song = reversedSongs[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(currentSongNotifierProvider.notifier)
                                    .updateSong(song);
                              },
                              child: Container(
                                width: 165,
                                margin: const EdgeInsets.only(right: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        song.thumbnail_url,
                                        width: 165,
                                        height: 165,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 165,
                                          height: 165,
                                          color: Pallete.cardColor,
                                          child: const Icon(Icons.music_note, size: 48, color: Colors.white54),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      song.song_name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      song.artist,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Pallete.subtitleText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
