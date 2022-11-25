import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class Encrypt {
  ///```
  ///Example
  ///
  ///  String encrypt(String data, key) {
  /// log(Encrypt().encryptData(data, key).toString());
  /// return Encrypt().encryptData(data, key);
  ///}
  ///
  ///```

  String encryptData(String data) {
    final key = Key.fromUtf8(genEncrypKey().substring(0, 16));
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    return encrypter.encrypt(data, iv: iv).base64;
  }

  ///```
  ///Example
  ///
  ///  String decrypt(String data, key) {
  /// log(Encrypt().decryptData(data, key));
  ///return Encrypt().decryptData(data, key);
  ///  }
  ///
  ///```

  String decryptData(String data) {
    final key = Key.fromUtf8(genEncrypKey().substring(0, 16));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);

    return decrypted;
  }

  String genEncrypKey() {
    return const Uuid().v5(Uuid.NAMESPACE_URL, 'MY_AIS');
  }
}
