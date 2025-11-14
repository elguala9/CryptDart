import 'i_shsp_enc.dart';

abstract interface class IAsymmetricEncryption extends IEncryption{
  String get publicKey;
  String get privateKey;
}