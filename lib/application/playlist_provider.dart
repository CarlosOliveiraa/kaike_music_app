import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'player_provider.dart';

final playlistProvider = StateProvider<ConcatenatingAudioSource?>(
  (ref) => null,
);

Future<void> setPlaylist(
  WidgetRef ref,
  List<String> urls,
  int startIndex,
) async {
  final player = ref.read(playerProvider);
  final playlist = ConcatenatingAudioSource(
    children: urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
  );

  await player.setAudioSource(playlist, initialIndex: startIndex);
  await player.play();

  ref.read(playlistProvider.notifier).state = playlist;
}
