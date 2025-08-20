import 'package:flutter/material.dart';

/// AudioPlayerPage — layout-only (no audio logic), Stateful.
/// - Responsive: pile en portrait, side-by-side en large/landscape
/// - Icônes/contrôles visuels (play/pause, +/-15s, slider, vitesse, timer, like, download...)
/// - Remplace les données mock par les vraies valeurs plus tard.
class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({
    super.key,
    this.courseTitle = 'Bases du Product Management',
    this.lessonTitle = 'Le MVP et les itérations',
    this.coverImage,
  });

  final String courseTitle;
  final String lessonTitle;
  final ImageProvider? coverImage;

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  // État purement visuel
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isDownloading = false;
  double _position = 62; // secondes mock
  double _duration = 5 * 60; // 5 min mock
  int _speedIndex = 1; // 0:0.75x 1:1x 2:1.25x 3:1.5x
  int? _sleepMinutes; // null = off
  bool _showTranscript = false;

  static const _speeds = [0.75, 1.0, 1.25, 1.5];

  String _fmt(double seconds) {
    final s = seconds.clamp(0, _duration).round();
    final mPart = (s ~/ 60).toString().padLeft(2, '0');
    final sPart = (s % 60).toString().padLeft(2, '0');
    return '$mPart:$sPart';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Partager',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final isWide = c.maxWidth >= 720;
            final cover = _CoverArt(
              image: widget.coverImage,
              badge: _isDownloading ? 'Enregistré' : null,
            );

            final meta = _MetaBlock(
              courseTitle: widget.courseTitle,
              lessonTitle: widget.lessonTitle,
            );

            final controls = _ControlsBlock(
              isPlaying: _isPlaying,
              onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
              onSeekBack: () => setState(() => _position = (_position - 15).clamp(0, _duration)),
              onSeekForward: () => setState(() => _position = (_position + 15).clamp(0, _duration)),
              onPrev: () {},
              onNext: () {},
            );

            final slider = _SliderBlock(
              positionLabel: _fmt(_position),
              durationLabel: _fmt(_duration),
              value: _position,
              max: _duration,
              onChanged: (v) => setState(() => _position = v),
            );

            final quickActions = _QuickActions(
              speed: _speeds[_speedIndex],
              onSpeedTap: () => setState(() => _speedIndex = (_speedIndex + 1) % _speeds.length),
              sleepMinutes: _sleepMinutes,
              onSleepTap: () => setState(() {
                const options = [15, 30, 45, 60];
                if (_sleepMinutes == null) {
                  _sleepMinutes = options.first;
                } else {
                  final idx = options.indexOf(_sleepMinutes!);
                  _sleepMinutes = idx == options.length - 1 ? null : options[idx + 1];
                }
              }),
              transcriptOn: _showTranscript,
              onTranscriptTap: () => setState(() => _showTranscript = !_showTranscript),
              isFavorite: _isFavorite,
              onFavoriteTap: () => setState(() => _isFavorite = !_isFavorite),
              isDownloading: _isDownloading,
              onDownloadTap: () => setState(() => _isDownloading = !_isDownloading),
            );

            final transcript = _showTranscript
                ? _TranscriptPreview(
              text:
              '« Le MVP est la plus petite version de votre produit… »\n\n'
                  '— Objectifs : tester la valeur, réduire le risque, apprendre vite.\n'
                  '— Étapes : hypothèse → prototype → mesure → itération.',
            )
                : const SizedBox.shrink();

            final page = ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                if (!isWide) ...[
                  cover,
                  const SizedBox(height: 16),
                  meta,
                ],
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cover),
                      const SizedBox(width: 20),
                      Expanded(child: meta),
                    ],
                  ),
                const SizedBox(height: 20),
                slider,
                const SizedBox(height: 12),
                controls,
                const SizedBox(height: 8),
                quickActions,
                const SizedBox(height: 16),
                transcript,
                const SizedBox(height: 80),
              ],
            );

            return Stack(
              children: [
                page,
                // Barre "Liste des leçons" en bas (visuelle)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: _QueueBar(
                    onTap: () {
                      // purely visual: no-op or open a mock sheet
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (_) => const _MockQueueSheet(),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ----- Sous-widgets “purement graphiques” -----

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.image, this.badge});
  final ImageProvider? image;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final img = image ??
        const AssetImage('assets/placeholder_cover.png'); // remplacez par une asset si dispos
    final radius = BorderRadius.circular(20);
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: img, fit: BoxFit.cover),
              ),
            ),
            // Overlay gradient pour lisibilité
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            if (badge != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.download_done_rounded, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(badge!, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({required this.courseTitle, required this.lessonTitle});
  final String courseTitle;
  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(courseTitle, style: txt.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text(
          lessonTitle,
          style: txt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text('4.8 • 2 345 avis', style: txt.bodySmall),
            const SizedBox(width: 12),
            const Icon(Icons.schedule_rounded, size: 16),
            const SizedBox(width: 4),
            Text('~ 5 min', style: txt.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _SliderBlock extends StatelessWidget {
  const _SliderBlock({
    required this.value,
    required this.max,
    required this.onChanged,
    required this.positionLabel,
    required this.durationLabel,
  });

  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final String positionLabel;
  final String durationLabel;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value.clamp(0, max),
            max: max,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(positionLabel, style: txt.labelSmall),
            Text('-${_remaining()}', style: txt.labelSmall),
          ],
        ),
      ],
    );
  }

  String _remaining() {
    final rem = (max - value).clamp(0, max).round();
    final m = (rem ~/ 60).toString().padLeft(2, '0');
    final s = (rem % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ControlsBlock extends StatelessWidget {
  const _ControlsBlock({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.onPrev,
    required this.onNext,
  });

  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final big = MediaQuery.of(context).size.width >= 360;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIcon(onPressed: onPrev, icon: Icons.skip_previous_rounded),
        const SizedBox(width: 4),
        _RoundIcon(onPressed: onSeekBack, icon: Icons.replay_10_rounded),
        const SizedBox(width: 12),
        _PlayPauseButton(isPlaying: isPlaying, onPressed: onPlayPause, big: big),
        const SizedBox(width: 12),
        _RoundIcon(onPressed: onSeekForward, icon: Icons.forward_10_rounded),
        const SizedBox(width: 4),
        _RoundIcon(onPressed: onNext, icon: Icons.skip_next_rounded),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.isPlaying, required this.onPressed, required this.big});
  final bool isPlaying;
  final VoidCallback onPressed;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final size = big ? 64.0 : 56.0;
    return SizedBox(
      width: size,
      height: size,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(shape: const CircleBorder()),
        onPressed: onPressed,
        icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: big ? 36 : 32),
        label: const SizedBox.shrink(),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.speed,
    required this.onSpeedTap,
    required this.sleepMinutes,
    required this.onSleepTap,
    required this.transcriptOn,
    required this.onTranscriptTap,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.isDownloading,
    required this.onDownloadTap,
  });

  final double speed;
  final VoidCallback onSpeedTap;
  final int? sleepMinutes;
  final VoidCallback onSleepTap;
  final bool transcriptOn;
  final VoidCallback onTranscriptTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final bool isDownloading;
  final VoidCallback onDownloadTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _ChipButton(
          icon: Icons.speed_rounded,
          label: '${speed}x',
          onTap: onSpeedTap,
        ),
        _ChipButton(
          icon: Icons.nightlight_round,
          label: sleepMinutes == null ? 'Timer' : '${sleepMinutes}m',
          filled: sleepMinutes != null,
          onTap: onSleepTap,
        ),
        _ChipButton(
          icon: Icons.article_rounded,
          label: 'Transcription',
          filled: transcriptOn,
          onTap: onTranscriptTap,
        ),
        _ChipButton(
          icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: 'Favori',
          filled: isFavorite,
          onTap: onFavoriteTap,
        ),
        _ChipButton(
          icon: isDownloading ? Icons.download_done_rounded : Icons.download_rounded,
          label: isDownloading ? 'Enregistré' : 'Télécharger',
          filled: isDownloading,
          onTap: onDownloadTap,
        ),
        _ChipButton(
          icon: Icons.cast_rounded,
          label: 'Caster',
          onTap: () {},
        ),
        _ChipButton(
          icon: Icons.equalizer_rounded,
          label: 'Améliorer',
          onTap: () {},
          bg: color.secondaryContainer.withOpacity(.6),
        ),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.bg,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = bg ??
        (filled ? scheme.secondaryContainer : scheme.surfaceContainerHighest.withOpacity(.6));
    final fg = filled ? scheme.onSecondaryContainer : Theme.of(context).colorScheme.onSurface;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: fg)),
          ]),
        ),
      ),
    );
  }
}

class _TranscriptPreview extends StatelessWidget {
  const _TranscriptPreview({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Transcription (aperçu)', style: txt.titleSmall),
        const SizedBox(height: 8),
        Text(
          text,
          style: txt.bodyMedium,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.open_in_full_rounded, size: 18),
            label: const Text('Ouvrir en plein écran'),
          ),
        ),
      ]),
    );
  }
}

class _QueueBar extends StatelessWidget {
  const _QueueBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: color.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.queue_music_rounded),
              const SizedBox(width: 12),
              const Expanded(child: Text('Liste des leçons')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.playlist_play_rounded, size: 16, color: color.onPrimaryContainer),
                  const SizedBox(width: 6),
                  Text('12', style: TextStyle(color: color.onPrimaryContainer)),
                ]),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.keyboard_arrow_up_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockQueueSheet extends StatelessWidget {
  const _MockQueueSheet();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => i);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemBuilder: (_, i) {
        final isCurrent = i == 2;
        return ListTile(
          leading: CircleAvatar(child: Text('${i + 1}')),
          title: Text('Leçon ${i + 1} — Titre descriptif'),
          subtitle: const Text('04:30'),
          trailing: isCurrent
              ? FilledButton.tonal(onPressed: () {}, child: const Text('En cours'))
              : IconButton(icon: const Icon(Icons.play_arrow_rounded), onPressed: () {}),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 4),
      itemCount: items.length,
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.onPressed, required this.icon});
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(shape: const CircleBorder()),
    );
  }
}
