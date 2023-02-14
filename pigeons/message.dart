import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class LibSuApi {
  @async
  String? getPlatformVersion();

  @async
  void configure(bool mountMaster, int timeoutInSeconds, bool debug);

  @async
  bool? isAppGrantedRoot();

  @async
  int createShell();

  @async
  int getShellStatus();

  @async
  bool isRoot();

  @async
  bool waitAndClose(int timeoutInSeconds);

  @async
  void waitForeverAndClose();

  @async
  void close();

  @async
  ShellOut exec(String cmd);

  @async
  ShellOut submit(String cmd);
}

class ShellOut {
  ShellOut({
    required this.stdout,
    required this.stderr,
    required this.success,
    required this.code,
  });

  final List<String?> stdout;
  final List<String?> stderr;
  final bool success;

  /// the return code of the last operation in the shell. If the job is
  /// executed properly, the code should range from 0-255. If the job fails to
  /// execute, it will return JOB_NOT_EXECUTED (-1).
  final int code;
}
