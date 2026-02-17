import 'package:test/test.dart';
import 'package:cryptdart/cryptdart.dart';

void main() {
  test('simple AES test to see structure', () {
    final aes = AESCipher(InputAESCipher(
      parent: InputSymmetricCipher(
        key: 'test_key_32_characters_1234567890',
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: null,
            expirationTimes: null,
          ),
        ),
      ),
    ));

    expect(aes.algorithm, equals(SymmetricCipherAlgorithmEnum.aes));
    print('AES test passed');
  });
}