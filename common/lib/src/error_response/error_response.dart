import 'package:juicer/metadata.dart';

@juiced
class ErrorResponse {
  String mnemonic;
  String message;
  Map<String, dynamic> payload;

  ErrorResponse();

  factory ErrorResponse.accessDenied({Map<String, dynamic> payload}) => ErrorResponse()
    ..mnemonic = accessDeniedMnemonic
    ..message = accessDeniedMessage
    ..payload = payload;

  factory ErrorResponse.notFound({Map<String, dynamic> payload}) => ErrorResponse()
    ..mnemonic = notFoundMnemonic
    ..message = notFoundMessage
    ..payload = payload;

  static const String accessDeniedMnemonic = "accessDenied";
  static const String accessDeniedMessage = "You do not have privileges to access the requested resource";

  static const String notFoundMnemonic = "notFound";
  static const String notFoundMessage = "The requested resource could not be found";
}
