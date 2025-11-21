// RSA Signature: digital signature algorithm based on RSA
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:cryptdart/implementations/partial/asymmetric_sign_impl.dart';
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [RSASignatureCipher] constructor.
typedef InputRSASignatureCipher = ({
  InputAsymmetricSign parent,
});

/// RSA signature implementation.
/// Extends [AsymmetricSign] and provides RSA digital signature operations.
class RSASignatureCipher extends AsymmetricSign {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey? _privKey;

  /// Constructs an [RSASignatureCipher] with the given input parameters.
  RSASignatureCipher(InputRSASignatureCipher input) : super(input.parent) {
    final keys = RSAKeyUtils.parseKeyPair(
      publicKey: input.parent.publicKey,
      privateKey: input.parent.privateKey,
    );
    _pubKey = keys.publicKey;
    _privKey = keys.privateKey;
  }

  /// Generates an RSA key pair (PEM format) for signature.
  static Future<Map<String, String>> generateKeyPair(
      {int bitLength = 2048}) async {
    return RSAKeyUtils.generateKeyPair(bitLength: bitLength);
  }

  /// Signs data using RSA private key.
  @override
  List<int> sign(List<int> data) {
    if (_privKey == null) {
      throw StateError('Private key is required for signing');
    }
    // In RSA signature, "sign" represents signing the data with private key
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(_privKey!));
    final signature = signer.generateSignature(Uint8List.fromList(data));
    return signature.bytes;
  }

  @override

  /// Verify a signature against the original data
  bool verify(List<int> data, List<int> signature) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(false, PublicKeyParameter<RSAPublicKey>(_pubKey));
    final rsaSignature = RSASignature(Uint8List.fromList(signature));
    return signer.verifySignature(Uint8List.fromList(data), rsaSignature);
  }
}
