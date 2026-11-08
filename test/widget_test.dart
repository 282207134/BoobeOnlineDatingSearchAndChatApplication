import 'package:boobe/app.dart';
import 'package:boobe/data/local_store.dart';
import 'package:boobe/data/models.dart';
import 'package:boobe/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryStore extends LocalStore {
  Map<String, dynamic> data = {};
  @override
  Future<Map<String, dynamic>> read() async => data;
  @override
  Future<void> write(Map<String, dynamic> value) async {
    data = value;
  }
}

void main() {
  test('Profile, preferences and messages survive a restart', () async {
    final store = MemoryStore(), s = AppState(MemoryStore());
    final state = AppState(store);
    state.update(() {
      state.name = 'Alex';
      state.distance = 42;
      state.gold = true;
      state.songIndex = 2;
      state.phone = '123456';
      state.photoNames.removeLast();
    });
    state.send(people.first, 'Hello Wesley');
    state.send(people.first, 'person_0', image: true);
    state.swipe(like: true);
    await state.flush();
    final restored = AppState(store);
    await restored.restore();
    expect(restored.name, 'Alex');
    expect(restored.distance, 42);
    expect(restored.gold, true);
    expect(restored.songIndex, 2);
    expect(restored.photoNames.length, 3);
    expect(restored.liked, contains('Wesley Gome'));
    expect(restored.conversations['Wesley Gome']!.length, 2);
    expect(restored.conversations['Wesley Gome']!.last.image, true);
    s.send(people.first, '   ');
    expect(s.conversations, isEmpty);
    state.undo();
    expect(state.cardIndex, 0);
    await state.deleteLocalAccount();
    final reset = AppState(store);
    await reset.restore();
    expect(reset.phone, isEmpty);
    expect(reset.conversations, isEmpty);
    expect(reset.gold, false);
    expect(reset.photoNames.length, 4);
  });
  for (final size in [const Size(375, 812), const Size(320, 640)]) {
    testWidgets('Every route lays out at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final state = AppState(MemoryStore()), nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        BoobeApp(state: state, initialRoute: '/home', navigatorKey: nav),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 4; i++) {
        state.update(() => state.tab = i, persist: false);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'tab $i');
      }
      for (final route in [
        '/intro',
        '/welcome',
        '/login',
        '/join',
        '/person',
        '/picture',
        '/match',
        '/searching',
        '/conversation',
        '/conversation/options',
        '/payment',
        '/account',
        '/edit',
        '/settings',
        '/notifications',
        '/delete',
        '/soundtrack',
        '/legal',
      ]) {
        nav.currentState!.pushNamed(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
        nav.currentState!.pop();
        await tester.pumpAndSettle();
      }
    });
  }
  testWidgets('Chat sends and persists a typed message', (tester) async {
    final state = AppState(MemoryStore());
    await tester.pumpWidget(
      BoobeApp(state: state, initialRoute: '/conversation'),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Meet at 1pm?');
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(find.text('Meet at 1pm?'), findsOneWidget);
    expect(state.conversations[people.first.name]!.single.text, 'Meet at 1pm?');
  });
  testWidgets('Profile editor saves changed data', (tester) async {
    final state = AppState(MemoryStore()), nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      BoobeApp(state: state, initialRoute: '/home', navigatorKey: nav),
    );
    nav.currentState!.pushNamed('/edit');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Alex Morgan');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(state.name, 'Alex Morgan');
    await state.flush();
    final restored = AppState(state.store);
    await restored.restore();
    expect(restored.name, 'Alex Morgan');
  });
}
