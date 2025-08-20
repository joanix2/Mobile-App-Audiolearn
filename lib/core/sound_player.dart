import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _signedUrlQuery = r'''
query Signed_audio_url($lessonId: Int!) {
  signed_audio_url(lesson_id: $lessonId) {
    signed_url
  }
}
''';

class AudioLessonPlayer extends StatefulWidget {
  final int lessonId;
  final String format; // "hls" ou "mp3"
  final GraphQLClient client;

  const AudioLessonPlayer({
    super.key,
    required this.lessonId,
    required this.client,
    this.format = "hls",
  });

  @override
  State<AudioLessonPlayer> createState() => _AudioLessonPlayerState();
}

class _AudioLessonPlayerState extends State<AudioLessonPlayer> {
  late final AudioPlayer _player;
  bool _loading = true;
  String? _currentUrl;
  StreamSubscription? _playerErrorSub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Abonne-toi aux erreurs pour re-signer automatiquement si 403/expiration
    _playerErrorSub = _player.playbackEventStream.listen((_) {},
        onError: (Object e, StackTrace st) async {
          // Si l’URL a expiré (souvent 403/401 côté CDN), on refait la requête
          await _refreshAndResume();
        });

    await _loadSource();
  }

  Future<void> _loadSource({Duration? seekTo}) async {
    setState(() => _loading = true);
    final url = await _fetchSignedUrl();
    _currentUrl = url;

    try {
      await _player.setUrl(url); // gère HLS ou MP3
      if (seekTo != null) await _player.seek(seekTo);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<String> _fetchSignedUrl() async {
    final result = await widget.client.query(
      QueryOptions(
        document: gql(_signedUrlQuery),
        variables: {
          "lessonId": widget.lessonId,
          "format": widget.format,
        },
        fetchPolicy: FetchPolicy.noCache, // important pour éviter les URLs périmées
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }
    return result.data!['signedAudioUrl'] as String;
  }

  Future<void> _refreshAndResume() async {
    final pos = _player.position;
    await _loadSource(seekTo: pos);
    // Rejoue si on était en lecture
    if (_player.playing == false) {
      await _player.play();
    }
  }

  @override
  void dispose() {
    _playerErrorSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  // Combine durée totale + position + buffer pour le Slider
  Stream<_PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, _PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream.map((d) => d ?? Duration.zero),
            (position, bufferedPosition, duration) => _PositionData(
          position,
          bufferedPosition,
          duration,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre / sous-titre (ex: Lesson title)
            Text("AudioLearn — Lecture de leçon",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Barre de progression
            StreamBuilder<_PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final data = snapshot.data ??
                    _PositionData(Duration.zero, Duration.zero, Duration.zero);
                final duration = data.duration.inMilliseconds.toDouble();
                final position = data.position.inMilliseconds.toDouble();
                final buffered = data.bufferedPosition.inMilliseconds.toDouble();

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Stack(
                        children: [
                          // Buffered
                          Slider(
                            value: (buffered.clamp(0, duration)),
                            max: duration > 0 ? duration : 1,
                            onChanged: (_) {},
                          ),
                          // Position
                          Slider(
                            value: (position.clamp(0, duration)),
                            max: duration > 0 ? duration : 1,
                            onChanged: (v) {
                              _player.seek(Duration(milliseconds: v.toInt()));
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fmt(data.position)),
                        Text("-${_fmt(data.duration - data.position)}"),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            // Contrôles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: "⟲ 15s",
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {
                    final newPos = _player.position - const Duration(seconds: 15);
                    _player.seek(newPos < Duration.zero ? Duration.zero : newPos);
                  },
                ),
                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    final processing = snapshot.data?.processingState;
                    final buffering = processing == ProcessingState.loading ||
                        processing == ProcessingState.buffering;

                    if (buffering) {
                      return const SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return IconButton(
                      iconSize: 40,
                      icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                      onPressed: () async {
                        if (playing) {
                          await _player.pause();
                        } else {
                          try {
                            await _player.play();
                          } catch (e) {
                            // En cas d’erreur (souvent expiration), on refresh
                            await _refreshAndResume();
                          }
                        }
                      },
                    );
                  },
                ),
                IconButton(
                  tooltip: "15s ⟳",
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {
                    final newPos = _player.position + const Duration(seconds: 15);
                    _player.seek(newPos);
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Vitesse
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vitesse"),
                const SizedBox(width: 8),
                DropdownButton<double>(
                  value: _player.speed,
                  items: const [
                    DropdownMenuItem(value: 0.8, child: Text("0.8×")),
                    DropdownMenuItem(value: 1.0, child: Text("1.0×")),
                    DropdownMenuItem(value: 1.25, child: Text("1.25×")),
                    DropdownMenuItem(value: 1.5, child: Text("1.5×")),
                  ],
                  onChanged: (v) => _player.setSpeed(v ?? 1.0),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Debug / Statut
            if (_currentUrl != null)
              Text(
                "Source: ${widget.format.toUpperCase()} (URL signée active)",
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  _PositionData(this.position, this.bufferedPosition, this.duration);
}

String _fmt(Duration d) {
  final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  final hh = d.inHours;
  return hh > 0 ? "$hh:$mm:$ss" : "$mm:$ss";
}
