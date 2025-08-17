import 'dart:convert';
import 'dart:developer';

import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/src/core/api/enums/error_code.dart';
import 'package:mobile/src/core/api/models/api_failure.dart';
import 'package:mobile/src/core/local_storage/kv_store.dart';
import 'package:mobile/src/core/local_storage/kv_store_keys.dart';
import 'package:mobile/src/modules/auth/data/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    final sessionCache = KVStore.get<String>(KVStoreKeys.session);

    if (sessionCache != null) {
      try {
        final decoded = jsonDecode(sessionCache);

        if (decoded is Map<String, dynamic> &&
            (decoded.containsKey('session') || decoded.containsKey('user'))) {
          final sessionData = SessionResponse.fromJson(decoded);
          session = sessionData.session;
          user = sessionData.user;
        } else if (decoded is Map<String, dynamic>) {
          try {
            session = Session.fromJson(decoded);
            user = null;
          } catch (_) {
            session = null;
            user = null;
          }
        } else {
          session = null;
          user = null;
        }
      } catch (e) {
        session = null;
        user = null;
      }
    }
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Session? _session;
  Session? get session => _session;
  set session(Session? value) {
    _session = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<ApiFailure?> signIn({
    required String email,
    required String password,
  }) async {
    loading = true;

    final (result, error) = await AuthRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (error != null) {
      loading = false;
      return error;
    }

    if (result == null) {
      loading = false;
      return ApiFailure.fromErrorCode(
        errorType: ErrorCode.unknownError,
        message: 'Sign in failed, no response received.',
        stack: StackTrace.current.toString(),
      );
    }

    user = result.user;

    await getSession();

    loading = false;

    return null;
  }

  Future<ApiFailure?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    loading = true;

    final (result, error) = await AuthRepo.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    if (error != null) {
      loading = false;
      return error;
    }

    if (result == null) {
      loading = false;
      return ApiFailure.fromErrorCode(
        errorType: ErrorCode.unknownError,
        message: 'Sign up failed, no response received.',
        stack: StackTrace.current.toString(),
      );
    }

    user = result.user;

    await getSession();

    loading = false;

    return null;
  }

  Future<void> getSession() async {
    loading = true;
    final (res, err) = await AuthRepo.getSession();

    if (err != null) {
      loading = false;
      log('Error fetching session: ${err.message}');
      return;
    }

    session = res?.session;
    user = res?.user;

    if (session != null) {
      final Map<String, dynamic> toStore = {};
      toStore['session'] = session!.toJson();
      if (user != null) toStore['user'] = user!.toJson();
      await KVStore.set(KVStoreKeys.session, jsonEncode(toStore));
    }

    loading = false;
  }

  Future<ApiFailure?> signOut() async {
    loading = true;

    final (result, error) = await AuthRepo.signOut();

    if (error != null) {
      loading = false;
      return error;
    }

    user = null;
    session = null;

    loading = false;

    return null;
  }
}
