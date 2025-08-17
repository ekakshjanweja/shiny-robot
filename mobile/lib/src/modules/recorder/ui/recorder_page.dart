import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/src/core/audio/providers/audio_service_provider.dart';
import 'package:mobile/src/core/constants/app_assets.dart';
import 'package:mobile/src/core/extensions.dart';
import 'package:mobile/src/modules/recorder/ui/widgets/waveform.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

class RecorderPage extends StatefulWidget {
  static const String routeName = '/recorder';
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  Future<void> startSTT() async {
    final asp = context.read<AudioServiceProvider>();

    await asp.startRecording();
  }

  Future<void> stopSTT() async {
    final asp = context.read<AudioServiceProvider>();
    await asp.stopRecording();

    final error = await asp.transcribe();

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 48,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New memory',
                style: context.textTheme.headline.copyWith(
                  color: context.darkColors.primaryText,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: context.h * 0.25,
          left: -128,
          right: 0,
          child: Row(
            children: [
              SizedBox(
                height: 360,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.black38,
                        Colors.black,
                      ],
                      stops: [0.0, 0.5, 1],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: SvgPicture.asset(AppAssets.pocketLogo, height: 360),
                ),
              ),
              Expanded(
                child: Waveform(
                  containerHeight: 64,
                  maxHeight: 64,
                  minHeight: 2,
                  barWidth: 4,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 128,
          left: 0,
          right: 0,
          child: Consumer<AudioServiceProvider>(
            builder: (context, asp, _) {
              if (asp.isTranscribing) {
                return SizedBox(
                  height: 16,
                  width: 16,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.darkColors.primaryText,
                    ),
                  ),
                );
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.darkColors.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  asp.transcription ?? 'Press play to start recording',
                  style: context.textTheme.body2.copyWith(
                    color: context.darkColors.primaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<AudioServiceProvider>(
                builder: (context, asp, _) {
                  return IconButton(
                    onPressed: () async {
                      if (asp.isRecording) {
                        await stopSTT();
                      } else {
                        await startSTT();
                      }
                    },
                    icon: Icon(
                      asp.isRecording
                          ? SolarIconsBold.pause
                          : SolarIconsBold.play,
                      size: 16,
                      color: context.colors.primaryText,
                    ),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 9.5, vertical: 10),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        context.lightColors.surface,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
