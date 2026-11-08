import 'package:boobe/app.dart';
import 'package:boobe/data/local_store.dart';
import 'package:boobe/data/models.dart';
import 'package:boobe/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Full Boobe journey and screen capture', (tester) async {
    final state = AppState(LocalStore());
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      BoobeApp(state: state, initialRoute: '/intro', navigatorKey: nav),
    );
    await binding.convertFlutterSurfaceToImage();
    Future<void> shot(String name) async {
      ScaffoldMessenger.of(nav.currentContext!).removeCurrentSnackBar();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    Future<void> route(String path, String name, [Object? args]) async {
      nav.currentState!.pushNamedAndRemoveUntil(
        path,
        (_) => false,
        arguments: args,
      );
      await shot(name);
    }

    Future<void> tap(String text) async {
      await tester.tap(find.text(text).last);
      await tester.pumpAndSettle();
    }

    await shot('01_intro_discover');
    await tap('Next');
    await shot('02_intro_chat');
    await tap('Start');
    await shot('03_welcome');
    await tap('Login by mail');
    await shot('04_login');
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'tonyst@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'boobe123');
    await tap('Login');
    expect(find.byTooltip('Discover'), findsOneWidget);
    await shot('05_discover');
    await tester.tap(find.byTooltip('Skip'));
    await tester.pumpAndSettle();
    expect(state.cardIndex, 1);
    state.undo();
    await tester.pumpAndSettle();
    expect(state.cardIndex, 0);
    await tester.tap(find.byTooltip('Super like'));
    await shot('06_super_like');
    await tap('Yeah, got it!');
    await tester.tap(find.byTooltip('Like'));
    await shot('07_match');
    await tap('Say Hi to Wesley <3');
    await shot('08_chat_empty');
    await tester.enterText(
      find.byType(TextField),
      'Hi Wesley! Coffee tomorrow at 1pm?',
    );
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(
      state.conversations[people.first.name]!.single.text,
      contains('Coffee'),
    );
    state.update(
      () => state.conversations[people.first.name]!.insert(
        0,
        const ChatMessage('Hi Tony! Nice to meet you.', mine: false),
      ),
    );
    await shot('09_chat_messages');
    await tester.tap(find.byTooltip('Attach photo'));
    await shot('10_chat_attachment');
    await tester.tap(find.byType(InkWell).last);
    await shot('11_chat_photo');
    await tester.tap(find.byTooltip('Conversation options'));
    await shot('12_chat_options');
    await route('/person', '13_profile_details');
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -650),
    );
    await shot('14_profile_details_scroll');
    await route('/person', '15_male_profile', self);
    await route('/picture', '16_picture');
    await route('/searching', '17_searching');
    state.update(() {
      state.tab = 3;
      state.signedIn = true;
    });
    await route('/home', '18_messages');
    await tester.enterText(find.byType(TextField).first, 'Taylor');
    await shot('19_message_search');
    state.update(() => state.tab = 2, persist: false);
    await route('/home', '20_gold_locked');
    await tap('Upgrade to Gold User');
    await shot('21_gold_sheet');
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await shot('22_gold_plans');
    await tap(plansForTest[1]);
    await tap('Continue');
    await shot('23_payment');
    await tester.ensureVisible(find.text('Accept · Demo payment'));
    await tap('Accept · Demo payment');
    expect(state.gold, true);
    await shot('24_gold_unlocked');
    await tap('Top selection');
    await shot('25_top_selection');
    state.update(() => state.tab = 0, persist: false);
    await route('/home', '26_user');
    for (int i = 1; i < 5; i++) {
      await tester.drag(find.byType(PageView), const Offset(-320, 0));
      await shot('26_user_benefit_$i');
    }
    await route('/account', '27_account');
    await route('/settings', '28_settings');
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await shot('29_settings_scroll');
    await route('/notifications', '30_notifications');
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();
    expect(state.notifications['New match'], false);
    await route('/edit', '31_edit_profile');
    await tester.enterText(find.byType(TextFormField).first, 'Tony Stark');
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1500),
    );
    await shot('32_edit_profile_scroll');
    await route('/soundtrack', '33_soundtracks');
    await tester.enterText(find.byType(TextField), 'I Want You');
    await shot('34_soundtrack_search');
    await tap('I Want You To Know');
    expect(state.songIndex, 5);
    await shot('35_soundtrack_added');
    await route('/delete', '36_delete_account');
    await route('/join', '37_join');
    await tap('Next');
    await shot('38_register_personal');
    await tap('♀ Female');
    await shot('39_register_female');
    await tap('Next');
    await shot('40_register_place');
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('Amsterdam'), findsOneWidget);
    await tap('Next');
    await shot('41_register_hobby');
    await tap('Next');
    await shot('42_register_account');
    await tester.enterText(find.byType(TextFormField).at(1), 'boobe123');
    await tester.enterText(find.byType(TextFormField).at(2), 'boobe123');
    await tap('Next');
    await shot('43_register_finish');
    await tap('Success');
    await route('/legal', '44_help', 'Help');
    await route('/legal', '45_privacy', 'Privacy Policy');
    state.update(() {
      state.tab = 1;
      state.gender = 'Male';
      state.cardIndex = 0;
      state.onboarded = true;
      state.signedIn = true;
    });
    await state.flush();
    final restored = AppState(LocalStore());
    await restored.restore();
    expect(restored.songIndex, 5);
    expect(restored.conversations[people.first.name]!.length, 3);
    expect(restored.notifications['New match'], false);
    await route('/home', '46_discover_final');
  });
}

const plansForTest = [
  '3 months (\$15 for each month)',
  '6 months (\$12 for each month)',
  '12 months (\$10 for each month)',
];
