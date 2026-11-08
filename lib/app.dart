import 'package:flutter/material.dart';

import 'data/models.dart';
import 'state/app_state.dart';
import 'ui/design.dart';
import 'features/auth/auth_screens.dart';
import 'features/discover/discover_screens.dart';
import 'features/chat/chat_screens.dart';
import 'features/gold/gold_screens.dart';
import 'features/profile/profile_screens.dart';

class BoobeApp extends StatelessWidget {
  const BoobeApp({
    super.key,
    required this.state,
    this.initialRoute = '/',
    this.navigatorKey,
  });
  final AppState state;
  final String initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Boobe',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: pink,
          primary: pink,
          surface: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
          bodyColor: ink,
          displayColor: ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ink,
          ),
        ),
        dividerColor: line,
        listTileTheme: const ListTileThemeData(iconColor: muted),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: muted, fontSize: 12),
          hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: line),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: pink),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: pink,
          thumbColor: pink,
          inactiveTrackColor: line,
          trackHeight: 2,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? pink
                : const Color(0xFFCCCCCC),
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? pink.withValues(alpha: .25)
                : line,
          ),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
      onGenerateRoute: _route,
    ),
  );
  Route<dynamic> _route(RouteSettings settings) {
    final p = settings.arguments is Person
        ? settings.arguments as Person
        : people.first;
    final screen = switch (settings.name) {
      '/' => const SplashScreen(),
      '/intro' => const IntroScreen(),
      '/welcome' => const WelcomeScreen(),
      '/login' => const LoginScreen(),
      '/join' => const JoinScreen(),
      '/home' => const HomeScreen(),
      '/person' => PersonScreen(person: p),
      '/picture' => PictureScreen(person: p),
      '/match' => MatchScreen(person: p),
      '/searching' => const SearchingScreen(),
      '/conversation' => ConversationScreen(person: p),
      '/conversation/options' => ConversationOptionsScreen(person: p),
      '/payment' => const PaymentScreen(),
      '/account' => const AccountScreen(),
      '/edit' => const EditProfileScreen(),
      '/settings' => const SettingsScreen(),
      '/notifications' => const NotificationsScreen(),
      '/delete' => const DeleteAccountScreen(),
      '/soundtrack' => const SoundtrackScreen(),
      '/legal' => LegalScreen(title: settings.arguments as String? ?? 'Help'),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    const icons = [
      Icons.account_circle,
      Icons.favorite,
      Icons.diamond_outlined,
      Icons.forum,
    ];
    const labels = ['Profile', 'Discover', 'Gold', 'Messages'];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Container(
                  height: 58,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: line)),
                  ),
                  child: Row(
                    children: List.generate(
                      4,
                      (i) => Expanded(
                        child: Semantics(
                          selected: s.tab == i,
                          button: true,
                          label: labels[i],
                          child: IconButton(
                            tooltip: labels[i],
                            onPressed: () =>
                                s.update(() => s.tab = i, persist: false),
                            icon: Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                gradient: s.tab == i ? brandGradient : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                icons[i],
                                size: 25,
                                color: s.tab == i
                                    ? Colors.white
                                    : const Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: s.tab,
                    children: const [
                      ProfileView(),
                      DiscoverView(),
                      GoldView(),
                      ChatView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
