import 'package:mobx/mobx.dart';
import '../juiced/juiced.dart';

part 'main_page.g.dart';

class MainPage = _MainPage with _$MainPage;

abstract class _MainPage with Store {
  @observable
  MainPageState currentState = MainPageState.splashAnimation;

  @observable
  bool showCreateListWidget = false;

  @observable
  ListContainer selectedContainer;

  @observable
  ListContainer showSharesForContainer;

  @action
  void pushState(MainPageState newState) => currentState = newState;

  @action
  void toggleCreateListWidget(bool newValue) => showCreateListWidget = newValue;

  @action
  void toggleSharesForContainer(ListContainer newValue) => showSharesForContainer = newValue;

  @action
  void selectContainer(ListContainer container) => selectedContainer = container;
}

enum MainPageState { splashAnimation, loggedIn, loggedOut }
