import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaike_music_app/application/player_provider.dart';
import 'package:kaike_music_app/data/youtube_service.dart';
import 'package:kaike_music_app/presentation/widgets/mini_player.dart';
import 'package:http/http.dart' as http;

const String apiKey = "";

final searchResultsProvider = FutureProvider.family<List<YoutubeVideo>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search"
      "?part=snippet&type=video&maxResults=20&q=$query&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final items = (data["items"] as List).map((item) {
        return YoutubeVideo(
          id: item["id"]["videoId"],
          title: item["snippet"]["title"],
          thumbnail: item["snippet"]["thumbnails"]["high"]["url"],
          channelTitle: item["snippet"]["channelTitle"],
        );
      }).toList();
      return items;
    } else {
      throw Exception("Erro ao buscar vídeos: ${response.body}");
    }
  },
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Buscar música...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: results.when(
        data: (videos) {
          if (videos.isEmpty) {
            return Center(child: Text("Digite algo para buscar músicas"));
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                leading: Image.network(video.thumbnail),
                title: Text((video.title)),
                subtitle: Text(video.channelTitle),
                onTap: () async {
                  final service = YoutubeService();
                  final url = await service.getAudioUrl(video.id);
                  if (url != null) {
                    final player = ref.read(playerProvider);
                    await player.setUrl(url);
                    player.play();
                  }
                },
              );
            },
          );
        },
        error: (e, _) => Center(child: Text('Erro: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}

class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnail;
  final String channelTitle;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.channelTitle,
  });
}
