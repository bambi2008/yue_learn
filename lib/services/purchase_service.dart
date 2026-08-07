import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 购买状态
enum PurchaseState {
  trial, // 3天试用中
  active, // 已付费
  expired, // 试用过期未付费
  locked, // 从未购买
}

/// 正式购买的处理结果。
enum PurchaseResult { completed, unavailable }

/// 买断支付服务 — ¥68 终身 + 3天试用
class PurchaseService extends ChangeNotifier {
  static const String _purchaseBox = 'purchase';
  static const String _trialStartKey = 'trial_start';
  static const String _purchasedKey = 'purchased';

  final String _boxName;
  late Box _box;
  PurchaseState _state = PurchaseState.locked;
  DateTime? _trialStart;
  int _trialDaysRemaining = 3;

  PurchaseState get state => _state;
  int get trialDaysRemaining => _trialDaysRemaining;
  bool get isPurchased => _state == PurchaseState.active;
  bool get isTrial => _state == PurchaseState.trial;

  // Keep the public parameter name so tests and callers can inject a Hive box.
  // ignore: prefer_initializing_formals
  PurchaseService({String boxName = _purchaseBox}) : _boxName = boxName;

  /// 初始化（App 启动时调用）
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);

    final purchased = _box.get(_purchasedKey, defaultValue: false) as bool;

    if (purchased) {
      _state = PurchaseState.active;
      notifyListeners();
      return;
    }

    // 检查试用状态
    final trialStartStr = _box.get(_trialStartKey) as String?;

    if (trialStartStr != null) {
      try {
        _trialStart = DateTime.parse(trialStartStr);
        final elapsed = DateTime.now().difference(_trialStart!);
        final remaining = 3 - elapsed.inDays;

        if (remaining <= 0) {
          _state = PurchaseState.expired;
          _trialDaysRemaining = 0;
        } else {
          _state = PurchaseState.trial;
          _trialDaysRemaining = remaining;
        }
      } catch (_) {
        // 损坏的本地状态不能阻塞 App 启动，回到未开始试用状态。
        await _box.delete(_trialStartKey);
        _state = PurchaseState.locked;
      }
    } else {
      _state = PurchaseState.locked;
    }

    notifyListeners();
  }

  /// 开始 3 天试用
  Future<void> startTrial() async {
    // 已购买用户不能被外部调用切回试用状态。
    if (_state == PurchaseState.active ||
        (_box.get(_purchasedKey, defaultValue: false) as bool)) {
      return;
    }

    // 已经开始过的试用（包括已过期）不能重新计时。
    if (_box.get(_trialStartKey) != null) {
      return;
    }

    _trialStart = DateTime.now();
    _trialDaysRemaining = 3;
    _state = PurchaseState.trial;

    await _box.put(_trialStartKey, _trialStart!.toIso8601String());

    // 3 天后自动检查（App 重启时会重新计算）
    notifyListeners();
  }

  /// 完成购买（¥68 买断）
  Future<void> completePurchase() async {
    _state = PurchaseState.active;
    _trialDaysRemaining = 0;

    await _box.put(_purchasedKey, true);

    notifyListeners();
  }

  /// 发起正式购买。
  ///
  /// 商店 SDK 尚未接入前显式返回 unavailable，避免把本地状态写入误当成
  /// 真实支付成功。接入 App Store / Google Play 后，在这里处理商品查询、
  /// 支付发起和收据验证，再调用 completePurchase。
  Future<PurchaseResult> purchase() async {
    if (isPurchased) {
      return PurchaseResult.completed;
    }

    return PurchaseResult.unavailable;
  }

  /// 恢复购买
  Future<void> restorePurchase() async {
    // TODO: 实际对接 App Store / Google Play 收据验证
    final purchased = _box.get(_purchasedKey, defaultValue: false) as bool;
    if (purchased) {
      _state = PurchaseState.active;
    }
    notifyListeners();
  }

  /// 取消试用
  Future<void> cancelTrial() async {
    // 过期或已购买状态不能通过取消操作被重置。
    if (_state != PurchaseState.trial) {
      return;
    }

    _state = PurchaseState.locked;
    _trialDaysRemaining = 0;
    await _box.delete(_trialStartKey);
    notifyListeners();
  }
}
