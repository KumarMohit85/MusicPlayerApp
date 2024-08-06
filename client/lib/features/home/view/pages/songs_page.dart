import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Latest today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            )),
        ref.watch(getAllSongsProvider).when(
            data: (songs) {
              print(songs);
              return SizedBox(
                height: 260,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(song.thumbnail_url),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  song.song_name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  song.artist,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Pallete.subtitleText),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            },
            error: (error, st) {
              print("showing error");
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Loader())
      ],
    ));
  }
}
