@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';
import 'package:welist/juiced/juiced.dart';
import 'package:welist/juiced/juiced.juicer.dart' as j;

void main() {
  group("ListContainer serialization", () {
    test("to json", () {
      ListContainer container = ListContainer()
        ..type = ContainerType.todo
        ..name = "My todo list"
        ..accessors = [
          UserRole(
              User()
                ..authId = "authId"
                ..displayName = "John"
                ..email = "john@doe.com",
              "owner")
        ]
        ..accessLog = AccessLog()
        ..log(AccessEntry.now("userId", AccessAction.create));

      Map<String, dynamic> result = j.juicer.encode(container);
      print(result);

      expect(result['accessLog'], isNotNull);
    });
  });
}
