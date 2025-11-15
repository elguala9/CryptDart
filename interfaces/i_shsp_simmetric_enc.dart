
import 'i_shsp_enc.dart';

abstract interface class ISimmetricCipher extends ICipher{
  String get key;
  static String generateKey() {
    throw UnimplementedError('generateKey needs to be implemented');
  }
}