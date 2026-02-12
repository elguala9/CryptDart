import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';

/// Input parameters for [SymmetricSign] constructor.
typedef InputSymmetricSign = ({
  InputSign parent,
  String key,
});

/// Base class for symmetric signature implementations.
/// Extends [Sign] and implements [ISymmetricSign].
@includeInBarrelFile
abstract class SymmetricSign extends Sign implements ISymmetricSign {
  final String _key;

  /// Constructs a [SymmetricSign] with the given input parameters.
  SymmetricSign(InputSymmetricSign input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;

  @override
  int get keyId => key.hashCode;
}
