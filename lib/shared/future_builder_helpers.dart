import 'package:flutter/cupertino.dart';

Widget futureBuilderHelper<T>(BuildContext context, AsyncSnapshot<T> snapshot, FutureBuilderCallbacks callbacks) {
  Widget resolvedWidget;
  if (!snapshot.hasData) {
    resolvedWidget = callbacks.loading(context, snapshot);
  } else if (snapshot.data != null) {
    resolvedWidget = callbacks.ready(context, snapshot);
  } else {
    resolvedWidget = callbacks.error(context, snapshot);
  }
  return resolvedWidget;
}

class FutureBuilderCallbacks<T> {
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) loading;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) ready;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) error;

  FutureBuilderCallbacks({this.loading, this.ready, this.error});
}
