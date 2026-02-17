// import 'package:pointycastle/export.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/implementations/partial/asymmetric_sign_impl.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:basic_utils/basic_utils.dart' as BasicUtils;
import 'package:meta/meta.dart';

/// Input parameters for [ECDSASign] constructor.
@immutable
class InputECDSASign {
  final InputAsymmetricSign parent;

  const InputECDSASign({
    required this.parent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputECDSASign &&
          runtimeType == other.runtimeType &&
          parent == other.parent;

  @override
  int get hashCode => parent.hashCode;

  @override
  String toString() => 'InputECDSASign(parent: $parent)';
}

/// ECDSA signature implementation.
/// Extends [AsymmetricSign] and provides ECC-based digital signature operations.
@includeInBarrelFile
class ECDSASign extends AsymmetricSign {
  late final ECPublicKey _pubKey;
  late final ECPrivateKey? _privKey;

  ECDSASign(InputECDSASign input) : super(input.parent) {
    // ECC key parsing using basic_utils and PointyCastle
    final pubPem = input.parent.publicKey;
    final privPem = input.parent.privateKey;

    // Parse public key
    _pubKey = BasicUtils.CryptoUtils.ecPublicKeyFromPem(pubPem);

    // Parse private key (optional)
    _privKey = (privPem != null && privPem.isNotEmpty)
        ? BasicUtils.CryptoUtils.ecPrivateKeyFromPem(privPem)
        : null;
  }

  /// Generates an ECC key pair (PEM format)
  static Future<Map<String, String>> generateKeyPair(
      {String curve = 'prime256v1'}) async {
    final ecDomain = ECDomainParameters(curve);
    final keyGen = ECKeyGenerator();
    final params = ECKeyGeneratorParameters(ecDomain);
    final random = FortunaRandom();
    random.seed(KeyParameter(Uint8List.fromList(List.generate(
        32, (_) => DateTime.now().microsecondsSinceEpoch % 256))));
    keyGen.init(ParametersWithRandom(params, random));
    final pair = keyGen.generateKeyPair();
    final pubKey = pair.publicKey;
    final privKey = pair.privateKey;
    final pubPem = BasicUtils.CryptoUtils.encodeEcPublicKeyToPem(pubKey);
    final privPem = BasicUtils.CryptoUtils.encodeEcPrivateKeyToPem(privKey);
    return {'publicKey': pubPem, 'privateKey': privPem};
  }

  /// Creates an [ECDSASign] with full control over all parameters.
  ///
  /// Accepts the complete [InputECDSASign] record, allowing complete customization
  /// of all nested parameters. This factory automatically adapts to any changes
  /// in the input structure without requiring modifications.
  static ECDSASign createFull(InputECDSASign input) => ECDSASign(input);

  @override
  List<int> sign(List<int> data) {
    if (_privKey == null) {
      throw StateError('Private key required for signing');
    }
    final signer = ECDSASigner();
    final random = FortunaRandom();
    random.seed(KeyParameter(Uint8List.fromList(List.generate(
        32, (_) => DateTime.now().microsecondsSinceEpoch % 256))));
    signer.init(
        true,
        ParametersWithRandom(
            PrivateKeyParameter<ECPrivateKey>(_privKey!), random));
    final sig =
        signer.generateSignature(Uint8List.fromList(data)) as ECSignature;
    // For now, concatenate r and s as bytes (DER encoding not available in basic_utils)
    final rBytes = _bigIntToFixedBytes(sig.r, 32);
    final sBytes = _bigIntToFixedBytes(sig.s, 32);
    return Uint8List.fromList([...rBytes, ...sBytes]);
  }

  // Helper: encode BigInt to fixed-length bytes
  List<int> _bigIntToFixedBytes(BigInt value, int length) {
    final bytes =
        value.toUnsigned(8 * length).toRadixString(16).padLeft(length * 2, '0');
    return _hexToBytes(bytes);
  }

  // Helper to convert hex string to bytes
  List<int> _hexToBytes(String hex) {
    return List.generate(hex.length ~/ 2,
        (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16));
  }

  @override
  bool verify(List<int> data, List<int> signature) {
    final signer = ECDSASigner();
    signer.init(false, PublicKeyParameter<ECPublicKey>(_pubKey));
    // Split signature into r and s (assume 32 bytes each for prime256v1)
    final r = BigInt.parse(_bytesToHex(signature.sublist(0, 32)), radix: 16);
    final s = BigInt.parse(_bytesToHex(signature.sublist(32, 64)), radix: 16);
    final ecSig = ECSignature(r, s);
    final result = signer.verifySignature(Uint8List.fromList(data), ecSig);
    return result;
  }

  // Helper to convert bytes to hex string
  String _bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  CryptoAlgorithm get algorithm => ECDSASignAlgorithm.instance;
}
