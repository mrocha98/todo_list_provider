import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifiers/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  DefaultListenerNotifier({required DefaultChangeNotifier notifier})
      : _notifier = notifier;

  final DefaultChangeNotifier _notifier;

  void listen(
    BuildContext context, {
    SuccessVoidCallback? onSuccess,
    ErrorVoidCallback? onError,
    VoidCallback? dispose,
  }) =>
      _notifier.addListener(() {
        if (_notifier.loading) {
          Loader.show(context);
        } else {
          Loader.hide();
        }

        if (_notifier.hasError) {
          onError?.call(_notifier, this);
          Messages.of(context).showError(_notifier.error ?? 'Erro interno');
        } else if (_notifier.isSuccess) {
          dispose?.call();
          onSuccess?.call(_notifier, this);
        }
      });
}

typedef SuccessVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listenerNotifier,
);

typedef ErrorVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listenerNotifier,
);
