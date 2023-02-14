import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:libsu_flutter/src/pigeon.dart';
import 'package:libsu_flutter/src/shell_status.dart';

/// A class providing APIs to an interactive Unix shell.
///
/// Similar to threads where there is a special "main thread", libsu also has
/// the concept of the "main shell". For each process, there is a single
/// globally shared "main shell" that is constructed on-demand and cached.
///
/// Only one shell can be created at a moment. Shell can be closed
/// and recreated if needed.
class Shell {
  Shell._(this._api);

  /// Singleton Shell object.
  static final instance = Shell._(LibSuApi());

  /// Singleton Shell object.
  static final i = instance;

  final LibSuApi _api;

  /// Configure default shell before the main shell can be created.
  ///
  /// [timeout] in seconds.
  ///
  /// It is optional to configure. If not configured shell with default config
  /// will be created.
  Future<void> configure({
    bool mountMaster = false,

    /// [timeout] in seconds
    int timeout = 20,
    bool debug = false,
  }) async {
    await _api.configure(mountMaster, timeout, debug);
  }

  /// Creates a main shell instance and return the status.
  ///
  /// Unless already cached, this method blocks until the main shell is created.
  /// The process could take a very long time (e.g. root permission request
  /// prompt), so be extra careful when calling this method from the main thread!
  ///
  /// A good practice is to "preheat" the main shell during app initialization
  /// (e.g. the splash screen) by either calling this method in a background
  /// thread or calling [createShell] so subsequent calls to this
  /// function returns immediately.
  Future<ShellStatus> createShell() async {
    final status = await _api.createShell();

    switch (status) {
      case 0:
        return ShellStatus.nonRootShell;
      case 1:
        return ShellStatus.rootShell;
      case 2:
        return ShellStatus.rootMountMaster;
      default:
        return ShellStatus.unknown;
    }
  }

  /// Whether the application has access to root.
  ///
  /// Checks for ROOT access without asking for ROOT permission.
  ///
  /// This method returns null when it is currently unable to determine whether
  /// root access has been granted to the application. A non-null value meant
  /// that the root permission grant state has been accurately determined and
  /// finalized. The application must have at least 1 root shell created to
  /// have this method return true. This method will not block the calling
  /// thread; results will be returned immediately.
  ///
  /// For example if Shell is never created it will return null.
  Future<bool?> isAppGrantedRoot() => _api.isAppGrantedRoot();

  /// Creates a Shell if not created yet and return whether the shell has root access.
  ///
  Future<bool?> isRoot() => _api.isRoot();

  /// Get the status of active shell.
  Future<ShellStatus> getShellStatus() async {
    final status = await _api.getShellStatus();

    switch (status) {
      case 0:
        return ShellStatus.nonRootShell;
      case 1:
        return ShellStatus.rootShell;
      case 2:
        return ShellStatus.rootMountMaster;
      default:
        return ShellStatus.unknown;
    }
  }

  /// Wait for any current/pending tasks to finish before closing this shell
  /// and release any system resources associated with the shell.
  ///
  /// Blocks until all current/pending tasks have completed execution, or the
  /// timeout occurs, or the current thread is interrupted, whichever happens
  /// first.
  ///
  /// [timeout] is the maximum time to wait.
  ///
  /// Returns true if shell is terminated and false if the timeout elapsed
  /// before termination, in which the shell can still to be used afterwards.
  Future<bool> waitAndClose(Duration timeout) =>
      _api.waitAndClose(timeout.inSeconds);

  /// Wait indefinitely for any current/pending tasks to finish before closing
  /// the shell and release any system resources associated with the shell.
  Future<void> waitForeverAndClose() => _api.waitForeverAndClose();

  /// Close the shell and release any system resources associated with the shell.
  Future<void> close() => _api.close();

  /// Execute a command and return the result.
  Future<ShellOut> exec(String cmd) => _api.exec(cmd);

  /// Execute a command and return the result.
  void submit(String cmd) => _api.submit(cmd);

  /// Execute a command. Result will be added to the stream.
  void listen() {
    const shellOutChannel =
        EventChannel('np.com.skstha.libsu_flutter_eventchannels/shellOut');

    shellOutChannel.receiveBroadcastStream().map((event) {
      return event;
    }).listen((event) {
      print(event.toString());
    });
  }

  /// Provides platform version.
  Future<String?> getPlatformVersion() => _api.getPlatformVersion();
}
