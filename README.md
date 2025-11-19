

# CryptDart

[![pub package](https://img.shields.io/pub/v/cryptdart.svg)](https://pub.dev/packages/cryptdart)
[![license](https://img.shields.io/badge/license-LGPL3-blue.svg)](LICENSE)

Unified cryptography library for Dart. Provides easy-to-use interfaces for symmetric/asymmetric encryption, digital signatures, and key management. Built on PointyCastle and BasicUtils.

## Features

- Symmetric encryption: AES, TripleDES, ChaCha20
- Asymmetric encryption: RSA
- Digital signatures: HMAC, RSA signature
- Key generation and management
- Expiration logic for keys and ciphers
- Centralized utilities for encoding, random generation, and PEM parsing

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
	cryptdart: ^1.0.0
```

Run:

```sh
dart pub get
```

## Usage Example

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
	// Generate AES key
	final aesKey = AESCipher.generateKey();
	final cipher = AESCipher((parent: (key: aesKey)));
	final encrypted = cipher.encrypt([1, 2, 3, 4]);
	final decrypted = cipher.decrypt(encrypted);

	// Generate RSA key pair
	final rsaKeys = await RSACipher.generateKeyPair();
	final rsaCipher = RSACipher((parent: (publicKey: rsaKeys['publicKey']!, privateKey: rsaKeys['privateKey']!)));
	final rsaEncrypted = rsaCipher.encrypt([1, 2, 3, 4]);
	final rsaDecrypted = rsaCipher.decrypt(rsaEncrypted);
}
```

## Documentation

See [API reference](https://pub.dev/documentation/cryptdart/latest/) for details.

## License

This project is licensed under the GNU Lesser General Public License v3.0. See the [LICENSE](LICENSE) file for details.
