import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../juiced/juiced.dart';
import '../workspace/workspace.dart';
import 'workspace_navigator.dart';

class CreateListContainerWidget extends StatefulWidget {
  @override
  AddListContainerFormState createState() {
    return AddListContainerFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddListContainerFormState extends State<CreateListContainerWidget> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  ListContainer newListContainer = ListContainer()..type = ContainerType.shopping;

  @override
  Widget build(BuildContext context) {
    final Workspace _workspace = Provider.of(context);
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);

    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Center(
            child: Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                alignment: Alignment.topCenter,
                child: Wrap(children: [
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("Create a new list", style: Theme.of(context).textTheme.headline6)),
                  Card(
                      child: Container(
                          color: Color(0xFFF8F8FF),
                          padding: EdgeInsets.all(15),
                          child: Wrap(children: [
                            TextFormField(
                                decoration: InputDecoration(labelText: 'List name'),
                                validator: (value) {
                                  newListContainer.name = value;
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                }),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 45, bottom: 15),
                                child: Text("Select list type", style: Theme.of(context).textTheme.subtitle1)),
                            ListTile(
                              title: Text(ListContainer.containerTypeLabels[ContainerType.shopping]),
                              subtitle: Text("Organize items into categories, track quantities"),
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
                              subtitle: Text("Assign deadlines, see when a given item was finished"),
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
                          ]))),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                              await _workspace.add(newListContainer);
                              _workspaceNavigator.toggleAddContainerWidget(false);
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text("Submit", textScaleFactor: 1.5))))
                ]))));
  }
}
