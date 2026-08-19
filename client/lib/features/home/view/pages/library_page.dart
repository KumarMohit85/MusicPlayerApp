import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/view_model/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D2818), Pallete.backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'YOUR MUSIC',
                        style: TextStyle(
                          color: Pallete.subtitleText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Library',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadSongPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Pallete.limeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.plus, color: Colors.black, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Favorites Section
              ref.watch(getFavSongsProvider).when(
                    data: (favSongs) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(CupertinoIcons.heart_fill, color: Color(0xFFFB6DA9), size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Favorite Tracks',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF242C26),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${favSongs.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Pallete.subtitleText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          if (favSongs.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Pallete.cardColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Pallete.borderColor),
                              ),
                              child: Column(
                                children: [
                                  const Icon(CupertinoIcons.heart, size: 48, color: Pallete.subtitleText),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "No favorite songs yet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Tap the heart icon on any track to add it to your library.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: favSongs.length,
                              itemBuilder: (context, index) {
                                final song = favSongs[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF242C26),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    onTap: () {
                                      ref
                                          .read(currentSongNotifierProvider.notifier)
                                          .updateSong(song);
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        song.thumbnail_url,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Pallete.cardColor,
                                          child: const Icon(Icons.music_note, color: Colors.white54),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      song.song_name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      song.artist,
                                      style: const TextStyle(
                                        color: Pallete.subtitleText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Color(0xFFFB6DA9),
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(homeViewmodelProvider.notifier)
                                            .favSong(songId: song.id);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
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
            ],
          ),
        ),
      ),
    );
  }
}
