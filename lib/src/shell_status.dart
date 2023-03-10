enum ShellStatus {
  /// Shell status: Non-root shell. Constant value: 0
  nonRootShell,

  /// Shell status: Root shell. Constant value: 1
  rootShell,

  /// Shell status: Root shell with mount master enabled. Constant value: 2
  rootMountMaster,

  /// Shell status: Unknown.Constant value: -1
  unknown,
}
