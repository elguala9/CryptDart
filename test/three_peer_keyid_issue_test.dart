import 'package:test/test.dart';
import 'package:cryptdart/implementations/key_exchange/ecdh_key_exchange.dart';
import 'package:cryptdart/implementations/partial/key_exchange_base.dart';
import 'package:cryptdart/types/key_exchange_algorithm.dart';
import 'package:cryptdart/utils/crypto_utils.dart';
import 'package:cryptdart/implementations/symmetric/aes_cipher.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';

void main() {
  group('Three-Peer KeyID Non-Determinism Issue', () {
    test('reproduces the keyId non-determinism bug', () async {
      // ════════════════════════════════════════════════════════════════════════════
      // PHASE 1: Setup - Generate three peers
      // ════════════════════════════════════════════════════════════════════════════

      print('\n🔧 PHASE 1: Setting up three peers\n');

      final peer1KeyPair = await ECDHKeyExchange.generateKeyPair();
      final peer2KeyPair = await ECDHKeyExchange.generateKeyPair();
      final peer3KeyPair = await ECDHKeyExchange.generateKeyPair();

      final peer1 = ECDHKeyExchange(InputECDHKeyExchange(
        parent: InputKeyExchangeBase(
          algorithm: KeyExchangeAlgorithm.ecdh,
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
        publicKey: peer1KeyPair['publicKey']!,
        privateKey: peer1KeyPair['privateKey']!,
        curve: ECCKeyUtils.secp256r1,
      ));

      final peer2 = ECDHKeyExchange(InputECDHKeyExchange(
        parent: InputKeyExchangeBase(
          algorithm: KeyExchangeAlgorithm.ecdh,
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
        publicKey: peer2KeyPair['publicKey']!,
        privateKey: peer2KeyPair['privateKey']!,
        curve: ECCKeyUtils.secp256r1,
      ));

      final peer3 = ECDHKeyExchange(InputECDHKeyExchange(
        parent: InputKeyExchangeBase(
          algorithm: KeyExchangeAlgorithm.ecdh,
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
        publicKey: peer3KeyPair['publicKey']!,
        privateKey: peer3KeyPair['privateKey']!,
        curve: ECCKeyUtils.secp256r1,
      ));

      print('✅ Three peers created: Peer1, Peer2, Peer3\n');

      // ════════════════════════════════════════════════════════════════════════════
      // PHASE 2: Peer1 generates AES cipher for encryption
      // ════════════════════════════════════════════════════════════════════════════

      print('📍 PHASE 2: Peer1 generates AES cipher\n');

      final sharedSecret1to2 = peer1.generateSharedSecret(peer2.publicKey);
      final sharedSecret1to3 = peer1.generateSharedSecret(peer3.publicKey);

      print('   Shared secret (Peer1→Peer2): ${sharedSecret1to2.substring(0, 32)}...');
      print('   Shared secret (Peer1→Peer3): ${sharedSecret1to3.substring(0, 32)}...\n');

      // Peer1 creates AES cipher for Peer2 (for encryption)
      final cipher1to2_encrypt = AESCipher(InputAESCipher(
        parent: InputSymmetricCipher(
          key: sharedSecret1to2,  // Use shared secret as key
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(hours: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));

      print('   ✅ Cipher (Peer1→Peer2) created for ENCRYPTION');
      print('      keyId: ${cipher1to2_encrypt.keyId}');
      print('      key (hex): ${cipher1to2_encrypt.key.substring(0, 32)}...\n');

      // ════════════════════════════════════════════════════════════════════════════
      // PHASE 3: Peer2 creates AES cipher for decryption from same shared secret
      // ════════════════════════════════════════════════════════════════════════════

      print('📍 PHASE 3: Peer2 creates AES cipher for decryption\n');

      // Peer2 computes the same shared secret with Peer1
      final sharedSecret2to1 = peer2.generateSharedSecret(peer1.publicKey);

      print('   Shared secret (Peer2→Peer1): ${sharedSecret2to1.substring(0, 32)}...');
      print('   Should match Peer1→Peer2: ${sharedSecret1to2 == sharedSecret2to1 ? '✅ YES' : '❌ NO'}\n');

      // Peer2 creates AES cipher for decryption (SAME shared secret)
      final cipher2to1_decrypt = AESCipher(InputAESCipher(
        parent: InputSymmetricCipher(
          key: sharedSecret2to1,  // SAME shared secret as Peer1
          parent: InputCipher(
            parent: InputExpirationBase(
              expirationDate: DateTime.now().add(Duration(hours: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));

      print('   ✅ Cipher (Peer2) created for DECRYPTION');
      print('      keyId: ${cipher2to1_decrypt.keyId}');
      print('      key (hex): ${cipher2to1_decrypt.key.substring(0, 32)}...\n');

      // ════════════════════════════════════════════════════════════════════════════
      // PHASE 4: Check for the bug - KeyIDs should match!
      // ════════════════════════════════════════════════════════════════════════════

      print('📍 PHASE 4: Verifying KeyID consistency\n');

      final keyId1 = cipher1to2_encrypt.keyId.toString();
      final keyId2 = cipher2to1_decrypt.keyId.toString();

      print('   Encryption cipher keyId: $keyId1');
      print('   Decryption cipher keyId: $keyId2');
      print('   Are they equal? ${keyId1 == keyId2 ? '✅ YES (GOOD)' : '❌ NO (BUG!)'}\n');

      // ════════════════════════════════════════════════════════════════════════════
      // PHASE 5: Test encryption/decryption
      // ════════════════════════════════════════════════════════════════════════════

      print('📍 PHASE 5: Testing encryption/decryption\n');

      final plaintext = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      final encrypted = cipher1to2_encrypt.encrypt(plaintext);

      print('   Plaintext:  $plaintext');
      print('   Encrypted:  ${encrypted.take(10).toList()}...');

      try {
        final decrypted = cipher2to1_decrypt.decrypt(encrypted);
        print('   Decrypted:  $decrypted');
        print('   Match: ${plaintext == decrypted ? '✅ YES' : '❌ NO'}\n');

        expect(plaintext, equals(decrypted),
          reason: 'Decryption should work with same shared secret');
      } catch (e) {
        print('   ❌ DECRYPTION FAILED: $e\n');
        throw e;
      }

      // ════════════════════════════════════════════════════════════════════════════
      // ASSERTION: KeyIDs must be identical for same shared secret
      // ════════════════════════════════════════════════════════════════════════════

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔍 ASSERTION\n');

      expect(
        keyId1,
        equals(keyId2),
        reason: '''
KeyIDs MUST be identical when ciphers are created from the same shared secret!

This is the bug: The keyId should be deterministic and based ONLY on the key.

KeyId 1 (Peer1 encryption): $keyId1
KeyId 2 (Peer2 decryption): $keyId2

If these are different, it means:
1. The shared secret is being modified (shouldn't happen with ECDH)
2. The keyId is being calculated from components that change (like IV)
3. There's a non-deterministic element in the cipher generation
        '''
      );

      print('✅ KeyIDs are consistent!\n');
    });
  });
}
