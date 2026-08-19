//import 'dart:js_interop';

import 'package:client/features/home/model/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  void uploadLocalSong(SongModel song) async {
    try {
      final box = Hive.isBoxOpen('songs')
          ? Hive.box('songs')
          : await Hive.openBox('songs');
      box.put(song.id, song.toJson());
    } catch (_) {}
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    try {
      if (Hive.isBoxOpen('songs')) {
        final box = Hive.box('songs');
        for (final key in box.keys) {
          final val = box.get(key);
          if (val != null) {
            songs.add(SongModel.fromJson(val));
          }
        }
      }
    } catch (_) {}

    return songs;
  }
}


