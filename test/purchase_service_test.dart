import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:yue_learn/services/purchase_service.dart';

void main() {
  late Directory testDirectory;

  setUpAll(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'yue_learn_purchase_test_',
    );
    Hive.init(testDirectory.path);
  });

  tearDownAll(() async {
    await testDirectory.delete(recursive: true);
  });

  test('starts a three-day trial only once', () async {
    final service = PurchaseService(boxName: 'purchase_trial_once');
    await service.init();

    expect(service.state, PurchaseState.locked);

    await service.startTrial();
    expect(service.state, PurchaseState.trial);
    expect(service.trialDaysRemaining, 3);

    await service.startTrial();
    expect(service.state, PurchaseState.trial);
    expect(service.trialDaysRemaining, 3);

    await Hive.box('purchase_trial_once').close();
    service.dispose();
  });

  test('does not reopen an expired trial', () async {
    final box = await Hive.openBox('purchase_expired');
    await box.put(
      'trial_start',
      DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    );
    await box.close();

    final service = PurchaseService(boxName: 'purchase_expired');
    await service.init();

    expect(service.state, PurchaseState.expired);
    expect(service.trialDaysRemaining, 0);

    await service.startTrial();
    expect(service.state, PurchaseState.expired);

    await Hive.box('purchase_expired').close();
    service.dispose();
  });

  test('recovers from a corrupted trial timestamp', () async {
    final box = await Hive.openBox('purchase_corrupted');
    await box.put('trial_start', 'not-a-date');
    await box.close();

    final service = PurchaseService(boxName: 'purchase_corrupted');
    await service.init();

    expect(service.state, PurchaseState.locked);

    await service.startTrial();
    expect(service.state, PurchaseState.trial);

    await Hive.box('purchase_corrupted').close();
    service.dispose();
  });

  test('persists a completed purchase across service instances', () async {
    final service = PurchaseService(boxName: 'purchase_persistence');
    await service.init();
    await service.completePurchase();
    expect(service.state, PurchaseState.active);
    await Hive.box('purchase_persistence').close();
    service.dispose();

    final restoredService = PurchaseService(boxName: 'purchase_persistence');
    await restoredService.init();
    expect(restoredService.state, PurchaseState.active);

    await Hive.box('purchase_persistence').close();
    restoredService.dispose();
  });
}
