import 'package:test/test.dart';
import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';

void main() {
  group('ECDSASign', () {
    late Map<String, String> keyPair;
    late ECDSASign signer;
    late String message;
    late List<int> signature;

    setUpAll(() async {
      keyPair = await ECDSASign.generateKeyPair();
      InputExpirationBase expBase = InputExpirationBase(
        expirationDate: null,
        expirationTimes: null,
      );
      InputSign signInput = InputSign(parent: expBase);
      InputAsymmetricSign asymInput = InputAsymmetricSign(
        parent: signInput,
        publicKey: keyPair['publicKey']!,
        privateKey: keyPair['privateKey'],
      );
      InputECDSASign ecdsaInput = InputECDSASign(parent: asymInput);
      signer = ECDSASign(ecdsaInput);
      message = 'CryptDart ECDSA test message';
    });

    test('sign and verifySignature', () {
      final data = utf8.encode(message);
      signature = signer.sign(data);
      final isValid = signer.verify(data, signature);
      expect(isValid, isTrue);
    });

    test('verifySignature fails with wrong data', () {
      final wrongData = utf8.encode('Wrong message');
      final isValid = signer.verify(wrongData, signature);
      expect(isValid, isFalse);
    });

    test('throws if signing without private key', () {
      InputExpirationBase expBase = InputExpirationBase(
        expirationDate: null,
        expirationTimes: null,
      );
      InputSign signInput = InputSign(parent: expBase);
      InputAsymmetricSign asymInput = InputAsymmetricSign(
        parent: signInput,
        publicKey: keyPair['publicKey']!,
        privateKey: null,
      );
      InputECDSASign ecdsaInput = InputECDSASign(parent: asymInput);
      final pubOnly = ECDSASign(ecdsaInput);
      expect(() => pubOnly.sign(utf8.encode(message)), throwsStateError);
    });
  });
}
