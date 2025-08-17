import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/src/core/audio/providers/audio_service_provider.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:provider/provider.dart';

class Waveform extends StatefulWidget {
  final double barWidth;
  final double spacing;
  final double minHeight;
  final double maxHeight;
  final double containerHeight;
  final Color? color;
  final BorderRadius? borderRadius;
  final Duration animationDuration;

  const Waveform({
    super.key,
    this.barWidth = 4,
    this.spacing = 3,
    this.minHeight = 8,
    this.maxHeight = 28,
    this.containerHeight = 80,
    this.color,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform> with TickerProviderStateMixin {
  ValueNotifier<double> soundLevel = ValueNotifier(0);
  StreamSubscription<double>? _amplitudeSubscription;

  List<double> _amplitudeHistory = [];
  List<DateTime> _amplitudeTimestamps = [];
  double _currentLevel = 0.0;
  final Random _random = Random();
  int _barCount = 50; // Default value, will be calculated based on screen width

  @override
  void initState() {
    super.initState();

    // Listen to amplitude stream from AudioServiceProvider
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final asp = context.read<AudioServiceProvider>();
        _amplitudeSubscription = asp.amplitudeStream.listen((amplitude) {
          if (mounted) {
            _updateAmplitudeHistory(amplitude);
          }
        });
      }
    });
  }

  void _updateAmplitudeHistory(double amplitude) {
    if (!mounted) return;

    // Normalize amplitude data to 0-1 range
    final normalizedLevel = ((amplitude + 60) / 60).clamp(0.0, 1.0);

    // Initialize amplitude history and timestamps if empty or size changed
    if (_amplitudeHistory.isEmpty || _amplitudeHistory.length != _barCount) {
      _amplitudeHistory = List.filled(_barCount, 0.0);
      _amplitudeTimestamps = List.filled(
        _barCount,
        DateTime.now().subtract(const Duration(hours: 1)),
      );
    }

    final now = DateTime.now();

    // Only update amplitude history if there's actual sound
    if (normalizedLevel > 0.05) {
      // Shift existing values to the left (moving effect)
      for (int i = 0; i < _amplitudeHistory.length - 1; i++) {
        _amplitudeHistory[i] = _amplitudeHistory[i + 1];
        _amplitudeTimestamps[i] = _amplitudeTimestamps[i + 1];
      }

      // Add new amplitude value with some randomness for realism
      final randomVariation = (_random.nextDouble() - 0.5) * 0.15;
      final newAmplitude = (normalizedLevel + randomVariation).clamp(0.0, 1.0);

      _amplitudeHistory[_amplitudeHistory.length - 1] = newAmplitude;
      _amplitudeTimestamps[_amplitudeTimestamps.length - 1] = now;
      _currentLevel = newAmplitude;
    } else {
      // If no sound, gradually decay to minimum
      for (int i = 0; i < _amplitudeHistory.length; i++) {
        _amplitudeHistory[i] = (_amplitudeHistory[i] * 0.85).clamp(0.0, 1.0);
      }
      _currentLevel = normalizedLevel;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    soundLevel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Take full width
      height: widget.containerHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate bar count based on available width
          final availableWidth = constraints.maxWidth;
          final totalBarWidth = widget.barWidth + widget.spacing;
          final calculatedBarCount = (availableWidth / totalBarWidth).floor();

          // Update bar count if it changed
          if (_barCount != calculatedBarCount) {
            _barCount = calculatedBarCount;
            // Reinitialize amplitude history and timestamps with new size
            _amplitudeHistory = List.filled(_barCount, 0.0);
            _amplitudeTimestamps = List.filled(
              _barCount,
              DateTime.now().subtract(const Duration(hours: 1)),
            );
          }

          return _buildWaveform(context);
        },
      ),
    );
  }

  Widget _buildWaveform(BuildContext context) {
    // Check if we're in silent state
    final isSilent =
        _currentLevel <= 0.05 && _amplitudeHistory.every((amp) => amp <= 0.05);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_barCount, (index) {
        double amplitude;
        Duration animationDuration;

        if (isSilent) {
          // Silent state: all bars at minimum with no animation
          amplitude = 0.0;
          animationDuration = const Duration(milliseconds: 300);
        } else {
          // Active state: normal amplitude with animation
          amplitude = index < _amplitudeHistory.length
              ? _amplitudeHistory[index]
              : 0.0;

          // Add slight center bias (middle bars tend to be slightly taller)
          final centerDistance = (index - (_barCount - 1) / 2).abs();
          final centerBias = 1.0 - (centerDistance / (_barCount / 2)) * 0.2;
          amplitude *= centerBias;

          // Add subtle random variation for more natural look
          final variation = (_random.nextDouble() - 0.5) * 0.08;
          amplitude = (amplitude + variation).clamp(0.0, 1.0);

          // Add slight delay between bars for wave effect
          final delay =
              index * 5; // Reduced delay for smoother effect with more bars
          animationDuration = Duration(milliseconds: 100 + delay);
        }

        // Calculate height based on amplitude
        final height = widget.minHeight + (amplitude * widget.maxHeight);

        // Determine color based on timestamp - audio from last 3 seconds is primaryText, older is secondaryText
        Color barColor;
        if (widget.color != null) {
          barColor = widget.color!;
        } else if (isSilent) {
          barColor = context.darkColors.secondaryText;
        } else {
          // Check if this bar represents audio from the last 3 seconds
          final now = DateTime.now();
          final barTimestamp = index < _amplitudeTimestamps.length
              ? _amplitudeTimestamps[index]
              : DateTime.now().subtract(const Duration(hours: 1));
          final timeDifference = now.difference(barTimestamp);
          final isRecentAudio = timeDifference.inSeconds <= 3;

          barColor = isRecentAudio
              ? context.darkColors.primaryText
              : context.darkColors.secondaryText;
        }

        return AnimatedContainer(
          duration: animationDuration,
          curve: isSilent ? Curves.easeOut : Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          width: widget.barWidth,
          height: height.clamp(
            widget.minHeight,
            widget.minHeight + widget.maxHeight,
          ),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
