import 'package:flutter/widgets.dart';

class PulseZoom extends StatefulWidget {
  final Widget child;

  const PulseZoom({Key key, this.child}) : super(key: key);

  @override
  PulseZoomState createState() => PulseZoomState();
}

class PulseZoomState extends State<PulseZoom> with SingleTickerProviderStateMixin {
  AnimationController controller;

  static final duration = Duration(milliseconds: 330);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: duration, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
