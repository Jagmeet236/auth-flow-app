import 'package:auth_flow_app/core/base/base_navigator.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel<N extends BaseNavigator, R> extends ChangeNotifier {
  N? navigator;
  late final R repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setNavigator(N navigator) {
    this.navigator = navigator;
  }

  void setRepository(R repository) {
    this.repository = repository;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    if (error != null) {
      navigator?.showErrorSnackbar(error);
    }
    notifyListeners();
  }

  void setSuccess(String message) {
    navigator?.showSuccessSnackbar(message);
  }

  /// Saves only the access token via the repository (no refresh token API available).
  Future<void> saveAccessToken(String accessToken) async {
    await (repository as dynamic).saveAccessToken(accessToken);
  }
}