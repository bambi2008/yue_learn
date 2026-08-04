import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/review_card.dart';
import '../utils/constants.dart';

class SRSProvider extends ChangeNotifier {
  final Box<ReviewCard> _box = Hive.box<ReviewCard>(
    AppConstants.reviewCardsBox,
  );

  List<ReviewCard> get dueCards {
    return _box.values.where((c) => c.isDue).toList()
      ..sort((a, b) => a.nextReview.compareTo(b.nextReview));
  }

  int get dueCount => dueCards.length;

  int get totalCards => _box.length;

  /// 添加生词到 SRS 队列
  ReviewCard addCard({
    required String vocabId,
    required String cantonese,
    required String jyutping,
    required String mandarin,
    required String audioPath,
    String exampleCantonese = '',
    String exampleMandarin = '',
  }) {
    // 检查是否已存在
    final existing = _box.values.where((c) => c.vocabId == vocabId);
    if (existing.isNotEmpty) return existing.first;

    final card = ReviewCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vocabId: vocabId,
      cantonese: cantonese,
      jyutping: jyutping,
      mandarin: mandarin,
      audioPath: audioPath,
      exampleCantonese: exampleCantonese,
      exampleMandarin: exampleMandarin,
    );

    _box.put(card.id, card);
    notifyListeners();
    return card;
  }

  /// 批量添加
  void addCards(List<Map<String, String>> vocabList) {
    for (final v in vocabList) {
      addCard(
        vocabId: v['vocabId']!,
        cantonese: v['cantonese']!,
        jyutping: v['jyutping']!,
        mandarin: v['mandarin']!,
        audioPath: v['audioPath'] ?? '',
        exampleCantonese: v['exampleCantonese'] ?? '',
        exampleMandarin: v['exampleMandarin'] ?? '',
      );
    }
  }

  /// 评分并更新卡片
  void rateCard(String cardId, int quality) {
    final card = _box.get(cardId);
    if (card == null) return;

    card.update(quality);
    card.save();
    notifyListeners();
  }

  /// 获取下一张待复习卡片
  ReviewCard? get nextDueCard {
    if (dueCards.isEmpty) return null;
    return dueCards.first;
  }

  /// 删除卡片
  void deleteCard(String cardId) {
    _box.delete(cardId);
    notifyListeners();
  }
}
