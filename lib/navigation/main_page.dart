import 'package:mobx/mobx.dart';
import 'package:welist/juiced/juiced.dart';

part 'main_page.g.dart';

class MainPage = _MainPage with _$MainPage;

abstract class _MainPage with Store {
  @observable
  MainPageState currentState = MainPageState.splashAnimation;

  @observable
  bool newList = false;

  @observable
  ListContainer selectedContainer;

  @action
  void pushState(MainPageState newState) {
    currentState = newState;
    print("MainPage currentState: $currentState");
  }

  @action
  void setNewList(bool newValue) {
    newList = newValue;
  }

  void selectContainer(ListContainer container) => selectedContainer = container;
}

enum MainPageState {
  splashAnimation, loggedIn, loggedOut
}