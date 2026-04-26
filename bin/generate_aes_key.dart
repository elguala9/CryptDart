import 'package:cryptdart/cryptdart.dart';

void main() {
  final aesKey = SymmetricKeyUtils.generateKey(bitLength: 256);
  print('Generated AES-256 Key (hex):');
  print(aesKey);
  print('');
  print('Length: ${aesKey.length ~/ 2} bytes = 256 bits');
}
