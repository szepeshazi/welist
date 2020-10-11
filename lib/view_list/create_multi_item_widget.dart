import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../juiced/juiced.dart';
import '../observable_input_value/observable_input.dart';
import 'view_list.dart';

class CreateMultiItemWidget extends StatelessWidget {
  final ObservableInput oInput = ObservableInput();
  final TextEditingController controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final ViewList viewList = Provider.of(context);
    final Auth auth = Provider.of(context);
    return Observer(
        builder: (context) => Container(
            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                autofocus: true,
                onChanged: (String value) {
                  oInput.setValue(value);
                },
                onSubmitted: (_) {
                  ListItem item = ListItem()
                    ..name = oInput.input
                    ..timeCompleted = null;
                  viewList.add(auth.userReference.path, item);
                  oInput.setValue("");
                  controller.value = TextEditingValue(text: "empty");
                })));
  }
}
