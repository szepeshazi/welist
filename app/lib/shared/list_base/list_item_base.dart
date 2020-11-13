import 'package:flutter/widgets.dart';

abstract class ListItemBase {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);

  Widget buildTrailing(BuildContext context);
}
