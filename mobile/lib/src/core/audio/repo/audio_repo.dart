import 'dart:io';

import 'package:mobile/src/core/api/api.dart';
import 'package:mobile/src/core/api/enums/error_code.dart';
import 'package:mobile/src/core/api/enums/method_type.dart';
import 'package:mobile/src/core/api/enums/request_type.dart';
import 'package:mobile/src/core/api/models/api_failure.dart';
import 'package:mobile/src/core/api/models/multipart_body.dart';
import 'package:mobile/src/core/audio/models/audio_transcription_result.dart';

class AudioRepo {
  static Future<(AudioTranscriptionResult?, ApiFailure?)> uploadAudioFile(
    File audioFile, {
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      // Validate file exists
      if (!await audioFile.exists()) {
        return (
          null,
          ApiFailure(
            message: "Audio file does not exist",
            code: ErrorCode.invalidInput.id,
          ),
        );
      }

      // Validate file size (10MB limit to match backend)
      final fileSize = await audioFile.length();
      const maxSize = 10 * 1024 * 1024; // 10MB
      if (fileSize > maxSize) {
        return (
          null,
          ApiFailure(
            message: "File too large. Maximum size is 10MB",
            code: ErrorCode.invalidInput.id,
          ),
        );
      }

      // Create multipart body for file upload
      final multipartBody = MultipartBody(
        files: [
          MultipartFile(
            field: 'audio',
            file: audioFile,
            filename: audioFile.path.split('/').last,
          ),
        ],
      );

      // Upload the file using the API service
      final (response, error) = await Api.sendRequest(
        '/audio/stt',
        method: MethodType.post,
        requestType: RequestType.multipart,
        multipartBody: multipartBody,
      );

      if (error != null) {
        return (null, error);
      }

      // Parse the response into AudioTranscriptionResult
      final result = AudioTranscriptionResult.fromMap(
        response as Map<String, dynamic>,
      );
      return (result, null);
    } catch (e) {
      return (
        null,
        ApiFailure(
          message: "Failed to upload audio: ${e.toString()}",
          code: ErrorCode.unknownError.id,
        ),
      );
    }
  }
}
