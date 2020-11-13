/// Flattens a hierarchical map, using dot separated key sequence for nested values
/// Array values will be flattened by using the numeric index value for key sequence
///
/// Example:
/// ```
///   Map<String, dynamic> values = {
///     "nested": {
///       "second": {
///         "third": "leaf1",
///         "this": {
///           "goes": {"very": "deep"}
///         }
///       },
///       "otherSecond": 42
///     },
///     "arrayValue": ["leaf3", {"nestedMap": "leaf4"}}
///   };
/// ```
///
///   `flatten(values)` will yield:
///
/// ```
///   {
///     "nested.second.third": "leaf1",
///     "nested.second.this.goes.very": "deep",
///     "nested.otherSecond": 42,
///     "arrayValue.0": "leaf3",
///     "arrayValue.1.nestedMap": "leaf4"
///   }
/// ```
///
Map<String, dynamic> flatten(dynamic input, {String keyPrefix = "", bool joinLists = false}) {
  assert(input != null);
  Map<String, dynamic> result = {};
  String separator = keyPrefix.isEmpty ? "" : ".";
  if (input is List) {
    if (joinLists) {
      result[keyPrefix] = input.map((dynamic e) => e.toString()).join(",");
    } else {
      for (int index = 0; index < input.length; index++) {
        result.addAll(flatten(input[index], keyPrefix: "$keyPrefix$separator$index", joinLists: joinLists));
      }
    }
  } else if (input is Map) {
    for (var key in input.keys) {
      result.addAll(flatten(input[key], keyPrefix: "$keyPrefix$separator$key", joinLists: joinLists));
    }
  } else {
    result[keyPrefix] = input;
  }
  return result;
}
