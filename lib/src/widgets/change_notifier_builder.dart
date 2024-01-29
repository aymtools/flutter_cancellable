import 'package:aymtools/src/listenable/change_notifier_ext.dart';
import 'package:aymtools/src/widgets/widget_ext.dart';
import 'package:cancellable/cancellable.dart';
import 'package:flutter/widgets.dart';

class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final T changeNotifier;
  final Widget Function(BuildContext, T, Widget? child) builder;
  final Widget? child;

  const ChangeNotifierBuilder(
      {super.key,
      required this.changeNotifier,
      required this.builder,
      this.child});

  @override
  State<ChangeNotifierBuilder<T>> createState() =>
      _ChangeNotifierBuilderState<T>();
}

class _ChangeNotifierBuilderState<T extends ChangeNotifier>
    extends State<ChangeNotifierBuilder<T>> with CancellableState {
  late Cancellable cancellable;

  void _changer() {
    try {
      setState(() {});
    } catch (ignore) {}
  }

  @override
  void initState() {
    super.initState();
    cancellable = makeCancellable();
    widget.changeNotifier.addCListener(cancellable, _changer);
  }

  @override
  void didUpdateWidget(covariant ChangeNotifierBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.changeNotifier != oldWidget.changeNotifier) {
      cancellable.cancel();
      cancellable = makeCancellable();
      widget.changeNotifier.addCListener(cancellable, _changer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.changeNotifier, widget.child);
  }
}