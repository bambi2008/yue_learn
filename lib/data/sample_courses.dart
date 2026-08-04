import '../models/course.dart';

/// 内置示例课程数据
class SampleCourses {
  SampleCourses._();

  static final List<CourseCategory> categories = [
    CourseCategory(
      id: 'dining',
      name: '餐饮',
      icon: '🍜',
      description: '从茶餐厅到酒楼，吃遍香港',
      totalScenes: 3,
      sceneIds: ['dining_1', 'dining_2', 'dining_3'],
    ),
    CourseCategory(
      id: 'transport',
      name: '交通',
      icon: '🚇',
      description: '港铁、巴士、的士，出行无忧',
      totalScenes: 3,
      sceneIds: ['transport_1', 'transport_2', 'transport_3'],
    ),
    CourseCategory(
      id: 'shopping',
      name: '购物',
      icon: '🛒',
      description: '超市商场药房，买得明白',
      totalScenes: 3,
      sceneIds: ['shopping_1', 'shopping_2', 'shopping_3'],
    ),
    CourseCategory(
      id: 'workplace',
      name: '职场',
      icon: '💼',
      description: '自我介绍到开会，职场必备',
      totalScenes: 3,
      sceneIds: ['workplace_1', 'workplace_2', 'workplace_3'],
    ),
  ];

  static final List<Scene> scenes = [
    // ========================
    // 🍜 餐饮篇
    // ========================
    Scene(
      id: 'dining_1',
      categoryId: 'dining',
      title: '茶餐厅点餐',
      subtitle: '学会在茶餐厅点一份地道的港式早餐',
      dialogues: [
        Dialogue(id: 'd1_1', title: '入座点餐', sentences: [
          Sentence(id: 'd1_1_s1', cantonese: '唔該，我要一個A餐。', jyutping: 'm4 goi1, ngo5 jiu3 jat1 go3 A caan1.', mandarin: '麻烦一下，我要一份A套餐。', audioPath: 'assets/audio/dining/d1_1_s1.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '唔該', jyutping: 'm4 goi1', mandarin: '麻烦/谢谢', literal: '不该→劳驾'),
            WordBreakdown(cantonese: '我要', jyutping: 'ngo5 jiu3', mandarin: '我要', literal: '我要'),
            WordBreakdown(cantonese: '一個', jyutping: 'jat1 go3', mandarin: '一个', literal: '一个'),
            WordBreakdown(cantonese: 'A餐', jyutping: 'A caan1', mandarin: 'A套餐', literal: 'A餐'),
          ]),
          Sentence(id: 'd1_1_s2', cantonese: '餐飲要熱奶茶，走得唔該。', jyutping: 'caan1 jam2 jiu3 jit6 naai5 caa4, zau2 dak1 m4 goi1.', mandarin: '饮料要热奶茶，少甜谢谢。', audioPath: 'assets/audio/dining/d1_1_s2.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '餐飲', jyutping: 'caan1 jam2', mandarin: '套餐饮料', literal: '餐饮'),
            WordBreakdown(cantonese: '熱奶茶', jyutping: 'jit6 naai5 caa4', mandarin: '热奶茶', literal: '热奶茶'),
            WordBreakdown(cantonese: '走甜', jyutping: 'zau2 tim4', mandarin: '少甜/去甜', literal: '走甜→去掉甜'),
            WordBreakdown(cantonese: '唔該', jyutping: 'm4 goi1', mandarin: '谢谢', literal: '谢谢'),
          ]),
          Sentence(id: 'd1_1_s3', cantonese: 'A餐，熱奶茶走甜。即刻到。', jyutping: 'A caan1, jit6 naai5 caa4 zau2 tim4. zik1 hak1 dou3.', mandarin: 'A套餐，热奶茶少甜。马上来。', audioPath: 'assets/audio/dining/d1_1_s3.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '即刻', jyutping: 'zik1 hak1', mandarin: '马上', literal: '即刻→马上'),
            WordBreakdown(cantonese: '到', jyutping: 'dou3', mandarin: '到/来', literal: '到'),
          ]),
          Sentence(id: 'd1_1_s4', cantonese: '唔好意思，要份公司三文治，飛邊。', jyutping: 'm4 hou2 ji3 si1, jiu3 fan6 gung1 si1 saam1 man4 zi6, fei1 bin1.', mandarin: '不好意思，要一份公司三明治，去面包边。', audioPath: 'assets/audio/dining/d1_1_s4.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '唔好意思', jyutping: 'm4 hou2 ji3 si1', mandarin: '不好意思', literal: '不好意思'),
            WordBreakdown(cantonese: '公司三文治', jyutping: 'gung1 si1 saam1 man4 zi6', mandarin: '公司三明治', literal: '公司三明治'),
            WordBreakdown(cantonese: '飛邊', jyutping: 'fei1 bin1', mandarin: '去面包边', literal: '飞边→去掉边'),
          ]),
          Sentence(id: 'd1_1_s5', cantonese: '收到。公司治飛邊，轉頭到。', jyutping: 'sau1 dou2. gung1 si1 zi6 fei1 bin1, zyun3 tau4 dou3.', mandarin: '收到。公司三明治去边，马上来。', audioPath: 'assets/audio/dining/d1_1_s5.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '收到', jyutping: 'sau1 dou2', mandarin: '收到', literal: '收到'),
            WordBreakdown(cantonese: '公司治', jyutping: 'gung1 si1 zi6', mandarin: '公司三明治(简称)', literal: '公司治'),
            WordBreakdown(cantonese: '轉頭', jyutping: 'zyun3 tau4', mandarin: '等一会儿', literal: '转头→过一会'),
          ]),
        ]),
        Dialogue(id: 'd1_2', title: '埋单结账', sentences: [
          Sentence(id: 'd1_2_s1', cantonese: '唔該，埋單。', jyutping: 'm4 goi1, maai4 daan1.', mandarin: '麻烦，买单。', audioPath: 'assets/audio/dining/d1_2_s1.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '埋單', jyutping: 'maai4 daan1', mandarin: '结账/买单', literal: '埋单→结账'),
          ]),
          Sentence(id: 'd1_2_s2', cantonese: '多謝，一共六十八蚊。', jyutping: 'do1 ze6, jat1 gung2 luk6 sap6 baat3 man1.', mandarin: '谢谢，一共六十八块。', audioPath: 'assets/audio/dining/d1_2_s2.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '多謝', jyutping: 'do1 ze6', mandarin: '谢谢(收钱时说)', literal: '多谢'),
            WordBreakdown(cantonese: '一共', jyutping: 'jat1 gung2', mandarin: '一共', literal: '一共'),
            WordBreakdown(cantonese: '六十八蚊', jyutping: 'luk6 sap6 baat3 man1', mandarin: '六十八元', literal: '六十八块'),
          ]),
          Sentence(id: 'd1_2_s3', cantonese: '俾張一百蚊你。', jyutping: 'bei2 zoeng1 jat1 baak3 man1 nei5.', mandarin: '给你一张一百块。', audioPath: 'assets/audio/dining/d1_2_s3.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '俾', jyutping: 'bei2', mandarin: '给', literal: '俾→给'),
            WordBreakdown(cantonese: '張', jyutping: 'zoeng1', mandarin: '张(量词)', literal: '张'),
            WordBreakdown(cantonese: '一百蚊', jyutping: 'jat1 baak3 man1', mandarin: '一百块', literal: '一百元'),
          ]),
          Sentence(id: 'd1_2_s4', cantonese: '找返三十二蚊，多謝晒。', jyutping: 'zaau2 faan1 saam1 sap6 ji6 man1, do1 ze6 saai3.', mandarin: '找回三十二块，谢谢。', audioPath: 'assets/audio/dining/d1_2_s4.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '找返', jyutping: 'zaau2 faan1', mandarin: '找回', literal: '找返→找回'),
            WordBreakdown(cantonese: '多謝晒', jyutping: 'do1 ze6 saai3', mandarin: '非常感谢', literal: '多谢晒→非常谢谢'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_d1_1', sceneId: 'dining_1', cantonese: '唔該', jyutping: 'm4 goi1', mandarin: '麻烦/谢谢', partOfSpeech: '习惯用语', audioPath: 'assets/audio/dining/v_d1_1.mp3', exampleCantonese: '唔該借借', exampleMandarin: '麻烦让一下'),
        VocabItem(id: 'v_d1_2', sceneId: 'dining_1', cantonese: '走甜', jyutping: 'zau2 tim4', mandarin: '去甜/少甜', partOfSpeech: '动词短语', audioPath: 'assets/audio/dining/v_d1_2.mp3', exampleCantonese: '凍檸茶走甜', exampleMandarin: '冻柠茶少甜'),
        VocabItem(id: 'v_d1_3', sceneId: 'dining_1', cantonese: '飛邊', jyutping: 'fei1 bin1', mandarin: '去面包边', partOfSpeech: '动词短语', audioPath: 'assets/audio/dining/v_d1_3.mp3', exampleCantonese: '多士飛邊', exampleMandarin: '吐司去边'),
        VocabItem(id: 'v_d1_4', sceneId: 'dining_1', cantonese: '即刻', jyutping: 'zik1 hak1', mandarin: '马上', partOfSpeech: '副词', audioPath: 'assets/audio/dining/v_d1_4.mp3', exampleCantonese: '即刻到', exampleMandarin: '马上来'),
        VocabItem(id: 'v_d1_5', sceneId: 'dining_1', cantonese: '埋單', jyutping: 'maai4 daan1', mandarin: '结账/买单', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d1_5.mp3', exampleCantonese: '唔該埋單', exampleMandarin: '麻烦买单'),
        VocabItem(id: 'v_d1_6', sceneId: 'dining_1', cantonese: '蚊', jyutping: 'man1', mandarin: '元/块', partOfSpeech: '量词', audioPath: 'assets/audio/dining/v_d1_6.mp3', exampleCantonese: '十蚊', exampleMandarin: '十块'),
        VocabItem(id: 'v_d1_7', sceneId: 'dining_1', cantonese: '俾', jyutping: 'bei2', mandarin: '给', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d1_7.mp3', exampleCantonese: '俾錢', exampleMandarin: '给钱'),
        VocabItem(id: 'v_d1_8', sceneId: 'dining_1', cantonese: '找返', jyutping: 'zaau2 faan1', mandarin: '找回', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d1_8.mp3', exampleCantonese: '找返錢俾你', exampleMandarin: '找钱给你'),
        VocabItem(id: 'v_d1_9', sceneId: 'dining_1', cantonese: '多謝', jyutping: 'do1 ze6', mandarin: '谢谢(收钱/收礼时)', partOfSpeech: '习惯用语', audioPath: 'assets/audio/dining/v_d1_9.mp3', exampleCantonese: '多謝晒', exampleMandarin: '非常感谢'),
        VocabItem(id: 'v_d1_10', sceneId: 'dining_1', cantonese: '轉頭', jyutping: 'zyun3 tau4', mandarin: '过一会', partOfSpeech: '副词', audioPath: 'assets/audio/dining/v_d1_10.mp3', exampleCantonese: '轉頭見', exampleMandarin: '待会见'),
      ],
      grammarNotes: [
        GrammarNote(title: '「唔該」vs「多謝」', explanation: '「唔該」用于请求帮忙或别人提供服务时(劳驾/麻烦)，「多謝」用于收到具体物品或钱财时。茶餐厅叫餐用「唔該」，结账收钱时伙计说「多謝」。', cantoneseExample: '入座：唔該 → 埋單找錢：多謝', mandarinExample: '入座：麻烦 → 买单找零：谢谢'),
        GrammarNote(title: '「走X」= 去掉X', explanation: '「走」在饮食语境下表示"去掉/不要"。如走甜=去糖，走冰=去冰，走青=去葱花。', cantoneseExample: '凍檸茶走甜走冰', mandarinExample: '冻柠茶去糖去冰'),
      ],
    ),
    Scene(
      id: 'dining_2',
      categoryId: 'dining',
      title: '酒楼饮茶',
      subtitle: '学懂去酒楼食点心饮茶的必备对话',
      dialogues: [
        Dialogue(id: 'd2_1', title: '等位入座', sentences: [
          Sentence(id: 'd2_1_s1', cantonese: '唔該，三位。', jyutping: 'm4 goi1, saam1 wai2.', mandarin: '麻烦，三位。', audioPath: 'assets/audio/dining/d2_1_s1.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '位', jyutping: 'wai2', mandarin: '位(人)', literal: '位→人'),
          ]),
          Sentence(id: 'd2_1_s2', cantonese: '三位，等下就有枱㗎喇。', jyutping: 'saam1 wai2, dang2 haa5 zau6 jau5 toi2 gaa3 laa3.', mandarin: '三位，等一下就有桌子了。', audioPath: 'assets/audio/dining/d2_1_s2.mp3', speaker: '知客', wordBreakdown: [
            WordBreakdown(cantonese: '等下', jyutping: 'dang2 haa5', mandarin: '等一下', literal: '等下'),
            WordBreakdown(cantonese: '枱', jyutping: 'toi2', mandarin: '桌子', literal: '枱→桌'),
            WordBreakdown(cantonese: '㗎喇', jyutping: 'gaa3 laa3', mandarin: '的了(语气词)', literal: '的了'),
          ]),
          Sentence(id: 'd2_1_s3', cantonese: '唔該，想飲咩茶？普洱定香片？', jyutping: 'm4 goi1, soeng2 jam2 me1 caa4? pou2 nei5 ding6 hoeng1 pin2?', mandarin: '请问想喝什么茶？普洱还是香片？', audioPath: 'assets/audio/dining/d2_1_s3.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '咩', jyutping: 'me1', mandarin: '什么', literal: '咩→什么'),
            WordBreakdown(cantonese: '定', jyutping: 'ding6', mandarin: '还是', literal: '定→还是'),
          ]),
          Sentence(id: 'd2_1_s4', cantonese: '普洱吖，唔該。', jyutping: 'pou2 nei5 aa1, m4 goi1.', mandarin: '普洱吧，谢谢。', audioPath: 'assets/audio/dining/d2_1_s4.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '吖', jyutping: 'aa1', mandarin: '吧(语气词)', literal: '吖→吧'),
          ]),
        ]),
        Dialogue(id: 'd2_2', title: '叫点心', sentences: [
          Sentence(id: 'd2_2_s1', cantonese: '整籠蝦餃同燒賣吖。', jyutping: 'zing2 lung4 haa1 gaau2 tung4 siu1 maai6 aa1.', mandarin: '来一笼虾饺和烧卖吧。', audioPath: 'assets/audio/dining/d2_2_s1.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '整', jyutping: 'zing2', mandarin: '弄/来', literal: '整→做/弄'),
            WordBreakdown(cantonese: '籠', jyutping: 'lung4', mandarin: '笼', literal: '笼'),
            WordBreakdown(cantonese: '同', jyutping: 'tung4', mandarin: '和', literal: '同→和'),
          ]),
          Sentence(id: 'd2_2_s2', cantonese: '好，仲有冇其他？', jyutping: 'hou2, zung6 jau5 mou5 kei4 taa1?', mandarin: '好的，还有其他吗？', audioPath: 'assets/audio/dining/d2_2_s2.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '仲', jyutping: 'zung6', mandarin: '还', literal: '仲→还'),
            WordBreakdown(cantonese: '冇', jyutping: 'mou5', mandarin: '没有', literal: '冇→没有'),
          ]),
          Sentence(id: 'd2_2_s3', cantonese: '加多碟腸粉，要牛肉嘅。', jyutping: 'gaa1 do1 dip6 coeng2 fan2, jiu3 ngau4 juk6 ge3.', mandarin: '再加一碟肠粉，要牛肉的。', audioPath: 'assets/audio/dining/d2_2_s3.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '加多', jyutping: 'gaa1 do1', mandarin: '再加', literal: '加多→多加'),
            WordBreakdown(cantonese: '碟', jyutping: 'dip6', mandarin: '碟(量词)', literal: '碟'),
            WordBreakdown(cantonese: '嘅', jyutping: 'ge3', mandarin: '的', literal: '嘅→的'),
          ]),
          Sentence(id: 'd2_2_s4', cantonese: '夠唔夠食呀？要唔要嗌多個炒飯？', jyutping: 'gau3 m4 gau3 sik6 aa3? jiu3 m4 jiu3 aai3 do1 go3 caau2 faan6?', mandarin: '够不够吃啊？要不要再多叫一个炒饭？', audioPath: 'assets/audio/dining/d2_2_s4.mp3', speaker: '伙计', wordBreakdown: [
            WordBreakdown(cantonese: '夠食', jyutping: 'gau3 sik6', mandarin: '够吃', literal: '够吃'),
            WordBreakdown(cantonese: '嗌', jyutping: 'aai3', mandarin: '叫/点', literal: '嗌→喊→叫'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_d2_1', sceneId: 'dining_2', cantonese: '枱', jyutping: 'toi2', mandarin: '桌子', partOfSpeech: '名词', audioPath: 'assets/audio/dining/v_d2_1.mp3', exampleCantonese: '等枱', exampleMandarin: '等位'),
        VocabItem(id: 'v_d2_2', sceneId: 'dining_2', cantonese: '咩', jyutping: 'me1', mandarin: '什么', partOfSpeech: '代词', audioPath: 'assets/audio/dining/v_d2_2.mp3', exampleCantonese: '做咩？', exampleMandarin: '干什么？'),
        VocabItem(id: 'v_d2_3', sceneId: 'dining_2', cantonese: '定', jyutping: 'ding6', mandarin: '还是(选择)', partOfSpeech: '连词', audioPath: 'assets/audio/dining/v_d2_3.mp3', exampleCantonese: 'A定B？', exampleMandarin: 'A还是B？'),
        VocabItem(id: 'v_d2_4', sceneId: 'dining_2', cantonese: '整', jyutping: 'zing2', mandarin: '做/弄', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d2_4.mp3', exampleCantonese: '整嘢食', exampleMandarin: '做饭'),
        VocabItem(id: 'v_d2_5', sceneId: 'dining_2', cantonese: '同', jyutping: 'tung4', mandarin: '和/跟', partOfSpeech: '连词', audioPath: 'assets/audio/dining/v_d2_5.mp3', exampleCantonese: '我同你', exampleMandarin: '我和你'),
        VocabItem(id: 'v_d2_6', sceneId: 'dining_2', cantonese: '仲', jyutping: 'zung6', mandarin: '还', partOfSpeech: '副词', audioPath: 'assets/audio/dining/v_d2_6.mp3', exampleCantonese: '仲有', exampleMandarin: '还有'),
        VocabItem(id: 'v_d2_7', sceneId: 'dining_2', cantonese: '加多', jyutping: 'gaa1 do1', mandarin: '再加', partOfSpeech: '动词短语', audioPath: 'assets/audio/dining/v_d2_7.mp3', exampleCantonese: '加多碗飯', exampleMandarin: '再加一碗饭'),
        VocabItem(id: 'v_d2_8', sceneId: 'dining_2', cantonese: '嘅', jyutping: 'ge3', mandarin: '的', partOfSpeech: '助词', audioPath: 'assets/audio/dining/v_d2_8.mp3', exampleCantonese: '我嘅', exampleMandarin: '我的'),
        VocabItem(id: 'v_d2_9', sceneId: 'dining_2', cantonese: '嗌', jyutping: 'aai3', mandarin: '叫/点', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d2_9.mp3', exampleCantonese: '嗌嘢食', exampleMandarin: '叫东西吃'),
        VocabItem(id: 'v_d2_10', sceneId: 'dining_2', cantonese: '夠食', jyutping: 'gau3 sik6', mandarin: '够吃', partOfSpeech: '形容词', audioPath: 'assets/audio/dining/v_d2_10.mp3', exampleCantonese: '唔夠食', exampleMandarin: '不够吃'),
      ],
      grammarNotes: [
        GrammarNote(title: '「A定B」= A还是B', explanation: '粤语中「定」用作选择题的"还是"，跟普通话"还是"用法相同但位置更灵活。', cantoneseExample: '飲茶定咖啡？', mandarinExample: '喝茶还是咖啡？'),
        GrammarNote(title: '「嘅」= 的', explanation: '粤语「嘅」等同于普通话"的"，是粤语最常用的助词之一，表示所属关系。', cantoneseExample: '我嘅書 = 我的书', mandarinExample: '我的书'),
      ],
    ),
    Scene(
      id: 'dining_3',
      categoryId: 'dining',
      title: '街市买菜',
      subtitle: '去香港街市（菜市场）买菜讲价',
      dialogues: [
        Dialogue(id: 'd3_1', title: '买菜讲价', sentences: [
          Sentence(id: 'd3_1_s1', cantonese: '阿姐，呢個菜心幾錢斤呀？', jyutping: 'aa3 ze1, ni1 go3 coi3 sam1 gei2 cin1 gan1 aa3?', mandarin: '大姐，这个菜心多少钱一斤？', audioPath: 'assets/audio/dining/d3_1_s1.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '阿姐', jyutping: 'aa3 ze1', mandarin: '大姐', literal: '大姐'),
            WordBreakdown(cantonese: '呢個', jyutping: 'ni1 go3', mandarin: '这个', literal: '这个'),
            WordBreakdown(cantonese: '幾錢', jyutping: 'gei2 cin1', mandarin: '多少钱', literal: '几钱'),
            WordBreakdown(cantonese: '斤', jyutping: 'gan1', mandarin: '斤(600g)', literal: '斤'),
          ]),
          Sentence(id: 'd3_1_s2', cantonese: '十二蚊斤，好新鮮㗎，今朝先返貨。', jyutping: 'sap6 ji6 man1 gan1, hou2 san1 sin1 gaa3, gam1 ziu1 sin1 faan2 fo3.', mandarin: '十二块一斤，很新鲜的，今早刚到的货。', audioPath: 'assets/audio/dining/d3_1_s2.mp3', speaker: '菜贩', wordBreakdown: [
            WordBreakdown(cantonese: '新鮮', jyutping: 'san1 sin1', mandarin: '新鲜', literal: '新鲜'),
            WordBreakdown(cantonese: '今朝', jyutping: 'gam1 ziu1', mandarin: '今天早上', literal: '今朝→今早'),
            WordBreakdown(cantonese: '返貨', jyutping: 'faan2 fo3', mandarin: '进货/到货', literal: '返货→货到'),
          ]),
          Sentence(id: 'd3_1_s3', cantonese: '平啲得唔得呀？十蚊斤啦。', jyutping: 'peng4 di1 dak1 m4 dak1 aa3? sap6 man1 gan1 laa1.', mandarin: '便宜点行不行？十块一斤吧。', audioPath: 'assets/audio/dining/d3_1_s3.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '平啲', jyutping: 'peng4 di1', mandarin: '便宜一点', literal: '平→便宜 + 啲→一点'),
            WordBreakdown(cantonese: '得唔得', jyutping: 'dak1 m4 dak1', mandarin: '行不行', literal: '得不得'),
          ]),
          Sentence(id: 'd3_1_s4', cantonese: '好啦好啦，十蚊俾你。要多啲嚟幫襯喎！', jyutping: 'hou2 laa1 hou2 laa1, sap6 man1 bei2 nei5. jiu3 do1 di1 lei4 bong1 can3 wo3!', mandarin: '好吧好吧，十块给你。要多来光顾哦！', audioPath: 'assets/audio/dining/d3_1_s4.mp3', speaker: '菜贩', wordBreakdown: [
            WordBreakdown(cantonese: '嚟', jyutping: 'lei4', mandarin: '来', literal: '嚟→来'),
            WordBreakdown(cantonese: '幫襯', jyutping: 'bong1 can3', mandarin: '光顾', literal: '帮衬→光顾'),
          ]),
          Sentence(id: 'd3_1_s5', cantonese: '唔該晒，再要半斤瘦肉。', jyutping: 'm4 goi1 saai3, zoi3 jiu3 bun3 gan1 sau3 juk6.', mandarin: '太谢谢了，再来半斤瘦肉。', audioPath: 'assets/audio/dining/d3_1_s5.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '唔該晒', jyutping: 'm4 goi1 saai3', mandarin: '非常感谢', literal: '谢谢晒→非常感谢'),
            WordBreakdown(cantonese: '瘦肉', jyutping: 'sau3 juk6', mandarin: '瘦肉', literal: '瘦肉'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_d3_1', sceneId: 'dining_3', cantonese: '幾錢', jyutping: 'gei2 cin1', mandarin: '多少钱', partOfSpeech: '疑问词', audioPath: 'assets/audio/dining/v_d3_1.mp3', exampleCantonese: '呢個幾錢？', exampleMandarin: '这个多少钱？'),
        VocabItem(id: 'v_d3_2', sceneId: 'dining_3', cantonese: '斤', jyutping: 'gan1', mandarin: '斤(600克)', partOfSpeech: '量词', audioPath: 'assets/audio/dining/v_d3_2.mp3'),
        VocabItem(id: 'v_d3_3', sceneId: 'dining_3', cantonese: '平啲', jyutping: 'peng4 di1', mandarin: '便宜点', partOfSpeech: '形容词短语', audioPath: 'assets/audio/dining/v_d3_3.mp3', exampleCantonese: '可唔可以平啲？', exampleMandarin: '可以便宜点吗？'),
        VocabItem(id: 'v_d3_4', sceneId: 'dining_3', cantonese: '得唔得', jyutping: 'dak1 m4 dak1', mandarin: '行不行/可以吗', partOfSpeech: '疑问短语', audioPath: 'assets/audio/dining/v_d3_4.mp3'),
        VocabItem(id: 'v_d3_5', sceneId: 'dining_3', cantonese: '今朝', jyutping: 'gam1 ziu1', mandarin: '今天早上', partOfSpeech: '时间词', audioPath: 'assets/audio/dining/v_d3_5.mp3', exampleCantonese: '今朝好早起身', exampleMandarin: '今天早上很早起床'),
        VocabItem(id: 'v_d3_6', sceneId: 'dining_3', cantonese: '返貨', jyutping: 'faan2 fo3', mandarin: '进货/到货', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d3_6.mp3'),
        VocabItem(id: 'v_d3_7', sceneId: 'dining_3', cantonese: '嚟', jyutping: 'lei4', mandarin: '来', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d3_7.mp3', exampleCantonese: '過嚟', exampleMandarin: '过来'),
        VocabItem(id: 'v_d3_8', sceneId: 'dining_3', cantonese: '幫襯', jyutping: 'bong1 can3', mandarin: '光顾', partOfSpeech: '动词', audioPath: 'assets/audio/dining/v_d3_8.mp3', exampleCantonese: '多謝幫襯', exampleMandarin: '谢谢光顾'),
        VocabItem(id: 'v_d3_9', sceneId: 'dining_3', cantonese: '唔該晒', jyutping: 'm4 goi1 saai3', mandarin: '非常感谢', partOfSpeech: '习惯用语', audioPath: 'assets/audio/dining/v_d3_9.mp3'),
        VocabItem(id: 'v_d3_10', sceneId: 'dining_3', cantonese: '瘦肉', jyutping: 'sau3 juk6', mandarin: '瘦肉', partOfSpeech: '名词', audioPath: 'assets/audio/dining/v_d3_10.mp3'),
      ],
      grammarNotes: [
        GrammarNote(title: '「A唔A」疑问式', explanation: '粤语最常见的疑问句式，将形容词/动词重复并用「唔」连接。类似普通话"A不A"。', cantoneseExample: '好唔好？得唔得？去唔去？', mandarinExample: '好不好？行不行？去不去？'),
        GrammarNote(title: '「啲」= 一点', explanation: '「啲」是粤语最常用的不确定量词，相当于"一点/一些"。多啲=多点，少啲=少点。', cantoneseExample: '食多啲啦', mandarinExample: '多吃一点吧'),
      ],
    ),

    // ========================
    // 🚇 交通篇
    // ========================
    Scene(
      id: 'transport_1',
      categoryId: 'transport',
      title: '搭港铁',
      subtitle: '学会用八达通搭港铁，问路轉車',
      dialogues: [
        Dialogue(id: 't1_1', title: '问路搭车', sentences: [
          Sentence(id: 't1_1_s1', cantonese: '唔好意思，去旺角點樣搭車呀？', jyutping: 'm4 hou2 ji3 si1, heoi3 wong6 gok3 dim2 joeng2 daap3 ce1 aa3?', mandarin: '不好意思，去旺角怎么坐车？', audioPath: 'assets/audio/transport/t1_1_s1.mp3', speaker: '路人', wordBreakdown: [
            WordBreakdown(cantonese: '點樣', jyutping: 'dim2 joeng2', mandarin: '怎么', literal: '点样→怎样'),
            WordBreakdown(cantonese: '搭車', jyutping: 'daap3 ce1', mandarin: '坐车/乘车', literal: '搭车'),
          ]),
          Sentence(id: 't1_1_s2', cantonese: '你搭荃灣綫，兩個站就到㗎喇。', jyutping: 'nei5 daap3 cyun4 waan1 sin3, loeng5 go3 zaam6 zau6 dou3 gaa3 laa3.', mandarin: '你坐荃湾线，两个站就到了。', audioPath: 'assets/audio/transport/t1_1_s2.mp3', speaker: '港人', wordBreakdown: [
            WordBreakdown(cantonese: '荃灣綫', jyutping: 'cyun4 waan1 sin3', mandarin: '荃湾线', literal: '荃湾线'),
            WordBreakdown(cantonese: '站', jyutping: 'zaam6', mandarin: '站', literal: '站'),
          ]),
          Sentence(id: 't1_1_s3', cantonese: '使唔使轉車㗎？', jyutping: 'sai2 m4 sai2 zyun3 ce1 gaa3?', mandarin: '需要换乘吗？', audioPath: 'assets/audio/transport/t1_1_s3.mp3', speaker: '路人', wordBreakdown: [
            WordBreakdown(cantonese: '使唔使', jyutping: 'sai2 m4 sai2', mandarin: '需不需要', literal: '使不使→需不需要'),
            WordBreakdown(cantonese: '轉車', jyutping: 'zyun3 ce1', mandarin: '换乘', literal: '转车'),
          ]),
          Sentence(id: 't1_1_s4', cantonese: '唔使轉車，直達㗎。', jyutping: 'm4 sai2 zyun3 ce1, zik6 daat6 gaa3.', mandarin: '不用换乘，直达的。', audioPath: 'assets/audio/transport/t1_1_s4.mp3', speaker: '港人', wordBreakdown: [
            WordBreakdown(cantonese: '唔使', jyutping: 'm4 sai2', mandarin: '不用', literal: '不使→不用'),
            WordBreakdown(cantonese: '直達', jyutping: 'zik6 daat6', mandarin: '直达', literal: '直达'),
          ]),
        ]),
        Dialogue(id: 't1_2', title: '八达通增值', sentences: [
          Sentence(id: 't1_2_s1', cantonese: '唔該，想增值一百蚊。', jyutping: 'm4 goi1, soeng2 zang1 zik6 jat1 baak3 man1.', mandarin: '麻烦，想充值一百块。', audioPath: 'assets/audio/transport/t1_2_s1.mp3', speaker: '路人', wordBreakdown: [
            WordBreakdown(cantonese: '增值', jyutping: 'zang1 zik6', mandarin: '充值', literal: '增值→充值'),
          ]),
          Sentence(id: 't1_2_s2', cantonese: '得，拍卡呢度。', jyutping: 'dak1, paak3 kaat1 ni1 dou6.', mandarin: '好的，拍卡在这里。', audioPath: 'assets/audio/transport/t1_2_s2.mp3', speaker: '职员', wordBreakdown: [
            WordBreakdown(cantonese: '得', jyutping: 'dak1', mandarin: '好的/行', literal: '得→行'),
            WordBreakdown(cantonese: '拍卡', jyutping: 'paak3 kaat1', mandarin: '刷卡', literal: '拍卡'),
            WordBreakdown(cantonese: '呢度', jyutping: 'ni1 dou6', mandarin: '这里', literal: '呢度→这里'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_t1_1', sceneId: 'transport_1', cantonese: '點樣', jyutping: 'dim2 joeng2', mandarin: '怎么/怎样', partOfSpeech: '疑问词', audioPath: 'assets/audio/transport/v_t1_1.mp3'),
        VocabItem(id: 'v_t1_2', sceneId: 'transport_1', cantonese: '搭車', jyutping: 'daap3 ce1', mandarin: '坐车', partOfSpeech: '动词', audioPath: 'assets/audio/transport/v_t1_2.mp3'),
        VocabItem(id: 'v_t1_3', sceneId: 'transport_1', cantonese: '站', jyutping: 'zaam6', mandarin: '站', partOfSpeech: '名词', audioPath: 'assets/audio/transport/v_t1_3.mp3'),
        VocabItem(id: 'v_t1_4', sceneId: 'transport_1', cantonese: '使唔使', jyutping: 'sai2 m4 sai2', mandarin: '需不需要', partOfSpeech: '疑问短语', audioPath: 'assets/audio/transport/v_t1_4.mp3'),
        VocabItem(id: 'v_t1_5', sceneId: 'transport_1', cantonese: '轉車', jyutping: 'zyun3 ce1', mandarin: '换乘', partOfSpeech: '动词', audioPath: 'assets/audio/transport/v_t1_5.mp3'),
        VocabItem(id: 'v_t1_6', sceneId: 'transport_1', cantonese: '唔使', jyutping: 'm4 sai2', mandarin: '不用', partOfSpeech: '副词', audioPath: 'assets/audio/transport/v_t1_6.mp3'),
        VocabItem(id: 'v_t1_7', sceneId: 'transport_1', cantonese: '增值', jyutping: 'zang1 zik6', mandarin: '充值', partOfSpeech: '动词', audioPath: 'assets/audio/transport/v_t1_7.mp3'),
        VocabItem(id: 'v_t1_8', sceneId: 'transport_1', cantonese: '拍卡', jyutping: 'paak3 kaat1', mandarin: '刷卡', partOfSpeech: '动词短语', audioPath: 'assets/audio/transport/v_t1_8.mp3'),
        VocabItem(id: 'v_t1_9', sceneId: 'transport_1', cantonese: '呢度', jyutping: 'ni1 dou6', mandarin: '这里', partOfSpeech: '代词', audioPath: 'assets/audio/transport/v_t1_9.mp3'),
        VocabItem(id: 'v_t1_10', sceneId: 'transport_1', cantonese: '直達', jyutping: 'zik6 daat6', mandarin: '直达', partOfSpeech: '形容词', audioPath: 'assets/audio/transport/v_t1_10.mp3'),
      ],
      grammarNotes: [
        GrammarNote(title: '「使唔使」= 需不需要', explanation: '「使」在粤语中是"需要"的意思。「使唔使」用于询问是否必要，否定是「唔使」。', cantoneseExample: '使唔使帶遮？唔使。', mandarinExample: '需要带伞吗？不用。'),
      ],
    ),
    Scene(
      id: 'transport_2',
      categoryId: 'transport',
      title: '搭巴士小巴',
      subtitle: '学会搭巴士和红色小巴的常用语',
      dialogues: [
        Dialogue(id: 't2_1', title: '搭巴士', sentences: [
          Sentence(id: 't2_1_s1', cantonese: '呢架巴士去唔去銅鑼灣㗎？', jyutping: 'ni1 gaa3 baa1 si2 heoi3 m4 heoi3 tung4 lo4 waan1 gaa3?', mandarin: '这辆巴士去不去铜锣湾？', audioPath: 'assets/audio/transport/t2_1_s1.mp3', speaker: '乘客'),
          Sentence(id: 't2_1_s2', cantonese: '去㗎，上車拍卡啦。', jyutping: 'heoi3 gaa3, soeng5 ce1 paak3 kaat1 laa1.', mandarin: '去的，上车刷卡吧。', audioPath: 'assets/audio/transport/t2_1_s2.mp3', speaker: '司机'),
          Sentence(id: 't2_1_s3', cantonese: '司機唔該，下個站有落。', jyutping: 'si1 gei1 m4 goi1, haa6 go3 zaam6 jau5 lok6.', mandarin: '司机麻烦，下一个站下车。', audioPath: 'assets/audio/transport/t2_1_s3.mp3', speaker: '乘客', wordBreakdown: [
            WordBreakdown(cantonese: '有落', jyutping: 'jau5 lok6', mandarin: '要下车', literal: '有落→有(人)下车'),
          ]),
        ]),
        Dialogue(id: 't2_2', title: '搭小巴', sentences: [
          Sentence(id: 't2_2_s1', cantonese: '司機，前面街口有落呀！', jyutping: 'si1 gei1, cin4 min6 gaai1 hau2 jau5 lok6 aa3!', mandarin: '司机，前面街口下车！', audioPath: 'assets/audio/transport/t2_2_s1.mp3', speaker: '乘客', wordBreakdown: [
            WordBreakdown(cantonese: '街口', jyutping: 'gaai1 hau2', mandarin: '街口/路口', literal: '街口'),
          ]),
          Sentence(id: 't2_2_s2', cantonese: '收到。落車小心呀。', jyutping: 'sau1 dou2. lok6 ce1 siu2 sam1 aa3.', mandarin: '收到。下车小心。', audioPath: 'assets/audio/transport/t2_2_s2.mp3', speaker: '司机'),
          Sentence(id: 't2_2_s3', cantonese: '幾多錢呀？', jyutping: 'gei2 do1 cin2 aa3?', mandarin: '多少钱？', audioPath: 'assets/audio/transport/t2_2_s3.mp3', speaker: '乘客'),
          Sentence(id: 't2_2_s4', cantonese: '八個半，唔該。', jyutping: 'baat3 go3 bun3, m4 goi1.', mandarin: '八块五，谢谢。', audioPath: 'assets/audio/transport/t2_2_s4.mp3', speaker: '司机', wordBreakdown: [
            WordBreakdown(cantonese: '八個半', jyutping: 'baat3 go3 bun3', mandarin: '八块五', literal: '八个半→八块五'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_t2_1', sceneId: 'transport_2', cantonese: '有落', jyutping: 'jau5 lok6', mandarin: '要下车', partOfSpeech: '动词短语', audioPath: 'assets/audio/transport/v_t2_1.mp3'),
        VocabItem(id: 'v_t2_2', sceneId: 'transport_2', cantonese: '街口', jyutping: 'gaai1 hau2', mandarin: '路口', partOfSpeech: '名词', audioPath: 'assets/audio/transport/v_t2_2.mp3'),
        VocabItem(id: 'v_t2_3', sceneId: 'transport_2', cantonese: '落車', jyutping: 'lok6 ce1', mandarin: '下车', partOfSpeech: '动词', audioPath: 'assets/audio/transport/v_t2_3.mp3'),
        VocabItem(id: 'v_t2_4', sceneId: 'transport_2', cantonese: '幾個半', jyutping: 'gei2 go3 bun3', mandarin: '几块五毛', partOfSpeech: '量词短语', audioPath: 'assets/audio/transport/v_t2_4.mp3'),
        VocabItem(id: 'v_t2_5', sceneId: 'transport_2', cantonese: '小心', jyutping: 'siu2 sam1', mandarin: '小心', partOfSpeech: '形容词', audioPath: 'assets/audio/transport/v_t2_5.mp3'),
      ],
    ),
    Scene(
      id: 'transport_3',
      categoryId: 'transport',
      title: '搭的士',
      subtitle: '学会在香港搭的士去目的地',
      dialogues: [
        Dialogue(id: 't3_1', title: '搭的士', sentences: [
          Sentence(id: 't3_1_s1', cantonese: '司機，去中環IFC唔該。', jyutping: 'si1 gei1, heoi3 zung1 waan4 IFC m4 goi1.', mandarin: '司机，去中环IFC谢谢。', audioPath: 'assets/audio/transport/t3_1_s1.mp3', speaker: '乘客'),
          Sentence(id: 't3_1_s2', cantonese: '好，過海定行紅隧？', jyutping: 'hou2, gwo3 hoi2 ding6 haang4 hung4 seoi6?', mandarin: '好的，过海还是走红隧？', audioPath: 'assets/audio/transport/t3_1_s2.mp3', speaker: '司机', wordBreakdown: [
            WordBreakdown(cantonese: '過海', jyutping: 'gwo3 hoi2', mandarin: '过海(过维多利亚港)', literal: '过海'),
            WordBreakdown(cantonese: '紅隧', jyutping: 'hung4 seoi6', mandarin: '红磡海底隧道', literal: '红隧'),
          ]),
          Sentence(id: 't3_1_s3', cantonese: '紅隧啦，快啲。', jyutping: 'hung4 seoi6 laa1, faai3 di1.', mandarin: '走红隧吧，快一点。', audioPath: 'assets/audio/transport/t3_1_s3.mp3', speaker: '乘客'),
          Sentence(id: 't3_1_s4', cantonese: '唔該喺呢度停得喇。幾多錢？', jyutping: 'm4 goi1 hai2 ni1 dou6 ting4 dak1 laa3. gei2 do1 cin2?', mandarin: '麻烦在这里停就可以了。多少钱？', audioPath: 'assets/audio/transport/t3_1_s4.mp3', speaker: '乘客', wordBreakdown: [
            WordBreakdown(cantonese: '喺', jyutping: 'hai2', mandarin: '在', literal: '喺→在'),
            WordBreakdown(cantonese: '停得喇', jyutping: 'ting4 dak1 laa3', mandarin: '可以停了', literal: '停得了'),
          ]),
          Sentence(id: 't3_1_s5', cantonese: '八十六蚊吖。有冇散紙？', jyutping: 'baat3 sap6 luk6 man1 aa1. jau5 mou5 saan2 zi2?', mandarin: '八十六块。有零钱吗？', audioPath: 'assets/audio/transport/t3_1_s5.mp3', speaker: '司机', wordBreakdown: [
            WordBreakdown(cantonese: '散紙', jyutping: 'saan2 zi2', mandarin: '零钱', literal: '散纸→零钱'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_t3_1', sceneId: 'transport_3', cantonese: '過海', jyutping: 'gwo3 hoi2', mandarin: '过海(跨维多利亚港)', partOfSpeech: '动词', audioPath: 'assets/audio/transport/v_t3_1.mp3'),
        VocabItem(id: 'v_t3_2', sceneId: 'transport_3', cantonese: '紅隧', jyutping: 'hung4 seoi6', mandarin: '红磡海底隧道', partOfSpeech: '名词', audioPath: 'assets/audio/transport/v_t3_2.mp3'),
        VocabItem(id: 'v_t3_3', sceneId: 'transport_3', cantonese: '喺', jyutping: 'hai2', mandarin: '在', partOfSpeech: '介词', audioPath: 'assets/audio/transport/v_t3_3.mp3', exampleCantonese: '喺邊度？', exampleMandarin: '在哪里？'),
        VocabItem(id: 'v_t3_4', sceneId: 'transport_3', cantonese: '散紙', jyutping: 'saan2 zi2', mandarin: '零钱', partOfSpeech: '名词', audioPath: 'assets/audio/transport/v_t3_4.mp3'),
        VocabItem(id: 'v_t3_5', sceneId: 'transport_3', cantonese: '快啲', jyutping: 'faai3 di1', mandarin: '快一点', partOfSpeech: '副词短语', audioPath: 'assets/audio/transport/v_t3_5.mp3'),
      ],
    ),

    // ========================
    // 🛒 购物篇
    // ========================
    Scene(
      id: 'shopping_1',
      categoryId: 'shopping',
      title: '超市购物',
      subtitle: '学会在香港超市购物和付款',
      dialogues: [
        Dialogue(id: 's1_1', title: '超市付款', sentences: [
          Sentence(id: 's1_1_s1', cantonese: '唔該，有冇會員卡呀？', jyutping: 'm4 goi1, jau5 mou5 wui2 jyun4 kaat1 aa3?', mandarin: '请问，有会员卡吗？', audioPath: 'assets/audio/shopping/s1_1_s1.mp3', speaker: '收银员'),
          Sentence(id: 's1_1_s2', cantonese: '冇呀。使唔使膠袋？', jyutping: 'mou5 aa3. sai2 m4 sai2 gaau1 doi2?', mandarin: '没有。需要塑料袋吗？', audioPath: 'assets/audio/shopping/s1_1_s2.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '膠袋', jyutping: 'gaau1 doi2', mandarin: '塑料袋', literal: '胶袋'),
          ]),
          Sentence(id: 's1_1_s3', cantonese: '要吖。幾多錢？', jyutping: 'jiu3 aa1. gei2 do1 cin2?', mandarin: '要的。多少钱？', audioPath: 'assets/audio/shopping/s1_1_s3.mp3', speaker: '顾客'),
          Sentence(id: 's1_1_s4', cantonese: '膠袋五毫子。一共一百二十三蚊。', jyutping: 'gaau1 doi2 ng5 hou4 zi2. jat1 gung2 jat1 baak3 ji6 sap6 saam1 man1.', mandarin: '塑料袋五毛钱。一共一百二十三块。', audioPath: 'assets/audio/shopping/s1_1_s4.mp3', speaker: '收银员', wordBreakdown: [
            WordBreakdown(cantonese: '毫子', jyutping: 'hou4 zi2', mandarin: '毛/角', literal: '毫子→毛'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_s1_1', sceneId: 'shopping_1', cantonese: '會員卡', jyutping: 'wui2 jyun4 kaat1', mandarin: '会员卡', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s1_1.mp3'),
        VocabItem(id: 'v_s1_2', sceneId: 'shopping_1', cantonese: '膠袋', jyutping: 'gaau1 doi2', mandarin: '塑料袋', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s1_2.mp3'),
        VocabItem(id: 'v_s1_3', sceneId: 'shopping_1', cantonese: '毫子', jyutping: 'hou4 zi2', mandarin: '角/毛(钱)', partOfSpeech: '量词', audioPath: 'assets/audio/shopping/v_s1_3.mp3'),
        VocabItem(id: 'v_s1_4', sceneId: 'shopping_1', cantonese: '有冇', jyutping: 'jau5 mou5', mandarin: '有没有', partOfSpeech: '疑问短语', audioPath: 'assets/audio/shopping/v_s1_4.mp3'),
        VocabItem(id: 'v_s1_5', sceneId: 'shopping_1', cantonese: '買二送一', jyutping: 'maai5 ji6 sung3 jat1', mandarin: '买二送一', partOfSpeech: '短语', audioPath: 'assets/audio/shopping/v_s1_5.mp3'),
      ],
    ),
    Scene(
      id: 'shopping_2',
      categoryId: 'shopping',
      title: '商场买衫',
      subtitle: '学会在香港商场买衣服试穿',
      dialogues: [
        Dialogue(id: 's2_1', title: '试衫买衫', sentences: [
          Sentence(id: 's2_1_s1', cantonese: '呢件衫有冇大碼呀？', jyutping: 'ni1 gin6 saam1 jau5 mou5 daai6 maa5 aa3?', mandarin: '这件衣服有大码吗？', audioPath: 'assets/audio/shopping/s2_1_s1.mp3', speaker: '顾客'),
          Sentence(id: 's2_1_s2', cantonese: '有，試身室喺嗰邊。', jyutping: 'jau5, si3 san1 sat1 hai2 go2 bin1.', mandarin: '有，试衣间在那边。', audioPath: 'assets/audio/shopping/s2_1_s2.mp3', speaker: '店员', wordBreakdown: [
            WordBreakdown(cantonese: '試身室', jyutping: 'si3 san1 sat1', mandarin: '试衣间', literal: '试身室'),
            WordBreakdown(cantonese: '嗰邊', jyutping: 'go2 bin1', mandarin: '那边', literal: '那边'),
          ]),
          Sentence(id: 's2_1_s3', cantonese: '而家有幾多折呀？', jyutping: 'ji4 gaa1 jau5 gei2 do1 zit3 aa3?', mandarin: '现在打几折？', audioPath: 'assets/audio/shopping/s2_1_s3.mp3', speaker: '顾客', wordBreakdown: [
            WordBreakdown(cantonese: '而家', jyutping: 'ji4 gaa1', mandarin: '现在', literal: '而家→现在'),
            WordBreakdown(cantonese: '折', jyutping: 'zit3', mandarin: '折扣', literal: '折'),
          ]),
          Sentence(id: 's2_1_s4', cantonese: '而家做緊七折，好抵㗎！', jyutping: 'ji4 gaa1 zou6 gan2 cat1 zit3, hou2 dai2 gaa3!', mandarin: '现在打七折，很划算的！', audioPath: 'assets/audio/shopping/s2_1_s4.mp3', speaker: '店员', wordBreakdown: [
            WordBreakdown(cantonese: '做緊', jyutping: 'zou6 gan2', mandarin: '在做(进行中)', literal: '做紧→正在做'),
            WordBreakdown(cantonese: '好抵', jyutping: 'hou2 dai2', mandarin: '很划算', literal: '很抵→很值'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_s2_1', sceneId: 'shopping_2', cantonese: '大碼', jyutping: 'daai6 maa5', mandarin: '大码', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s2_1.mp3'),
        VocabItem(id: 'v_s2_2', sceneId: 'shopping_2', cantonese: '試身室', jyutping: 'si3 san1 sat1', mandarin: '试衣间', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s2_2.mp3'),
        VocabItem(id: 'v_s2_3', sceneId: 'shopping_2', cantonese: '嗰邊', jyutping: 'go2 bin1', mandarin: '那边', partOfSpeech: '代词', audioPath: 'assets/audio/shopping/v_s2_3.mp3'),
        VocabItem(id: 'v_s2_4', sceneId: 'shopping_2', cantonese: '而家', jyutping: 'ji4 gaa1', mandarin: '现在', partOfSpeech: '时间词', audioPath: 'assets/audio/shopping/v_s2_4.mp3'),
        VocabItem(id: 'v_s2_5', sceneId: 'shopping_2', cantonese: '好抵', jyutping: 'hou2 dai2', mandarin: '很划算', partOfSpeech: '形容词短语', audioPath: 'assets/audio/shopping/v_s2_5.mp3'),
        VocabItem(id: 'v_s2_6', sceneId: 'shopping_2', cantonese: '做緊', jyutping: 'zou6 gan2', mandarin: '正在做', partOfSpeech: '动词(进行态)', audioPath: 'assets/audio/shopping/v_s2_6.mp3'),
        VocabItem(id: 'v_s2_7', sceneId: 'shopping_2', cantonese: '件', jyutping: 'gin6', mandarin: '件(衣服量词)', partOfSpeech: '量词', audioPath: 'assets/audio/shopping/v_s2_7.mp3'),
      ],
      grammarNotes: [
        GrammarNote(title: '「緊」= 正在(进行态)', explanation: '粤语在动词后加「緊」表示正在进行，等同于普通话的"正在/着"。食緊=正在吃。', cantoneseExample: '做緊嘢 = 正在工作', mandarinExample: '正在工作'),
      ],
    ),
    Scene(
      id: 'shopping_3',
      categoryId: 'shopping',
      title: '药房买药',
      subtitle: '学会在香港药房买日常药品',
      dialogues: [
        Dialogue(id: 's3_1', title: '买药', sentences: [
          Sentence(id: 's3_1_s1', cantonese: '唔該，有冇傷風感冒藥？', jyutping: 'm4 goi1, jau5 mou5 soeng1 fung1 gam2 mou6 joek6?', mandarin: '麻烦，有没有伤风感冒药？', audioPath: 'assets/audio/shopping/s3_1_s1.mp3', speaker: '顾客'),
          Sentence(id: 's3_1_s2', cantonese: '有，想要藥丸定藥水？', jyutping: 'jau5, soeng2 jiu3 joek6 jyun2 ding6 joek6 seoi2?', mandarin: '有，想要药丸还是药水？', audioPath: 'assets/audio/shopping/s3_1_s2.mp3', speaker: '药剂师'),
          Sentence(id: 's3_1_s3', cantonese: '藥丸啦。一日食幾多次？', jyutping: 'joek6 jyun2 laa1. jat1 jat6 sik6 gei2 do1 ci3?', mandarin: '药丸吧。一天吃多少次？', audioPath: 'assets/audio/shopping/s3_1_s3.mp3', speaker: '顾客'),
          Sentence(id: 's3_1_s4', cantonese: '一日三次，每次兩粒，飽肚食。', jyutping: 'jat1 jat6 saam1 ci3, mui5 ci3 loeng5 lap1, baau2 tou5 sik6.', mandarin: '一天三次，每次两粒，饭后吃。', audioPath: 'assets/audio/shopping/s3_1_s4.mp3', speaker: '药剂师', wordBreakdown: [
            WordBreakdown(cantonese: '粒', jyutping: 'lap1', mandarin: '粒/颗(药量词)', literal: '粒'),
            WordBreakdown(cantonese: '飽肚', jyutping: 'baau2 tou5', mandarin: '饭后(饱肚)', literal: '饱肚→饭后'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_s3_1', sceneId: 'shopping_3', cantonese: '傷風感冒', jyutping: 'soeng1 fung1 gam2 mou6', mandarin: '伤风感冒', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s3_1.mp3'),
        VocabItem(id: 'v_s3_2', sceneId: 'shopping_3', cantonese: '藥丸', jyutping: 'joek6 jyun2', mandarin: '药丸', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s3_2.mp3'),
        VocabItem(id: 'v_s3_3', sceneId: 'shopping_3', cantonese: '藥水', jyutping: 'joek6 seoi2', mandarin: '药水', partOfSpeech: '名词', audioPath: 'assets/audio/shopping/v_s3_3.mp3'),
        VocabItem(id: 'v_s3_4', sceneId: 'shopping_3', cantonese: '粒', jyutping: 'lap1', mandarin: '粒/颗', partOfSpeech: '量词', audioPath: 'assets/audio/shopping/v_s3_4.mp3'),
        VocabItem(id: 'v_s3_5', sceneId: 'shopping_3', cantonese: '飽肚', jyutping: 'baau2 tou5', mandarin: '饭后', partOfSpeech: '副词', audioPath: 'assets/audio/shopping/v_s3_5.mp3'),
      ],
    ),

    // ========================
    // 💼 职场篇
    // ========================
    Scene(
      id: 'workplace_1',
      categoryId: 'workplace',
      title: '自我介绍',
      subtitle: '学会在职场中用粤语自我介绍',
      dialogues: [
        Dialogue(id: 'w1_1', title: '初次见面', sentences: [
          Sentence(id: 'w1_1_s1', cantonese: '你好，我係陳大明，叫我阿明得喇。', jyutping: 'nei5 hou2, ngo5 hai6 can4 daai6 ming4, giu3 ngo5 aa3 ming4 dak1 laa3.', mandarin: '你好，我是陈大明，叫我阿明就可以了。', audioPath: 'assets/audio/workplace/w1_1_s1.mp3', speaker: '新人', wordBreakdown: [
            WordBreakdown(cantonese: '我係', jyutping: 'ngo5 hai6', mandarin: '我是', literal: '我係→我是'),
            WordBreakdown(cantonese: '得喇', jyutping: 'dak1 laa3', mandarin: '就行了', literal: '得了→行了'),
          ]),
          Sentence(id: 'w1_1_s2', cantonese: '阿明你好！我係李經理。你邊度做嘢㗎？', jyutping: 'aa3 ming4 nei5 hou2! ngo5 hai6 lei5 ging1 lei5. nei5 bin1 dou6 zou6 je5 gaa3?', mandarin: '阿明你好！我是李经理。你在哪里工作的？', audioPath: 'assets/audio/workplace/w1_1_s2.mp3', speaker: '经理', wordBreakdown: [
            WordBreakdown(cantonese: '邊度', jyutping: 'bin1 dou6', mandarin: '哪里', literal: '边度→哪里'),
            WordBreakdown(cantonese: '做嘢', jyutping: 'zou6 je5', mandarin: '工作', literal: '做野→做事→工作'),
          ]),
          Sentence(id: 'w1_1_s3', cantonese: '我喺中環返工，做市場推廣嘅。', jyutping: 'ngo5 hai2 zung1 waan4 faan2 gung1, zou6 si5 coeng4 teoi1 gwong2 ge3.', mandarin: '我在中环上班，做市场推广的。', audioPath: 'assets/audio/workplace/w1_1_s3.mp3', speaker: '新人', wordBreakdown: [
            WordBreakdown(cantonese: '返工', jyutping: 'faan2 gung1', mandarin: '上班', literal: '返工→上班'),
            WordBreakdown(cantonese: '市場推廣', jyutping: 'si5 coeng4 teoi1 gwong2', mandarin: '市场推广', literal: '市场推广'),
          ]),
          Sentence(id: 'w1_1_s4', cantonese: '好呀，以後多多指教。', jyutping: 'hou2 aa3, ji5 hau6 do1 do1 zi2 gaau3.', mandarin: '好啊，以后多多指教。', audioPath: 'assets/audio/workplace/w1_1_s4.mp3', speaker: '经理', wordBreakdown: [
            WordBreakdown(cantonese: '以後', jyutping: 'ji5 hau6', mandarin: '以后', literal: '以后'),
            WordBreakdown(cantonese: '多多指教', jyutping: 'do1 do1 zi2 gaau3', mandarin: '多多指教', literal: '多多指教'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_w1_1', sceneId: 'workplace_1', cantonese: '我係', jyutping: 'ngo5 hai6', mandarin: '我是', partOfSpeech: '代词+动词', audioPath: 'assets/audio/workplace/v_w1_1.mp3'),
        VocabItem(id: 'v_w1_2', sceneId: 'workplace_1', cantonese: '邊度', jyutping: 'bin1 dou6', mandarin: '哪里', partOfSpeech: '疑问词', audioPath: 'assets/audio/workplace/v_w1_2.mp3'),
        VocabItem(id: 'v_w1_3', sceneId: 'workplace_1', cantonese: '做嘢', jyutping: 'zou6 je5', mandarin: '工作/做事', partOfSpeech: '动词', audioPath: 'assets/audio/workplace/v_w1_3.mp3'),
        VocabItem(id: 'v_w1_4', sceneId: 'workplace_1', cantonese: '返工', jyutping: 'faan2 gung1', mandarin: '上班', partOfSpeech: '动词', audioPath: 'assets/audio/workplace/v_w1_4.mp3', exampleCantonese: '聽朝返工', exampleMandarin: '明天早上上班'),
        VocabItem(id: 'v_w1_5', sceneId: 'workplace_1', cantonese: '多多指教', jyutping: 'do1 do1 zi2 gaau3', mandarin: '多多指教/请多关照', partOfSpeech: '习惯用语', audioPath: 'assets/audio/workplace/v_w1_5.mp3'),
        VocabItem(id: 'v_w1_6', sceneId: 'workplace_1', cantonese: '得喇', jyutping: 'dak1 laa3', mandarin: '行了/可以了', partOfSpeech: '语气词', audioPath: 'assets/audio/workplace/v_w1_6.mp3'),
      ],
    ),
    Scene(
      id: 'workplace_2',
      categoryId: 'workplace',
      title: '开会讨论',
      subtitle: '学会在会议上用粤语表达意见',
      dialogues: [
        Dialogue(id: 'w2_1', title: '会议发言', sentences: [
          Sentence(id: 'w2_1_s1', cantonese: '我認為呢個方案可以試下。', jyutping: 'ngo5 jing6 wai4 ni1 go3 fong1 on3 ho2 ji5 si3 haa5.', mandarin: '我认为这个方案可以试试。', audioPath: 'assets/audio/workplace/w2_1_s1.mp3', speaker: '同事'),
          Sentence(id: 'w2_1_s2', cantonese: '不如我哋再傾傾先決定？', jyutping: 'bat1 jyu4 ngo5 dei6 zoi3 king1 king1 sin1 kyut3 ding6?', mandarin: '不如我们再讨论讨论再决定？', audioPath: 'assets/audio/workplace/w2_1_s2.mp3', speaker: '同事', wordBreakdown: [
            WordBreakdown(cantonese: '不如', jyutping: 'bat1 jyu4', mandarin: '不如', literal: '不如'),
            WordBreakdown(cantonese: '我哋', jyutping: 'ngo5 dei6', mandarin: '我们', literal: '我哋→我们'),
            WordBreakdown(cantonese: '傾傾', jyutping: 'king1 king1', mandarin: '聊聊/讨论', literal: '倾倾→聊聊'),
          ]),
          Sentence(id: 'w2_1_s3', cantonese: '有冇問題想提出㗎？', jyutping: 'jau5 mou5 man6 tai4 soeng2 tai4 ceot1 gaa3?', mandarin: '有没有问题要提出？', audioPath: 'assets/audio/workplace/w2_1_s3.mp3', speaker: '主管'),
          Sentence(id: 'w2_1_s4', cantonese: '大致上冇問題，可以開始做㗎喇。', jyutping: 'daai6 zi3 soeng6 mou5 man6 tai4, ho2 ji5 hoi1 ci2 zou6 gaa3 laa3.', mandarin: '大体上没问题，可以开始做了。', audioPath: 'assets/audio/workplace/w2_1_s4.mp3', speaker: '主管', wordBreakdown: [
            WordBreakdown(cantonese: '大致上', jyutping: 'daai6 zi3 soeng6', mandarin: '大体上', literal: '大致上'),
          ]),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_w2_1', sceneId: 'workplace_2', cantonese: '我認為', jyutping: 'ngo5 jing6 wai4', mandarin: '我认为', partOfSpeech: '短语', audioPath: 'assets/audio/workplace/v_w2_1.mp3'),
        VocabItem(id: 'v_w2_2', sceneId: 'workplace_2', cantonese: '不如', jyutping: 'bat1 jyu4', mandarin: '不如', partOfSpeech: '连词', audioPath: 'assets/audio/workplace/v_w2_2.mp3'),
        VocabItem(id: 'v_w2_3', sceneId: 'workplace_2', cantonese: '我哋', jyutping: 'ngo5 dei6', mandarin: '我们', partOfSpeech: '代词', audioPath: 'assets/audio/workplace/v_w2_3.mp3'),
        VocabItem(id: 'v_w2_4', sceneId: 'workplace_2', cantonese: '傾', jyutping: 'king1', mandarin: '聊/讨论', partOfSpeech: '动词', audioPath: 'assets/audio/workplace/v_w2_4.mp3', exampleCantonese: '傾偈', exampleMandarin: '聊天'),
        VocabItem(id: 'v_w2_5', sceneId: 'workplace_2', cantonese: '大致上', jyutping: 'daai6 zi3 soeng6', mandarin: '大体上', partOfSpeech: '副词', audioPath: 'assets/audio/workplace/v_w2_5.mp3'),
        VocabItem(id: 'v_w2_6', sceneId: 'workplace_2', cantonese: '試下', jyutping: 'si3 haa5', mandarin: '试试', partOfSpeech: '动词短语', audioPath: 'assets/audio/workplace/v_w2_6.mp3'),
      ],
      grammarNotes: [
        GrammarNote(title: '「哋」= 们', explanation: '粤语在代词后加「哋」表示复数。我哋=我们，你哋=你们，佢哋=他们。', cantoneseExample: '我哋一齊去', mandarinExample: '我们一起去'),
        GrammarNote(title: '「下」= 一下', explanation: '粤语在动词后加「下」表示尝试或短时间，等同于普通话的"一下"。', cantoneseExample: '試下、睇下、聽下', mandarinExample: '试试、看看、听听'),
      ],
    ),
    Scene(
      id: 'workplace_3',
      categoryId: 'workplace',
      title: '电话沟通',
      subtitle: '学会在香港用粤语打工作电话',
      dialogues: [
        Dialogue(id: 'w3_1', title: '接打电话', sentences: [
          Sentence(id: 'w3_1_s1', cantonese: '喂，請問係咪張生呀？', jyutping: 'wai2, cing2 man6 hai6 mai6 zoeng1 saang1 aa3?', mandarin: '喂，请问是张先生吗？', audioPath: 'assets/audio/workplace/w3_1_s1.mp3', speaker: '来电者', wordBreakdown: [
            WordBreakdown(cantonese: '係咪', jyutping: 'hai6 mai6', mandarin: '是不是', literal: '是不是'),
            WordBreakdown(cantonese: '張生', jyutping: 'zoeng1 saang1', mandarin: '张先生', literal: '张生→张先生'),
          ]),
          Sentence(id: 'w3_1_s2', cantonese: '佢而家唔喺度喎，你留個口訊好唔好？', jyutping: 'keoi5 ji4 gaa1 m4 hai2 dou6 wo3, nei5 lau4 go3 hau2 seon3 hou2 m4 hou2?', mandarin: '他现在不在哦，你留个口信好吗？', audioPath: 'assets/audio/workplace/w3_1_s2.mp3', speaker: '同事', wordBreakdown: [
            WordBreakdown(cantonese: '佢', jyutping: 'keoi5', mandarin: '他/她', literal: '佢→他'),
            WordBreakdown(cantonese: '唔喺度', jyutping: 'm4 hai2 dou6', mandarin: '不在', literal: '不在'),
            WordBreakdown(cantonese: '口訊', jyutping: 'hau2 seon3', mandarin: '口信', literal: '口讯→口信'),
          ]),
          Sentence(id: 'w3_1_s3', cantonese: '好呀，麻煩叫佢轉頭打返俾我吖。', jyutping: 'hou2 aa3, maa4 faan4 giu3 keoi5 zyun3 tau4 daa2 faan1 bei2 ngo5 aa1.', mandarin: '好呀，麻烦叫他回头打给我。', audioPath: 'assets/audio/workplace/w3_1_s3.mp3', speaker: '来电者', wordBreakdown: [
            WordBreakdown(cantonese: '打返', jyutping: 'daa2 faan1', mandarin: '回电话', literal: '打返→打回'),
          ]),
          Sentence(id: 'w3_1_s4', cantonese: '一定。拜拜！', jyutping: 'jat1 ding6. baai1 baai3!', mandarin: '一定。再见！', audioPath: 'assets/audio/workplace/w3_1_s4.mp3', speaker: '同事'),
        ]),
      ],
      vocabulary: [
        VocabItem(id: 'v_w3_1', sceneId: 'workplace_3', cantonese: '係咪', jyutping: 'hai6 mai6', mandarin: '是不是', partOfSpeech: '疑问词', audioPath: 'assets/audio/workplace/v_w3_1.mp3'),
        VocabItem(id: 'v_w3_2', sceneId: 'workplace_3', cantonese: '佢', jyutping: 'keoi5', mandarin: '他/她', partOfSpeech: '代词', audioPath: 'assets/audio/workplace/v_w3_2.mp3'),
        VocabItem(id: 'v_w3_3', sceneId: 'workplace_3', cantonese: '唔喺度', jyutping: 'm4 hai2 dou6', mandarin: '不在', partOfSpeech: '短语', audioPath: 'assets/audio/workplace/v_w3_3.mp3'),
        VocabItem(id: 'v_w3_4', sceneId: 'workplace_3', cantonese: '口訊', jyutping: 'hau2 seon3', mandarin: '口信', partOfSpeech: '名词', audioPath: 'assets/audio/workplace/v_w3_4.mp3'),
        VocabItem(id: 'v_w3_5', sceneId: 'workplace_3', cantonese: '打返', jyutping: 'daa2 faan1', mandarin: '回拨/回电话', partOfSpeech: '动词短语', audioPath: 'assets/audio/workplace/v_w3_5.mp3'),
        VocabItem(id: 'v_w3_6', sceneId: 'workplace_3', cantonese: '轉頭', jyutping: 'zyun3 tau4', mandarin: '回头/过一会', partOfSpeech: '副词', audioPath: 'assets/audio/workplace/v_w3_6.mp3'),
        VocabItem(id: 'v_w3_7', sceneId: 'workplace_3', cantonese: '張生', jyutping: 'zoeng1 saang1', mandarin: '张先生', partOfSpeech: '称呼', audioPath: 'assets/audio/workplace/v_w3_7.mp3'),
      ],
    ),
  ];
}
