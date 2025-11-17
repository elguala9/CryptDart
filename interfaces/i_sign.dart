import 'i_expiration.dart';

abstract interface class ISign extends IExpiration{
  List<int> sign(List<int> data);
  bool verify(List<int> data);
}