import 'dart:async';

import 'package:flutter/material.dart';

abstract class ViewModel implements ChangeNotifier {}

class BaseViewModel extends ChangeNotifier implements ViewModel {}

mixin LoadingViewModelMixin implements ViewModel {
  bool get isLoading;
}

extension LoadingViewModelExt on LoadingViewModelMixin {
  Future<void> waitUntilFinishedLoading() async {
    final LoadingViewModelMixin viewModel = this;
    if (!viewModel.isLoading) {
      return;
    }
    final Completer<dynamic> completer = Completer<dynamic>();
    late Function listener;
    listener = () {
      if (!viewModel.isLoading) {
        viewModel.removeListener(listener as Function());
        completer.complete();
      }
    };
    viewModel.addListener(listener as Function());

    return completer.future;
  }
}
