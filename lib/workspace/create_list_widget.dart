import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../juiced/juiced.dart';
import '../profile/user_info_widget.dart';

import '../workspace/workspace.dart';

class CreateListContainerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a list"),
          actions: [UserInfoWidget()]
        ),
        body: AddListContainerForm());
  }
}

class AddListContainerForm extends StatefulWidget {
  @override
  AddListContainerFormState createState() {
    return AddListContainerFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddListContainerFormState extends State<AddListContainerForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  ListContainer newListContainer = ListContainer()..type = ContainerType.shopping;

  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'List name'),
              validator: (value) {
                newListContainer.name = value;
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(ListContainer.containerTypeLabels[ContainerType.shopping]),
                  leading: Radio(
                    value: ContainerType.shopping,
                    groupValue: newListContainer.type,
                    onChanged: (ContainerType value) {
                      setState(() {
                        newListContainer.type = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(ListContainer.containerTypeLabels[ContainerType.todo]),
                  leading: Radio(
                    value: ContainerType.todo,
                    groupValue: newListContainer.type,
                    onChanged: (ContainerType value) {
                      setState(() {
                        newListContainer.type = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    await workspace.add(newListContainer);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ));
  }
}
