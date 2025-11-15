import 'package:test/test.dart';
import '../implementations/asymmetric/prime_based/rsa_cipher.dart';
// import '../implementations/asymmetric/prime_based/ecc_cipher.dart'; // ECC test only if implemented

void main() {
  group('AsymmetricCipher', () {
    test('RSA encrypt/decrypt', () {
      final publicKey = '''-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArv...\n-----END PUBLIC KEY-----''';
      final privateKey = '''-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD...\n-----END PRIVATE KEY-----''';
      final cipher = RSACipher(publicKey: publicKey, privateKey: privateKey, expirationDate: DateTime.now().add(Duration(days: 1)));
      final data = [1, 2, 3, 4, 5];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
    });
    // test('ECC encrypt/decrypt', () {
    //   // Implement ECC test if ECCCipher is fully implemented
    // });
  });
}
