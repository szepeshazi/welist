// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListItem on _ListItem, Store {
  Computed<bool> _$completedComputed;

  @override
  bool get completed =>
      (_$completedComputed ??= Computed<bool>(() => super.completed)).value;
  Computed<String> _$stateNameComputed;

  @override
  String get stateName =>
      (_$stateNameComputed ??= Computed<String>(() => super.stateName)).value;
  Computed<String> _$nameWithStateComputed;

  @override
  String get nameWithState =>
      (_$nameWithStateComputed ??= Computed<String>(() => super.nameWithState))
          .value;

  final _$createdAtAtom = Atom(name: '_ListItem.createdAt');

  @override
  int get createdAt {
    _$createdAtAtom.context.enforceReadPolicy(_$createdAtAtom);
    _$createdAtAtom.reportObserved();
    return super.createdAt;
  }

  @override
  set createdAt(int value) {
    _$createdAtAtom.context.conditionallyRunInAction(() {
      super.createdAt = value;
      _$createdAtAtom.reportChanged();
    }, _$createdAtAtom, name: '${_$createdAtAtom.name}_set');
  }

  final _$completedAtAtom = Atom(name: '_ListItem.completedAt');

  @override
  int get completedAt {
    _$completedAtAtom.context.enforceReadPolicy(_$completedAtAtom);
    _$completedAtAtom.reportObserved();
    return super.completedAt;
  }

  @override
  set completedAt(int value) {
    _$completedAtAtom.context.conditionallyRunInAction(() {
      super.completedAt = value;
      _$completedAtAtom.reportChanged();
    }, _$completedAtAtom, name: '${_$completedAtAtom.name}_set');
  }

  final _$_ListItemActionController = ActionController(name: '_ListItem');

  @override
  void setState(bool state) {
    final _$actionInfo = _$_ListItemActionController.startAction();
    try {
      return super.setState(state);
    } finally {
      _$_ListItemActionController.endAction(_$actionInfo);
    }
  }
}
