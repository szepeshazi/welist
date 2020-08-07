import 'package:mobx/mobx.dart';

part 'observable_input.g.dart';

class ObservableInput = _ObservableInput with _$ObservableInput;

abstract class _ObservableInput with Store {
  @observable
  String input;

  @action
  set value(String newValue) => input = newValue;
}