import 'dart:math';

String generateRandomString(int length) {
  const String charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random random = Random();
  StringBuffer randomString = StringBuffer();

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(charset.length);
    randomString.write(charset[randomIndex]);
  }

  return randomString.toString();
}