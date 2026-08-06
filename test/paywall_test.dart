import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yue_learn/screens/paywall/paywall_screen.dart';
import 'package:yue_learn/services/purchase_service.dart';

void main() {
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
