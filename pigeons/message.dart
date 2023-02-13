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
}
