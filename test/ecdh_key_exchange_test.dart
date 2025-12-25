import 'package:test/test.dart';
import 'package:cryptdart/implementations/key_exchange/ecdh_key_exchange.dart';
import 'package:cryptdart/types/key_exchange_algorithm.dart';
import 'package:cryptdart/utils/crypto_utils.dart';
import 'dart:typed_data';

void main() {
  group('ECDH Key Exchange Tests', () {
    group('Key pair generation', () {
      test('generates valid key pair with default curve (secp256r1)', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair();
        
        expect(keyPair['publicKey'], isNotNull);
        expect(keyPair['privateKey'], isNotNull);
        expect(keyPair['curve'], equals(ECCKeyUtils.secp256r1));
        
        expect(keyPair['publicKey']!, contains('BEGIN PUBLIC KEY'));
        expect(keyPair['publicKey']!, contains('END PUBLIC KEY'));
        expect(keyPair['privateKey']!, contains('BEGIN EC PRIVATE KEY'));
        expect(keyPair['privateKey']!, contains('END EC PRIVATE KEY'));
      });

      test('generates valid key pair with secp384r1 curve', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair(
          curve: ECCKeyUtils.secp384r1,
        );
        
        expect(keyPair['publicKey'], isNotNull);
        expect(keyPair['privateKey'], isNotNull);
        expect(keyPair['curve'], equals(ECCKeyUtils.secp384r1));
        
        expect(keyPair['publicKey']!, contains('BEGIN PUBLIC KEY'));
        expect(keyPair['privateKey']!, contains('BEGIN EC PRIVATE KEY'));
      });

      test('generates valid key pair with secp521r1 curve', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair(
          curve: ECCKeyUtils.secp521r1,
        );
        
        expect(keyPair['publicKey'], isNotNull);
        expect(keyPair['privateKey'], isNotNull);
        expect(keyPair['curve'], equals(ECCKeyUtils.secp521r1));
        
        expect(keyPair['publicKey']!, contains('BEGIN PUBLIC KEY'));
        expect(keyPair['privateKey']!, contains('BEGIN EC PRIVATE KEY'));
      });

      test('generates different key pairs on each call', () async {
        final keyPair1 = await ECDHKeyExchange.generateKeyPair();
        final keyPair2 = await ECDHKeyExchange.generateKeyPair();
        
        expect(keyPair1['publicKey'], isNot(equals(keyPair2['publicKey'])));
        expect(keyPair1['privateKey'], isNot(equals(keyPair2['privateKey'])));
      });
    });

    group('ECDH Key Exchange construction', () {
      late Map<String, String> keyPair;

      setUp(() async {
        keyPair = await ECDHKeyExchange.generateKeyPair();
      });

      test('creates ECDH instance with valid parameters', () {
        final expirationDate = DateTime.now().add(Duration(days: 1));
        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: expirationDate,
            expirationTimes: null,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(ecdh.algorithm, equals(KeyExchangeAlgorithm.ecdh));
        expect(ecdh.publicKey, equals(keyPair['publicKey']!));
        expect(ecdh.privateKey, equals(keyPair['privateKey']!));
        expect(ecdh.curve, equals(ECCKeyUtils.secp256r1));
        expect(ecdh.expirationDate, equals(expirationDate));
        expect(ecdh.isExpired(), isFalse);
      });

      test('creates ECDH instance without expiration date', () {
        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: null,
            expirationTimes: null,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(ecdh.algorithm, equals(KeyExchangeAlgorithm.ecdh));
        expect(ecdh.expirationDate, isNull);
        expect(ecdh.isExpired(), isFalse);
      });

      test('creates ECDH instance with expiration times limit', () {
        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: null,
            expirationTimes: 3,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp384r1,
        ));

        expect(ecdh.algorithm, equals(KeyExchangeAlgorithm.ecdh));
        expect(ecdh.curve, equals(ECCKeyUtils.secp384r1));
        expect(ecdh.isExpired(), isFalse);
      });
    });

    group('Shared Secret Generation', () {
      test('generates identical shared secrets for both parties', () async {
        // Simulate Alice and Bob
        final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
        final bobKeyPair = await ECDHKeyExchange.generateKeyPair();

        final aliceECDH = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: aliceKeyPair['publicKey']!,
          privateKey: aliceKeyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        final bobECDH = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: bobKeyPair['publicKey']!,
          privateKey: bobKeyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        // Alice generates shared secret using Bob's public key
        final aliceSharedSecret = await aliceECDH.generateSharedSecret(
          bobKeyPair['publicKey']!,
        );

        // Bob generates shared secret using Alice's public key
        final bobSharedSecret = await bobECDH.generateSharedSecret(
          aliceKeyPair['publicKey']!,
        );

        // The shared secrets should be identical
        expect(aliceSharedSecret, equals(bobSharedSecret));
        expect(aliceSharedSecret, isNotEmpty);
        
        // Shared secret should be hex encoded
        expect(RegExp(r'^[0-9a-fA-F]+$').hasMatch(aliceSharedSecret), isTrue);
      });

      test('generates different shared secrets with different key pairs', () async {
        final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
        final bobKeyPair = await ECDHKeyExchange.generateKeyPair();
        final charlieKeyPair = await ECDHKeyExchange.generateKeyPair();

        final aliceECDH = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: aliceKeyPair['publicKey']!,
          privateKey: aliceKeyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        // Alice generates shared secrets with Bob and Charlie
        final aliceBobSecret = await aliceECDH.generateSharedSecret(
          bobKeyPair['publicKey']!,
        );

        final aliceCharlieSecret = await aliceECDH.generateSharedSecret(
          charlieKeyPair['publicKey']!,
        );

        // The shared secrets should be different
        expect(aliceBobSecret, isNot(equals(aliceCharlieSecret)));
      });

      test('works with different curves', () async {
        final aliceKeyPair = await ECDHKeyExchange.generateKeyPair(
          curve: ECCKeyUtils.secp384r1,
        );
        final bobKeyPair = await ECDHKeyExchange.generateKeyPair(
          curve: ECCKeyUtils.secp384r1,
        );

        final aliceECDH = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: aliceKeyPair['publicKey']!,
          privateKey: aliceKeyPair['privateKey']!,
          curve: ECCKeyUtils.secp384r1,
        ));

        final bobECDH = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: bobKeyPair['publicKey']!,
          privateKey: bobKeyPair['privateKey']!,
          curve: ECCKeyUtils.secp384r1,
        ));

        final aliceSecret = await aliceECDH.generateSharedSecret(
          bobKeyPair['publicKey']!,
        );

        final bobSecret = await bobECDH.generateSharedSecret(
          aliceKeyPair['publicKey']!,
        );

        expect(aliceSecret, equals(bobSecret));
        expect(aliceSecret, isNotEmpty);
      });
    });

    group('Public Key Access', () {
      test('getPublicKey returns the same as publicKey property', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair();
        
        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(ecdh.getPublicKey(), equals(ecdh.publicKey));
        expect(ecdh.getPublicKey(), equals(keyPair['publicKey']!));
      });
    });

    group('Expiration handling', () {
      test('throws error when generating shared secret with expired key exchange', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair();
        final otherKeyPair = await ECDHKeyExchange.generateKeyPair();

        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().subtract(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(ecdh.isExpired(), isTrue);
        
        expect(
          () => ecdh.generateSharedSecret(otherKeyPair['publicKey']!),
          throwsStateError,
        );
      });

      test('handles expiration times correctly', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair();

        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: null,
            expirationTimes: 2,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(ecdh.isExpired(), isFalse);

        // Use it once
        ecdh.incrementUse();
        expect(ecdh.isExpired(), isFalse);

        // Use it twice
        ecdh.incrementUse();
        expect(ecdh.isExpired(), isTrue);
      });
    });

    group('Error handling', () {
      test('handles invalid public key format gracefully', () async {
        final keyPair = await ECDHKeyExchange.generateKeyPair();

        final ecdh = ECDHKeyExchange((
          parent: (
            algorithm: KeyExchangeAlgorithm.ecdh,
            expirationDate: DateTime.now().add(Duration(days: 1)),
            expirationTimes: null,
          ),
          publicKey: keyPair['publicKey']!,
          privateKey: keyPair['privateKey']!,
          curve: ECCKeyUtils.secp256r1,
        ));

        expect(
          () => ecdh.generateSharedSecret('invalid-public-key'),
          throwsArgumentError,
        );
      });
    });
  });
}