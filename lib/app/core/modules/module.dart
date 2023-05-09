import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_list_provider/app/core/modules/module_page.dart';

abstract class Module {
  Module({
    required Map<String, WidgetBuilder> routes,
    List<SingleChildWidget>? bindings,
  })  : _bindings = bindings,
        _routes = routes;

  final List<SingleChildWidget>? _bindings;

  final Map<String, WidgetBuilder> _routes;

  Map<String, WidgetBuilder> get routes => _routes.map(
        (routeName, builder) => MapEntry(
          routeName,
          (_) => ModulePage(
            builder: builder,
            bindings: _bindings,
          ),
        ),
      );

  Widget getPage(BuildContext context, {required String routeName}) {
    final widgetBuilder = _routes[routeName];
    if (widgetBuilder != null) {
      return ModulePage(
        builder: widgetBuilder,
        bindings: _bindings,
      );
    }
    throw ArgumentError.value(routeName);
  }
}
