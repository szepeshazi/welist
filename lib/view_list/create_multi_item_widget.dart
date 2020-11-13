import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist_common/common.dart';

import '../observable_input_value/observable_input.dart';
import 'list_item_service.dart';

class CreateMultiItemWidget extends StatelessWidget {
  final ObservableInput oInput = ObservableInput();
  final inputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ListItemService viewList = Provider.of(context);
    final controller = TextEditingController(text: "");

    return Observer(
        builder: (context) => Container(
            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(children: [
              TextField(
                  autofocus: true,
                  controller: controller,
                  onChanged: (String value) {
                    oInput.setValue(value);
                  },
                  focusNode: inputFocusNode,
                  onSubmitted: (_) {
                    ListItem item = ListItem()
                      ..name = oInput.input
                      ..timeCompleted = null;
                    viewList.add(item);
                    oInput.setValue("");
                    controller.text = oInput.input;
                    inputFocusNode.requestFocus();
                  }),
              Text("current Input: ${oInput.input}")
            ])));
  }
}
