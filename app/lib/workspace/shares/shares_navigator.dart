import 'package:mobx/mobx.dart';

part 'shares_navigator.g.dart';

class SharesNavigator = _SharesNavigator with _$SharesNavigator;

abstract class _SharesNavigator with Store {
  @observable
  bool showAddAccessorForm = false;

  @observable
  bool disableAddAccessorButton = false;

  @action
  void toggleAddAccessorForm(bool newValue) {
    showAddAccessorForm = newValue;
    disableAddAccessorButton = !newValue;
  }

  @action
  void toggleAddAccessorButton(bool newValue) => disableAddAccessorButton = newValue;
}
