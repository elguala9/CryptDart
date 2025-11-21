import 'package:test/test.dart';
import 'package:cryptdart/cryptdart.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';
import 'package:cryptdart/implementations/partial/asymmetric_sign_impl.dart';
import 'package:cryptdart/implementations/signed_based/ecdsa_sign.dart';
import 'dart:convert';

void main() {
  group('ECDSASign', () {
    late Map<String, String> keyPair;
    late ECDSASign signer;
    late String message;
    late List<int> signature;

    setUpAll(() async {
      keyPair = await ECDSASign.generateKeyPair();
      InputExpirationBase expBase = (
        algorithm: CryptoAlgorithm.ecdsa,
        expirationDate: null,
        expirationTimes: null,
      );
      InputSign signInput = (parent: expBase,);
      InputAsymmetricSign asymInput = (
        parent: signInput,
        publicKey: keyPair['publicKey']!,
        privateKey: keyPair['privateKey'],
      );
      InputECDSASign ecdsaInput = (parent: asymInput,);
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
      InputExpirationBase expBase = (
        algorithm: CryptoAlgorithm.ecdsa,
        expirationDate: null,
        expirationTimes: null,
      );
      InputSign signInput = (parent: expBase,);
      InputAsymmetricSign asymInput = (
        parent: signInput,
        publicKey: keyPair['publicKey']!,
        privateKey: null,
      );
      InputECDSASign ecdsaInput = (parent: asymInput,);
      final pubOnly = ECDSASign(ecdsaInput);
      expect(() => pubOnly.sign(utf8.encode(message)), throwsStateError);
    });
  });
}
