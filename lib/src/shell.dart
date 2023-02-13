import 'package:freezed_annotation/freezed_annotation.dart';
part 'shell.freezed.dart';

@freezed
class Shell with _$Shell {
  const factory Shell({
    required String status,
  }) = _Shell;
}
