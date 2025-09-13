import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaike_music_app/application/player_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final playing = state?.playing ?? false;

        return Container(
          padding: const EdgeInsets.all(12),
          color: Colors.black87,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nome da música atual
              StreamBuilder<SequenceState?>(
                stream: player.sequenceStateStream,
                builder: (context, snapshot) {
                  final current = snapshot.data?.currentSource;
                  final title = current?.tag ?? "Sem título";
                  return Text(
                    title.toString(),
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),

              // Barra de progresso
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final pos = snapshot.data ?? Duration.zero;
                  final total = player.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        value: pos.inSeconds.toDouble(),
                        max: total.inSeconds.toDouble(),
                        onChanged: (value) {
                          player.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Text(
                        "${_formatDuration(pos)} / ${_formatDuration(total)}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Controles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: player.hasPrevious
                        ? player.seekToPrevious
                        : null,
                  ),
                  IconButton(
                    icon: Icon(
                      playing ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      playing ? player.pause() : player.play();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: player.hasNext ? player.seekToNext : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: Colors.white),
                    onPressed: () {
                      player.setLoopMode(
                        player.loopMode == LoopMode.one
                            ? LoopMode.off
                            : LoopMode.one,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
