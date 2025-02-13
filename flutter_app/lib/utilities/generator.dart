import 'package:uuid/uuid.dart';

String generateRandomString(int length) {
  const Uuid uuid = Uuid();
  return uuid.v4();
}
