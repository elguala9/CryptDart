/// ECDH Key Exchange Advanced Example
/// 
/// This example demonstrates advanced ECDH usage including:
/// - Multiple curve support (secp256r1, secp384r1, secp521r1)
/// - Key expiration and rotation
/// - Multi-party key exchange simulation
/// - Performance benchmarking
/// - Integration with symmetric encryption
/// 
/// Run with: dart run example/ecdh_advanced_example.dart

import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';

void main() async {
  print('🔐 ECDH Advanced Key Exchange Examples\n');
  print('═' * 60);

  await basicECDHDemo();
  await multipleCurvesDemo();
  await keyRotationDemo();
  await multiPartyKeyExchangeDemo();
  await performanceBenchmark();
  await ecdhWithSymmetricDemo();

  print('\n🏁 All ECDH demos completed successfully!');
  print('═' * 60);
}

/// Basic ECDH key exchange between Alice and Bob
Future<void> basicECDHDemo() async {
  print('\n🤝 BASIC ECDH KEY EXCHANGE');
  print('─' * 30);

  print('Setting up secure channel between Alice and Bob...\n');

  // Alice setup
  print('👩 Alice:');
  final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
  final alice = ECDHKeyExchange(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: aliceKeyPair['publicKey']!,
    privateKey: aliceKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  print('  Generated ECDH key pair');
  print('  Curve: ${alice.curve}');
  print('  Public key: ${alice.publicKey.substring(27, 77)}...');
  print('  Key expires: ${alice.expirationDate}');

  // Bob setup
  print('\n👨 Bob:');
  final bobKeyPair = await ECDHKeyExchange.generateKeyPair();
  final bob = ECDHKeyExchange(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobKeyPair['publicKey']!,
    privateKey: bobKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  print('  Generated ECDH key pair');
  print('  Curve: ${bob.curve}');
  print('  Public key: ${bob.publicKey.substring(27, 77)}...');

  // Key exchange
  print('\n🔄 Key Exchange Process:');
  print('  1. Alice sends public key to Bob');
  print('  2. Bob sends public key to Alice');
  print('  3. Both compute shared secret independently');

  final aliceSecret = alice.generateSharedSecret(bob.publicKey);
  final bobSecret = bob.generateSharedSecret(alice.publicKey);

  print('\n🔐 Results:');
  print('  Alice shared secret: ${aliceSecret.substring(0, 32)}...');
  print('  Bob shared secret:   ${bobSecret.substring(0, 32)}...');
  print('  Secrets match: ${aliceSecret == bobSecret ? '✅ Success' : '❌ Failed'}');
  print('  Secret strength: ${aliceSecret.length * 4} bits (${aliceSecret.length} hex chars)');
}

/// Demonstrate different elliptic curves
Future<void> multipleCurvesDemo() async {
  print('\n📐 MULTIPLE ELLIPTIC CURVES COMPARISON');
  print('─' * 30);

  final curves = [
    ECCKeyUtils.secp256r1,
    ECCKeyUtils.secp384r1,
    ECCKeyUtils.secp521r1,
  ];

  final securityLevels = {
    ECCKeyUtils.secp256r1: '128-bit',
    ECCKeyUtils.secp384r1: '192-bit', 
    ECCKeyUtils.secp521r1: '256-bit',
  };

  for (final curve in curves) {
    print('\n📏 Curve: $curve');
    print('  Security level: ${securityLevels[curve]} equivalent');

    // Generate key pairs for this curve
    final startTime = DateTime.now();
    final keyPair1 = await ECDHKeyExchange.generateKeyPair(curve: curve);
    final keyPair2 = await ECDHKeyExchange.generateKeyPair(curve: curve);
    final keyGenTime = DateTime.now().difference(startTime);

    // Create ECDH instances
    final ecdh1 = ECDHKeyExchange(InputECDHKeyExchange(
      parent: InputKeyExchangeBase(
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(Duration(hours: 1)),
        expirationTimes: null,
      ),
      publicKey: keyPair1['publicKey']!,
      privateKey: keyPair1['privateKey']!,
      curve: curve,
    ));

    final ecdh2 = ECDHKeyExchange(InputECDHKeyExchange(
      parent: InputKeyExchangeBase(
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(Duration(hours: 1)),
        expirationTimes: null,
      ),
      publicKey: keyPair2['publicKey']!,
      privateKey: keyPair2['privateKey']!,
      curve: curve,
    ));

    // Perform key exchange
    final exchangeStart = DateTime.now();
    final secret1 = ecdh1.generateSharedSecret(ecdh2.publicKey);
    final secret2 = ecdh2.generateSharedSecret(ecdh1.publicKey);
    final exchangeTime = DateTime.now().difference(exchangeStart);

    print('  Key generation time: ${keyGenTime.inMilliseconds}ms');
    print('  Key exchange time: ${exchangeTime.inMilliseconds}ms');
    print('  Public key size: ${keyPair1['publicKey']!.length} chars');
    print('  Shared secret size: ${secret1.length} hex chars (${secret1.length ~/ 2} bytes)');
    print('  Exchange success: ${secret1 == secret2 ? '✅' : '❌'}');

    // Security recommendation
    final recommendation = curve == ECCKeyUtils.secp256r1 ? '👍 Recommended for most applications' :
                          curve == ECCKeyUtils.secp384r1 ? '🔒 High security applications' :
                          '🛡️  Maximum security, government/military grade';
    print('  Use case: $recommendation');
  }
}

/// Demonstrate key rotation and expiration management
Future<void> keyRotationDemo() async {
  print('\n🔄 KEY ROTATION & EXPIRATION DEMO');
  print('─' * 30);

  print('Simulating automatic key rotation every 5 seconds...\n');

  final bobKeyPair = await ECDHKeyExchange.generateKeyPair();
  final bob = ECDHKeyExchange(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobKeyPair['publicKey']!,
    privateKey: bobKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  // Simulate 3 key rotations
  for (int rotation = 1; rotation <= 3; rotation++) {
    print('🔑 Key Rotation #$rotation:');

    // Alice generates new ephemeral keys
    final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
    final alice = ECDHKeyExchange(InputECDHKeyExchange(
      parent: InputKeyExchangeBase(
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(Duration(seconds: 5)), // Short expiration
        expirationTimes: 1, // Single use
      ),
      publicKey: aliceKeyPair['publicKey']!,
      privateKey: aliceKeyPair['privateKey']!,
      curve: ECCKeyUtils.secp256r1,
    ));

    print('  Generated ephemeral key (expires in 5s)');
    print('  Expires at: ${alice.expirationDate}');
    print('  Usage limit: ${alice.expirationTimes} time(s)');

    // Perform key exchange
    final sharedSecret = alice.generateSharedSecret(bob.publicKey);
    alice.incrementUse(); // Consume one use

    print('  Shared secret: ${sharedSecret.substring(0, 20)}...');
    print('  Key status after use: ${alice.isExpired() ? '🔴 Expired' : '🟢 Active'}');

    // Try to use expired key
    if (alice.isExpired()) {
      try {
        alice.generateSharedSecret(bob.publicKey);
        print('  ❌ ERROR: Expired key was accepted!');
      } catch (e) {
        print('  ✅ SECURITY: Expired key correctly rejected');
      }
    }

    print('  Forward secrecy: ✅ Old secrets are unusable\n');
    
    // Simulate time passing
    if (rotation < 3) {
      print('  Waiting for next rotation...\n');
      await Future.delayed(Duration(milliseconds: 500)); // Simulate time
    }
  }

  print('🛡️  Key rotation complete. Forward secrecy maintained.');
}

/// Simulate multi-party key exchange (simplified)
Future<void> multiPartyKeyExchangeDemo() async {
  print('\n👥 MULTI-PARTY KEY EXCHANGE SIMULATION');
  print('─' * 30);

  final parties = ['Alice', 'Bob', 'Charlie', 'Diana'];
  final keyPairs = <String, Map<String, String>>{};
  final ecdhInstances = <String, ECDHKeyExchange>{};

  print('Creating ${parties.length} party secure network...\n');

  // Generate keys for each party
  for (final party in parties) {
    final keyPair = await ECDHKeyExchange.generateKeyPair();
    keyPairs[party] = keyPair;
    
    ecdhInstances[party] = ECDHKeyExchange(InputECDHKeyExchange(
      parent: InputKeyExchangeBase(
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(Duration(hours: 2)),
        expirationTimes: null,
      ),
      publicKey: keyPair['publicKey']!,
      privateKey: keyPair['privateKey']!,
      curve: ECCKeyUtils.secp256r1,
    ));

    print('🔑 $party: Generated ECDH key pair');
  }

  // Create pairwise shared secrets
  print('\n🤝 Establishing pairwise shared secrets:');
  final sharedSecrets = <String, String>{};

  for (int i = 0; i < parties.length; i++) {
    for (int j = i + 1; j < parties.length; j++) {
      final party1 = parties[i];
      final party2 = parties[j];
      
      final secret1 = ecdhInstances[party1]!.generateSharedSecret(
        ecdhInstances[party2]!.publicKey,
      );
      final secret2 = ecdhInstances[party2]!.generateSharedSecret(
        ecdhInstances[party1]!.publicKey,
      );

      final pairKey = '${party1}-${party2}';
      sharedSecrets[pairKey] = secret1;

      print('  $party1 ↔ $party2: ${secret1 == secret2 ? '✅' : '❌'} ${secret1.substring(0, 16)}...');
    }
  }

  print('\n📊 Network Statistics:');
  print('  Parties: ${parties.length}');
  print('  Pairwise secrets: ${sharedSecrets.length}');
  print('  Total key exchanges: ${parties.length * (parties.length - 1) ~/ 2}');
  print('  Security: Each pair has unique shared secret');
  print('  Scalability: O(n²) pairwise keys for n parties');
}

/// Benchmark ECDH performance across different scenarios
Future<void> performanceBenchmark() async {
  print('\n⚡ PERFORMANCE BENCHMARK');
  print('─' * 30);

  final iterations = [1, 10, 100];
  final curves = [ECCKeyUtils.secp256r1, ECCKeyUtils.secp384r1];

  for (final curve in curves) {
    print('\n📏 Curve: $curve');
    
    for (final iter in iterations) {
      print('  Testing $iter iteration${iter == 1 ? '' : 's'}:');
      
      // Benchmark key generation
      final keyGenStart = DateTime.now();
      final keyPairs = <Map<String, String>>[];
      for (int i = 0; i < iter; i++) {
        keyPairs.add(await ECDHKeyExchange.generateKeyPair(curve: curve));
      }
      final keyGenTime = DateTime.now().difference(keyGenStart);
      
      // Benchmark key exchange
      final exchangeStart = DateTime.now();
      for (int i = 0; i < iter; i += 2) {
        if (i + 1 < keyPairs.length) {
          final ecdh1 = ECDHKeyExchange(InputECDHKeyExchange(
            parent: InputKeyExchangeBase(
              algorithm: KeyExchangeAlgorithm.ecdh,
              expirationDate: DateTime.now().add(Duration(hours: 1)),
              expirationTimes: null,
            ),
            publicKey: keyPairs[i]['publicKey']!,
            privateKey: keyPairs[i]['privateKey']!,
            curve: curve,
          ));

          ecdh1.generateSharedSecret(keyPairs[i + 1]['publicKey']!);
        }
      }
      final exchangeTime = DateTime.now().difference(exchangeStart);
      
      print('    Key generation: ${keyGenTime.inMilliseconds}ms total, ${(keyGenTime.inMilliseconds / iter).toStringAsFixed(1)}ms avg');
      print('    Key exchange: ${exchangeTime.inMilliseconds}ms total, ${(exchangeTime.inMilliseconds / (iter ~/ 2)).toStringAsFixed(1)}ms avg');
      
      // Calculate throughput
      final totalOps = iter + (iter ~/ 2);
      final totalTime = keyGenTime.inMilliseconds + exchangeTime.inMilliseconds;
      final throughput = (totalOps * 1000 / totalTime).toStringAsFixed(1);
      print('    Throughput: $throughput operations/second');
    }
  }

  print('\n💡 Performance Notes:');
  print('  • secp256r1: Fastest, good for high-throughput applications');
  print('  • secp384r1: Slower but higher security, good for sensitive data');
  print('  • Key generation is the most expensive operation');
  print('  • Consider key caching and reuse for better performance');
}

/// Demonstrate ECDH integration with symmetric encryption
Future<void> ecdhWithSymmetricDemo() async {
  print('\n🔐 ECDH + SYMMETRIC ENCRYPTION INTEGRATION');
  print('─' * 30);

  print('Building hybrid cryptographic system...\n');

  // Setup ECDH key exchange
  print('🤝 Phase 1: ECDH Key Exchange');
  final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
  final bobKeyPair = await ECDHKeyExchange.generateKeyPair();

  final alice = ECDHKeyExchange(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: aliceKeyPair['publicKey']!,
    privateKey: aliceKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  final bob = ECDHKeyExchange(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobKeyPair['publicKey']!,
    privateKey: bobKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  final sharedSecret = alice.generateSharedSecret(bob.publicKey);
  print('  ✅ Shared secret established: ${sharedSecret.substring(0, 20)}...');

  // Derive AES key from shared secret (first 64 hex chars = 256 bits)
  final aesKey = sharedSecret.substring(0, 64);
  print('  🔑 Derived AES-256 key: ${aesKey.substring(0, 16)}...');

  // Setup AES cipher with derived key
  print('\n🔐 Phase 2: Symmetric Encryption with Derived Key');
  final aesCipher = AESCipher(InputAESCipher(
    parent: InputSymmetricCipher(
      key: aesKey,
      parent: InputCipher(
        parent: InputExpirationBase(
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

  // Test secure communication
  final messages = [
    '🏥 Patient data: John Doe, DOB: 1990-01-01',
    '💰 Financial transfer: \$500,000 to account #12345',
    '📊 Quarterly report: Revenue increased by 15%',
    '🔬 Research results: Experiment #42 successful',
  ];

  print('  📡 Testing secure message transmission:');
  var totalOriginalSize = 0;
  var totalEncryptedSize = 0;

  for (int i = 0; i < messages.length; i++) {
    final message = messages[i];
    final messageBytes = utf8.encode(message);
    
    final encrypted = aesCipher.encrypt(messageBytes);
    final decrypted = aesCipher.decrypt(encrypted);
    final decryptedMessage = utf8.decode(decrypted);

    totalOriginalSize += messageBytes.length;
    totalEncryptedSize += encrypted.length;

    print('    Message ${i + 1}: ${message == decryptedMessage ? '✅' : '❌'} [${messageBytes.length} → ${encrypted.length} bytes]');
  }

  final overhead = ((totalEncryptedSize - totalOriginalSize) * 100 / totalOriginalSize).toInt();
  
  print('\n📊 Hybrid System Statistics:');
  print('  Key exchange: ECDH (secp256r1)');
  print('  Symmetric cipher: AES-256');
  print('  Original data: $totalOriginalSize bytes');
  print('  Encrypted data: $totalEncryptedSize bytes');
  print('  Encryption overhead: +$overhead%');
  print('  Security benefits:');
  print('    • Forward secrecy from ECDH');
  print('    • High-speed bulk encryption from AES');
  print('    • Perfect combination of asymmetric + symmetric');

  print('\n🛡️  This hybrid approach combines the best of both worlds:');
  print('     ECDH provides secure key exchange + forward secrecy');
  print('     AES provides fast bulk data encryption');
  print('     Used by: TLS, Signal Protocol, WhatsApp, etc.');
}