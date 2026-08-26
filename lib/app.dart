import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/paywall/paywall_screen.dart';
import 'services/purchase_service.dart';

class YueLearnApp extends StatelessWidget {
  const YueLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '粤讲粤易',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: const _PaywallGate(),
    );
  }
}

/// 支付墙拦截器 — 未付费用户必须先看到支付墙
class _PaywallGate extends StatelessWidget {
  const _PaywallGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseService>(
      builder: (context, purchase, _) {
        // 内部测试包、已购买或试用中 → 进入主页。
        // 正式包不传 INTERNAL_TEST_ACCESS，仍保留支付墙。
        if (purchase.hasAccess) {
          return const HomeScreen();
        }

        // 未付费 → 显示支付墙
        return PaywallScreen(purchaseService: purchase);
      },
    );
  }
}
