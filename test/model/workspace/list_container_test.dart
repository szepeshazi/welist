@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';
import 'package:welist/juiced/common/utils.dart';
import 'package:welist/juiced/juiced.dart';
import 'package:welist/juiced/juiced.juicer.dart' as j;

void main() {
  group("ListContainer serialization", () {
    test("to json", () {
      ListContainer container = ListContainer()
        ..type = ContainerType.todo
        ..name = "My todo list"
        ..accessLog = AccessLog();

      Map<String, dynamic> result = j.juicer.encode(container);
      dynamic flattened = flatten(result);
      container.log("user_1", flattened, AccessAction.create);
      expect(result['accessLog'], isNotNull);
    });
  });
}
