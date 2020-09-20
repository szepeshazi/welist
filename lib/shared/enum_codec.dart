class EnumCodec<T> {
  final List<T> values;

  Map<String, T> valueMap;

  EnumCodec(this.values) {
    valueMap = Map.fromIterables(values.map(asString), values);
  }

  String asString(T value) => _isMaybeEnum(value) ? value.toString().split('.')[1] : null;

  T asEnum(String strValue) => valueMap[strValue];

  bool _isMaybeEnum(T value) => value.toString().split('.').length == 2;
}
