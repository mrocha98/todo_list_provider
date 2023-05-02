import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ModulePage extends StatelessWidget {
  const ModulePage({
    required WidgetBuilder builder,
    List<SingleChildWidget>? bindings,
    super.key,
  })  : _builder = builder,
        _bindings = bindings;

  final List<SingleChildWidget>? _bindings;

  final WidgetBuilder _builder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        MultiProvider(
          providers: _bindings ??
              [
                Provider(
                  create: (_) => Object(),
                )
              ],
          builder: (context, child) => _builder(context),
        ),
      ],
    );
  }
}
