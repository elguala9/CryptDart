import 'i_expiration.dart';

abstract class ICipher extends IExpiration{
  List<int> encrypt(List<int> data);
  List<int> decrypt(List<int> data);
}