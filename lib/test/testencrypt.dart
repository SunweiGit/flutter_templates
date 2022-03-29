import 'package:encrypt/encrypt.dart';

void main() {
  final key = Key.fromUtf8('axap1tanexmj7kiveunnawse');
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final iv = IV.fromUtf8("1954682228745975");
  final text =
      "A set of high-level APIs over PointyCastle for two-way cryptography.";
  //final encrypted = encrypter.encrypt(text, iv: iv);
  final decrypted = encrypter.decrypt64(
      "vPgKYVettrLuwusjDx8DYqIT3Lo8L52Wl8M6RBmZeM0Ixy4nN9LAElzquhqbXMILuo/+a5j1kOqib+a4I/ak7A==",
      iv: iv);

  print(
      decrypted); // A set of high-level APIs over PointyCastle for two-way cryptography.
 // print(encrypted.base64); // +H8VseqZhaZaK8EUh+K2jlHXBFbRA/dHkpPDf0fN+YaNro9ofBNlLsVtrkmmiulBoBiS4EQE7djVvsouuVyIXwe3lQogMzWcdAULNBSrSRM=
}
