import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositries/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    print("update song called");
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;

        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
      }
    });
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true;
    print("updating state");
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer!.pause();
    } else
      audioPlayer!.play();

    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double value) {
    audioPlayer!.seek(Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt()));
  }
}
