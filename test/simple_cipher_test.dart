import 'package:test/test.dart';
import 'package:cryptdart/cryptdart.dart';

void main() {
  test('simple AES test to see structure', () {
    final aes = AESCipher((
      parent: (
        key: 'test_key_32_characters_1234567890',
        parent: (
          parent: (
            algorithm: CryptoAlgorithm.aes,
            expirationDate: null,
            expirationTimes: null,
          ),
        ),
      ),
    ));

    expect(aes.algorithm, equals(CryptoAlgorithm.aes));
    print('AES test passed');
  });
}