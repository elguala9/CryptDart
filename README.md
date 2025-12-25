

# CryptDart

[![pub package](https://img.shields.io/pub/v/cryptdart.svg)](https://pub.dev/packages/cryptdart)
[![license](https://img.shields.io/badge/license-LGPL3-blue.svg)](LICENSE)
[![Dart](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)](https://dart.dev/)

**CryptDart** is a comprehensive, unified cryptography library for Dart that provides easy-to-use interfaces for symmetric/asymmetric encryption, digital signatures, key exchange protocols, and secure session management. Built on PointyCastle and BasicUtils with a focus on developer experience and security best practices.

## 🚀 Key Features

### 🔐 **Complete Cryptographic Suite**
- **Symmetric Encryption**: AES, ChaCha20, DES with multiple modes
- **Asymmetric Encryption**: RSA with configurable key sizes
- **Digital Signatures**: HMAC, RSA signatures, ECDSA (EdDSA support planned)
- **Key Exchange**: ECDH with multiple curves (secp256r1, secp384r1, secp521r1)

### 🏗️ **Clean Architecture**
- **Three-layer design**: Interfaces → Partial Implementations → Concrete Classes
- **Unified interfaces**: Consistent API across all algorithms
- **Expiration management**: Built-in key and cipher expiration handling
- **Centralized utilities**: No code duplication, easy maintenance

### 🔄 **Secure Session Management**
- **Bidirectional ECDH sessions**: Automatic key exchange and algorithm negotiation  
- **Forward secrecy**: Ephemeral keys for each session
- **Algorithm agility**: Dynamic selection of best available algorithms
- **Easy integration**: High-level factory methods for common use cases

### 🧪 **Production Ready**
- **Comprehensive tests**: 100+ test cases covering all scenarios
- **Strong typing**: Full Dart 3.0+ null safety and type safety
- **Error handling**: Robust error management and validation
- **Documentation**: Extensive examples and API documentation

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  cryptdart: ^0.1.2
```

Run:

```bash
dart pub get
```

## 🎯 Quick Start

### Basic Symmetric Encryption

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  // Generate a secure AES key
  final aesKey = AESCipher.generateKey();
  print('Generated AES key: ${aesKey.substring(0, 16)}...');

  // Create cipher with expiration
  final cipher = AESCipher((
    parent: (
      key: aesKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.aes,
          expirationDate: DateTime.now().add(Duration(hours: 24)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

  // Encrypt data
  final data = 'Hello, secure world! 🔐';
  final encrypted = cipher.encrypt(data.codeUnits);
  final decrypted = cipher.decrypt(encrypted);
  
  print('Original: $data');
  print('Decrypted: ${String.fromCharCodes(decrypted)}');
  print('Cipher expires: ${cipher.expirationDate}');
}
```

### Asymmetric Encryption & Digital Signatures

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  // Generate RSA key pair
  final keyPair = await RSACipher.generateKeyPair(bitLength: 2048);
  print('Generated RSA ${keyPair['publicKey']!.contains('BEGIN PUBLIC KEY') ? '✓' : '✗'}');

  // RSA Encryption
  final rsaCipher = RSACipher((
    parent: (
      publicKey: keyPair['publicKey']!,
      privateKey: keyPair['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsa,
          expirationDate: DateTime.now().add(Duration(days: 30)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

  final message = 'Secret message 🤫';
  final encrypted = await rsaCipher.encrypt(message.codeUnits);
  final decrypted = await rsaCipher.decrypt(encrypted);
  print('RSA decrypted: ${String.fromCharCodes(decrypted)}');

  // RSA Digital Signature
  final signature = RSASignatureCipher((
    parent: (
      publicKey: keyPair['publicKey']!,
      privateKey: keyPair['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsaSignature,
          expirationDate: DateTime.now().add(Duration(days: 30)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

  final signData = 'Document to sign';
  final sig = await signature.sign(signData.codeUnits);
  final verified = await signature.verifySignature(signData.codeUnits, sig);
  print('Signature verified: $verified ✓');
}
```

### ECDH Key Exchange & Secure Sessions

```dart
import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';

void main() async {
  print('🔄 Setting up secure ECDH communication...\n');

  // High-level secure session establishment
  final aliceSession = await SecureCommunicationFactory.initiateSecureSession(
    localPeerId: 'alice@example.com',
    supportedAsymmetric: [CryptoAlgorithm.rsa],
    supportedSymmetric: [CryptoAlgorithm.chacha20, CryptoAlgorithm.aes],
    sendToRemote: (initMessage) async {
      print('📤 Alice -> Bob: Session initiation');
      
      // Bob responds to Alice's initiation
      final bobResult = await SecureCommunicationFactory.respondToSecureSession(
        localPeerId: 'bob@example.com',
        initiationMessage: initMessage,
        supportedAsymmetric: [CryptoAlgorithm.rsa],
        supportedSymmetric: [CryptoAlgorithm.aes, CryptoAlgorithm.chacha20],
      );

      print('📤 Bob -> Alice: Session response');
      return bobResult.responseMessage;
    },
  );

  print('✅ Secure session established!');
  print('🔑 Key exchange: ${aliceSession.negotiationResult.keyExchange}');
  print('🔐 Symmetric cipher: ${aliceSession.negotiationResult.symmetric}');
  print('🔏 Asymmetric cipher: ${aliceSession.negotiationResult.asymmetric}');
  print('🕒 Session established: ${aliceSession.establishedAt}');
  print('📏 Shared secret length: ${aliceSession.sharedSecret.length} chars\n');

  // Test secure communication
  final messages = [
    '🚀 Mission critical data',
    '💎 Valuable cryptocurrency keys',
    '🏥 Medical records - patient #12345',
    '📋 Financial transaction: \$50,000 transfer',
  ];

  for (final message in messages) {
    final encrypted = aliceSession.encryptData(utf8.encode(message));
    final decrypted = aliceSession.decryptData(encrypted);
    final result = utf8.decode(decrypted);
    
    print('🔒 Encrypted & Decrypted: ${result == message ? '✅' : '❌'} "$message"');
  }
}
```

### Low-Level ECDH Key Exchange

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔐 Manual ECDH Key Exchange Demo\n');

  // Alice generates her ECDH key pair
  final aliceKeyPair = await ECDHKeyExchange.generateKeyPair(
    curve: ECCKeyUtils.secp256r1,
  );
  
  final aliceECDH = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: aliceKeyPair['publicKey']!,
    privateKey: aliceKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  // Bob generates his ECDH key pair
  final bobKeyPair = await ECDHKeyExchange.generateKeyPair(
    curve: ECCKeyUtils.secp256r1,
  );
  
  final bobECDH = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobKeyPair['publicKey']!,
    privateKey: bobKeyPair['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));

  print('👩 Alice public key: ${aliceECDH.getPublicKey().substring(0, 50)}...');
  print('👨 Bob public key: ${bobECDH.getPublicKey().substring(0, 50)}...');

  // Both parties generate the same shared secret
  final aliceSharedSecret = await aliceECDH.generateSharedSecret(
    bobECDH.getPublicKey(),
  );
  
  final bobSharedSecret = await bobECDH.generateSharedSecret(
    aliceECDH.getPublicKey(),
  );

  print('\n🔑 Alice shared secret: ${aliceSharedSecret.substring(0, 20)}...');
  print('🔑 Bob shared secret: ${bobSharedSecret.substring(0, 20)}...');
  print('✅ Secrets match: ${aliceSharedSecret == bobSharedSecret}');
  print('📏 Secret length: ${aliceSharedSecret.length} hex characters');
}
```

## 🏗️ Architecture Overview

CryptDart follows a clean, three-layer architecture:

```
┌─────────────────────────────────────┐
│           Interfaces                │  Abstract contracts defining operations
│  ICipher, ISymmetric, IAsymmetric   │  
│  ISign, IKeyExchange                │  
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│       Partial Implementations       │  Base classes with shared logic
│  SymmetricCipher, AsymmetricCipher  │  
│  CipherBase, SignBase               │  
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│      Concrete Implementations       │  Algorithm-specific implementations
│  AESCipher, RSACipher, HMACSign     │  
│  ECDHKeyExchange, ChaCha20Cipher    │  
└─────────────────────────────────────┘
```

### Directory Structure

```
lib/
├── interfaces/              # Abstract contracts
│   ├── i_cipher.dart       # Base cipher interface
│   ├── i_sign.dart         # Signature interface  
│   └── key_exchange/       # Key exchange interfaces
├── implementations/
│   ├── partial/            # Base classes with shared logic
│   ├── symmetric/          # AES, ChaCha20, DES implementations
│   ├── asymmetric/         # RSA implementations
│   ├── signed_based/       # HMAC, RSA signatures
│   ├── key_exchange/       # ECDH implementation
│   ├── session/            # Secure session management
│   └── handlers/           # High-level handler classes
├── types/                  # Enums and type definitions
└── utils/                  # Centralized utilities (NO duplication!)
```

## 🔧 Advanced Usage

### Custom Algorithm Selection

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  // Create session with specific algorithm preferences
  final customSession = await SecureCommunicationFactory.initiateSecureSession(
    localPeerId: 'secure-app-v2.1',
    supportedAsymmetric: [CryptoAlgorithm.rsa],
    supportedSymmetric: [CryptoAlgorithm.chacha20], // Only ChaCha20
    preferredKeyExchange: KeyExchangeAlgorithm.ecdh, // Prefer ECDH
    sendToRemote: (message) async {
      // Implement your network/IPC communication here
      return await sendToRemotePeer(message);
    },
  );

  print('Selected algorithms:');
  print('  Key Exchange: ${customSession.negotiationResult.keyExchange}');
  print('  Symmetric: ${customSession.negotiationResult.symmetric}');
  print('  Asymmetric: ${customSession.negotiationResult.asymmetric}');
}

Future<Map<String, dynamic>> sendToRemotePeer(Map<String, dynamic> message) async {
  // Your implementation here
  throw UnimplementedError('Implement your communication layer');
}
```

### HMAC Digital Signatures

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  // Generate HMAC key
  final hmacKey = HMACSign.generateKey();
  
  final hmacSign = HMACSign((
    parent: (
      key: hmacKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.hmac,
          expirationDate: DateTime.now().add(Duration(days: 7)),
          expirationTimes: 1000, // Limit to 1000 uses
        ),
      ),
    ),
  ));

  final document = 'Important contract terms and conditions...';
  final signature = await hmacSign.sign(document.codeUnits);
  final isValid = await hmacSign.verifyHMAC(document.codeUnits, signature);
  
  print('Document signed with HMAC: ${isValid ? '✅' : '❌'}');
  print('Remaining uses: ${hmacSign.expirationTimes}');
}
```

### ChaCha20 Stream Cipher

```dart
import 'package:cryptdart/cryptdart.dart';
import 'dart:typed_data';

void main() async {
  // Generate ChaCha20 key and nonce
  final key = ChaCha20Cipher.generateKey();
  final nonce = Uint8List.fromList(List<int>.generate(8, (i) => i * 2));
  
  final cipher = ChaCha20Cipher((
    nonce: nonce,
    parent: (
      key: key,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.chacha20,
          expirationDate: DateTime.now().add(Duration(hours: 2)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

  final streamData = List<int>.generate(1024, (i) => i % 256); // 1KB data
  final encrypted = cipher.encrypt(streamData);
  final decrypted = cipher.decrypt(encrypted);
  
  print('ChaCha20 stream cipher: ${listEquals(streamData, decrypted) ? '✅' : '❌'}');
  print('Processed ${streamData.length} bytes');
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
dart test

# Run specific test suites
dart test test/ecdh_key_exchange_test.dart    # ECDH key exchange tests
dart test test/secure_session_test.dart       # Secure session tests  
dart test test/symmetric_cipher_test.dart     # Symmetric encryption tests
dart test test/asymmetric_cipher_test.dart    # Asymmetric encryption tests
dart test test/key_generation_test.dart       # Key generation tests

# Run tests with coverage
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage.lcov --packages=.packages --report-on=lib
```

### Test Coverage

- ✅ **ECDH Key Exchange**: 14 comprehensive tests
- ✅ **Secure Sessions**: 3 integration tests  
- ✅ **Symmetric Ciphers**: AES, ChaCha20, DES encryption/decryption
- ✅ **Asymmetric Ciphers**: RSA encryption and signatures
- ✅ **Key Generation**: All algorithm key generation tests
- ✅ **Error Handling**: Invalid inputs, expiration, format errors
- ✅ **Integration**: End-to-end secure communication flows

## 📚 API Reference

### Core Interfaces

```dart
/// Base cipher interface with expiration support
abstract class ICipher extends IExpiration {
  CryptoAlgorithm get algorithm;
  List<int> encrypt(List<int> data);
  List<int> decrypt(List<int> encryptedData);
}

/// Key exchange protocol interface
abstract class IKeyExchange extends IBaseExpiration {
  KeyExchangeAlgorithm get algorithm;
  String get publicKey;
  Future<String> generateSharedSecret(String otherPublicKey);
}

/// Digital signature interface
abstract class ISign extends IBaseExpiration {
  CryptoAlgorithm get algorithm;
  Future<List<int>> sign(List<int> data);
  Future<bool> verifySignature(List<int> data, List<int> signature);
}
```

### Supported Algorithms

#### Symmetric Encryption
- **AES**: Advanced Encryption Standard (256-bit keys)
- **ChaCha20**: Modern stream cipher (256-bit keys + 64-bit nonce)
- **DES**: Data Encryption Standard (192-bit keys, legacy)

#### Asymmetric Encryption  
- **RSA**: Rivest-Shamir-Adleman (2048, 3072, 4096-bit keys)

#### Key Exchange
- **ECDH**: Elliptic Curve Diffie-Hellman
  - Curves: secp256r1, secp384r1, secp521r1

#### Digital Signatures
- **HMAC**: Hash-based Message Authentication Code
- **RSA Signatures**: RSA with SHA-256
- **ECDSA**: Elliptic Curve Digital Signature Algorithm (planned)

## 🛡️ Security Best Practices

### 1. Key Management
- ✅ Generate keys using cryptographically secure random number generators
- ✅ Use appropriate key sizes (AES-256, RSA-2048+, ECDH-256+)
- ✅ Implement proper key expiration and rotation policies
- ✅ Never hardcode keys in source code

### 2. Session Security
- ✅ Use ephemeral keys for forward secrecy
- ✅ Implement proper algorithm negotiation
- ✅ Validate all inputs and handle errors securely
- ✅ Use authenticated encryption when possible

### 3. Algorithm Selection
- 🥇 **Recommended**: ChaCha20 + ECDH + RSA signatures
- 🥈 **Good**: AES + ECDH + RSA signatures  
- ⚠️ **Legacy**: DES (avoid in new applications)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/elguala9/CryptDart.git
cd CryptDart

# Install dependencies
dart pub get

# Run tests
dart test

# Run analysis
dart analyze
```

## 📄 License

This project is licensed under the **GNU Lesser General Public License v3.0** (LGPL-3.0).

**What this means:**
- ✅ You can use CryptDart in commercial applications
- ✅ You can modify CryptDart for your needs
- ✅ You can distribute applications using CryptDart
- ℹ️ If you modify CryptDart itself, you must make those modifications available under LGPL-3.0
- ℹ️ You must include the LGPL-3.0 license notice

See the [LICENSE](LICENSE) file for complete details.

## 🔗 Links

- 📚 [API Documentation](https://pub.dev/documentation/cryptdart/latest/)
- 🐛 [Issue Tracker](https://github.com/elguala9/CryptDart/issues)  
- 💬 [Discussions](https://github.com/elguala9/CryptDart/discussions)
- 📦 [pub.dev Package](https://pub.dev/packages/cryptdart)

---

**Built with ❤️ for the Dart & Flutter community**

*Secure by design, easy by choice.* 🔐
