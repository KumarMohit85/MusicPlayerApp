import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) {

  }
}
