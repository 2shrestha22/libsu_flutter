import 'package:flutter_test/flutter_test.dart';
import 'package:libsu_flutter/pigeon.dart';

class MockLibsuFlutterPlatform implements LibSuApi {
  @override
  Future<bool?> isAppGrantedRoot() => Future.value(false);

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int> createShell() {
    // TODO: implement createShell
    throw UnimplementedError();
  }
}

void main() {
  test('getPlatformVersion', () async {
    MockLibsuFlutterPlatform fakePlatform = MockLibsuFlutterPlatform();
    expect(await fakePlatform.getPlatformVersion(), '42');
  });
}
