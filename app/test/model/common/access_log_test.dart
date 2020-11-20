@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:welist_common/common.dart';

class AccessLogTest with AccessLogUtils implements HasAccessLog {
  @override
  AccessLog accessLog;

  @override
  dynamic reference;

  @override
  String get collection => "accessLogTest";
}

void main() {
  group("Access Log", () {
    dynamic juicedObj;
    AccessLogTest testObj;

    setUp(() {
      testObj = AccessLogTest()..accessLog = AccessLog();
      juicedObj = {
        "name": "Steve",
        "pets": [
          {"species": "dog", "name": "Henry", "isFavorite": true, "age": 3},
          {"species": "goldfish", "name": "Lola", "age": 0.2}
        ],
        "friends": ["Amy", "Jolly"],
        "work": {"recent": "none"}
      };
    });
    test("create object", () {
      //testObj.log("user_1", flatten(juicedObj));
      expect(testObj.accessLog.entries.length, 1);
      expect(testObj.accessLog.create, testObj.accessLog.entries.first);
      expect(testObj.accessLog.entries.first.changeSet.updatedProperties, isNull);
      expect(testObj.accessLog.entries.first.changeSet.deletedProperties, isNull);
    });
    test("update object", () {
      //testObj.log("user_1", flatten(juicedObj));
      expect(testObj.accessLog.entries.length, 1);
      juicedObj["friends"][0] = "Rory";
      juicedObj["friends"].add("Trudy");
      //testObj.log("user_2", flatten(juicedObj));
      expect(testObj.accessLog.entries.length, 2);
      expect(testObj.accessLog.entries.first.changeSet.updatedProperties.keys, contains("friends.0"));
      expect(testObj.accessLog.entries.first.changeSet.updatedProperties["friends.0"], "Rory");
      expect(testObj.accessLog.entries.first.changeSet.addedProperties.keys, contains("friends.2"));
      expect(testObj.accessLog.entries.first.changeSet.addedProperties["friends.2"], "Trudy");
    });
    test("entries will be truncated", () {
      final batchSize = AccessLog.maxLogSize + 5;
      for (int i = 0; i < batchSize; i++) {
        //testObj.log("user_$i", flatten(juicedObj));
        juicedObj["newProp$i"] = "drooze$i";
      }
      expect(testObj.accessLog.entries.length, AccessLog.maxLogSize);
      expect(testObj.accessLog.entries.first.userId, "user_${batchSize - 1}");
      expect(testObj.accessLog.create.userId, "user_0");
      expect(testObj.accessLog.create.timestamp, lessThan(testObj.accessLog.entries.first.timestamp));
    });
  });
}
