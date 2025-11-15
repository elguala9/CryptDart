import 'i_expiration.dart';

abstract interface class ISign extends IExpitration{
  List<int> sign(List<int> data);
  bool verify(List<int> data);
}