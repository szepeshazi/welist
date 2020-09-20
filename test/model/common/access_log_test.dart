@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:welist/juiced/juiced.dart';

class AccessLogTest with AccessLogUtils implements HasAccessLog {
  AccessLog accessLog;
}

void main() {
  group("Access Log", () {
    var testObj;
    setUp(() {
      testObj = AccessLogTest()..accessLog = AccessLog();
    });
    test("first action has to be create", () {
      final entry = AccessEntry.now("1-userId", AccessAction.update);
      expect(() => testObj.log(entry), throwsA(const TypeMatcher<StateError>()));
    });
    test("subsequent actions can't be create", () {
      final entry = AccessEntry.now("2-userId", AccessAction.create);
      testObj.log(entry);
      expect(() => testObj.log(entry), throwsA(const TypeMatcher<StateError>()));
      expect(() => testObj.log(entry), throwsA(const TypeMatcher<StateError>()));
      expect(testObj.logEntries.length, 1);
      expect(testObj.accessLog.lastUpdate, isNull);
      expect(testObj.accessLog.create.userId, "2-userId");
    });
    test("entries will be truncated", () {
      final batchSize = AccessLog.maxLogSize + 5;
      for (int i = 0; i < batchSize; i++) {
        var entry = AccessEntry.now("3-userId_$i", i == 0 ? AccessAction.create : AccessAction.update);
        testObj.log(entry);
      }
      expect(testObj.logEntries.length, AccessLog.maxLogSize);
      expect(testObj.accessLog.lastUpdate.userId, "3-userId_${batchSize - 1}");
      expect(testObj.accessLog.create.userId, "3-userId_0");
      expect(testObj.accessLog.create.timestamp, lessThan(testObj.accessLog.lastUpdate.timestamp));
    });

  });
}
