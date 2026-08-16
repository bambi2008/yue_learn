import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yue_learn/screens/paywall/paywall_screen.dart';
import 'package:yue_learn/services/purchase_service.dart';

void main() {
  for (final size in const [Size(390, 844), Size(1366, 1024)]) {
    testWidgets('paywall renders at ${size.width}x${size.height}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final purchaseService = PurchaseService();
      addTearDown(purchaseService.dispose);

      await tester.pumpWidget(
        MaterialApp(home: PaywallScreen(purchaseService: purchaseService)),
      );

      expect(find.text('粤讲粤易'), findsOneWidget);
      expect(find.text('免费试用 3 天'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('恢复购买'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('purchase CTA explains when store billing is unavailable', (
    tester,
  ) async {
    final purchaseService = PurchaseService();

    await tester.pumpWidget(
      MaterialApp(home: PaywallScreen(purchaseService: purchaseService)),
    );

    final purchaseButton = find.widgetWithText(OutlinedButton, '购买 ¥68');
    expect(purchaseButton, findsOneWidget);

    await tester.ensureVisible(purchaseButton);
    await tester.tap(purchaseButton);
    await tester.pump();

    expect(find.text('正式支付尚未接入，请先使用免费试用。'), findsOneWidget);

    purchaseService.dispose();
  });
}
