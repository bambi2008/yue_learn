import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:yue_learn/app.dart';
import 'package:yue_learn/services/purchase_service.dart';

void main() {
  testWidgets('app shows the paywall before purchase', (tester) async {
    final purchaseService = PurchaseService();

    await tester.pumpWidget(
      ChangeNotifierProvider<PurchaseService>.value(
        value: purchaseService,
        child: const YueLearnApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('粤讲粤易'), findsOneWidget);
    expect(find.text('免费试用 3 天'), findsOneWidget);

    purchaseService.dispose();
  });
}
