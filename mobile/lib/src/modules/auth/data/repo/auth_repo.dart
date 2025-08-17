import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:mobile/src/core/api/enums/error_code.dart';
import 'package:mobile/src/core/api/models/api_failure.dart';
import 'package:mobile/src/core/local_storage/kv_store.dart';

class AuthRepo {
  static final BetterAuthClient _client = BetterAuthFlutter.client;

  static Future<(SignInEmailResponse?, ApiFailure?)>
  signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.signIn.email(
        request: SignInEmailRequest(email: email, password: password),
      );

      if (response.error != null) {
        return (
          null,
          ApiFailure.fromErrorCode(
            errorType: ErrorCode.authError,
            message: response.error!.message,
            stack: StackTrace.current.toString(),
          ),
        );
      }

      return (response.data, null);
    } catch (e) {
      return (
        null,
        ApiFailure.fromErrorCode(
          errorType: ErrorCode.unknownError,
          message: e.toString(),
          stack: StackTrace.current.toString(),
        ),
      );
    }
  }

  static Future<(SignUpResponse?, ApiFailure?)> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.signUp.email(
        request: SignUpRequest(name: name, email: email, password: password),
      );

      if (response.error != null) {
        return (
          null,
          ApiFailure.fromErrorCode(
            errorType: ErrorCode.authError,
            message: response.error!.message,
            stack: StackTrace.current.toString(),
          ),
        );
      }

      return (response.data, null);
    } catch (e) {
      return (
        null,
        ApiFailure.fromErrorCode(
          errorType: ErrorCode.unknownError,
          message: e.toString(),
          stack: StackTrace.current.toString(),
        ),
      );
    }
  }

  static Future<(SessionResponse?, ApiFailure?)> getSession() async {
    try {
      final response = await _client.getSession();

      if (response.error != null) {
        return (
          null,
          ApiFailure.fromErrorCode(
            errorType: ErrorCode.authError,
            message: response.error!.message,
            stack: StackTrace.current.toString(),
          ),
        );
      }

      return (response.data, null);
    } catch (e) {
      return (
        null,
        ApiFailure.fromErrorCode(
          errorType: ErrorCode.unknownError,
          message: e.toString(),
          stack: StackTrace.current.toString(),
        ),
      );
    }
  }

  static Future<(SignOutResponse?, ApiFailure?)> signOut() async {
    try {
      final response = await _client.signOut();

      if (response.error != null) {
        return (
          null,
          ApiFailure.fromErrorCode(
            errorType: ErrorCode.authError,
            message: response.error!.message,
            stack: StackTrace.current.toString(),
          ),
        );
      }

      await KVStore.clear();

      return (response.data, null);
    } catch (e) {
      return (
        null,
        ApiFailure.fromErrorCode(
          errorType: ErrorCode.unknownError,
          message: e.toString(),
          stack: StackTrace.current.toString(),
        ),
      );
    }
  }
}
