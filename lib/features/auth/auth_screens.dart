import 'dart:async';

import 'package:flutter/material.dart';

import '../../ui/design.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final s = AppScope.of(context);
      Navigator.pushReplacementNamed(
        context,
        s.signedIn
            ? '/home'
            : s.onboarded
            ? '/welcome'
            : '/intro',
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: PatternBackground(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            photo('logo', width: 167),
            const SizedBox(height: 20),
            const SizedBox(
              width: 34,
              height: 4,
              child: LinearProgressIndicator(
                color: pink,
                backgroundColor: line,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int step = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: WaveBackground(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(260, 65),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: photo(
                      step == 0 ? 'intro_discover' : 'intro_chat',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      step == 0
                          ? "Let's find your match person by swipe. See their info, their images."
                          : 'Chat with your match person, find out their hobby, interest.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (step == 1) {
                              setState(() => step = 0);
                            } else {
                              _finish();
                            }
                          },
                          child: Text(
                            step == 0 ? 'Skip' : 'Back',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            2,
                            (i) => Container(
                              margin: const EdgeInsets.all(3),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: i == step ? 1 : .4,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: BrandButton(
                            step == 0 ? 'Next' : 'Start',
                            () {
                              if (step == 0) {
                                setState(() => step++);
                              } else {
                                _finish();
                              }
                            },
                            color: Colors.white,
                            outlined: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  void _finish() {
    AppScope.of(context).update(() => AppScope.of(context).onboarded = true);
    Navigator.pushReplacementNamed(context, '/welcome');
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: WaveBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            child: SizedBox(
              height: box.maxHeight < 740 ? 740 : box.maxHeight,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(260, 60),
                        ),
                      ),
                      child: Center(child: photo('logo', width: 145)),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            'Welcome to Boobe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'By starting login, you agree to our Terms of Service and our Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          const SizedBox(height: 16),
                          BrandButton(
                            'Login by Facebook',
                            () => _social(context),
                            color: const Color(0xFF5278C6),
                          ),
                          const SizedBox(height: 12),
                          BrandButton(
                            'Login by Google',
                            () => _social(context),
                            color: const Color(0xFFDB665C),
                          ),
                          const SizedBox(height: 12),
                          BrandButton(
                            'Login by mail',
                            () => open(context, '/login'),
                            outlined: true,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => open(context, '/join'),
                            child: const Text(
                              'Do not have an account? Registration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  void _social(BuildContext context) => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Explore Boobe'),
      content: const Text(
        'Social sign-in is a demo. Continue with the local demo account?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(c);
            final s = AppScope.of(context);
            s.update(() => s.signedIn = true);
            home(context);
          },
          child: const Text('Continue'),
        ),
      ],
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  String email = '', password = '';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: PatternBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: form,
          child: Column(
            children: [
              const SizedBox(height: 20),
              photo('logo', width: 145),
              const SizedBox(height: 32),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              FormFieldTile(
                'Mail',
                onChanged: (v) => email = v,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.contains('@') && v.contains('.')
                    ? null
                    : 'Enter a valid email',
              ),
              FormFieldTile(
                'Password',
                secret: true,
                onChanged: (v) => password = v,
                validator: (v) =>
                    (v?.length ?? 0) >= 6 ? null : 'Use at least 6 characters',
              ),
              BrandButton('Login', () {
                if (form.currentState!.validate()) {
                  final s = AppScope.of(context);
                  s.update(() {
                    s.email = email.trim();
                    s.signedIn = true;
                  });
                  home(context);
                }
              }, gradient: true),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Password recovery'),
                      content: const Text(
                        'This offline demo cannot send recovery emails. Use any valid email and a password of at least 6 characters.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => open(context, '/join'),
                child: const Text(
                  'Do not have an account? Registration',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Local demo · Any valid email + 6 character password',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});
  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  int step = 0;
  String password = '', confirmation = '';
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    const titles = [
      'Join Boobe',
      'Personal Information',
      'Place',
      'Hobby',
      'Account',
      'Finish',
    ];
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() => step--);
        }
      },
      child: PageFrame(
        step == 0 || step == 5 ? '' : titles[step],
        child: Form(
          key: form,
          child: Column(
            children: [
              const SizedBox(height: 10),
              photo('logo', width: step == 0 || step == 5 ? 145 : 95),
              const SizedBox(height: 22),
              Text(
                titles[step],
                style: TextStyle(
                  fontSize: step == 0 || step == 5 ? 24 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              if (step == 0)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "We will help you create your account after a few easy steps.",
                    textAlign: TextAlign.center,
                  ),
                ),
              if (step == 1) ...[
                FormFieldTile(
                  'Name',
                  initial: s.name,
                  onChanged: (v) => s.name = v,
                  validator: (v) =>
                      v!.trim().isEmpty ? 'Enter your name' : null,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Date of birth',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  subtitle: Text(s.birthday),
                  trailing: const Icon(
                    Icons.calendar_month_outlined,
                    color: pink,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1995, 7, 23),
                      firstDate: DateTime(1920),
                      lastDate: DateTime(
                        DateTime.now().year - 18,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    );
                    if (date != null && mounted) {
                      s.update(
                        () => s.birthday =
                            '${date.day}/${date.month}/${date.year}',
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Male', label: Text('♂ Male')),
                    ButtonSegment(value: 'Female', label: Text('♀ Female')),
                  ],
                  selected: {s.gender},
                  onSelectionChanged: (v) => s.update(() => s.gender = v.first),
                ),
                const SizedBox(height: 20),
                FormFieldTile(
                  'Introduce yourself',
                  initial: s.bio,
                  lines: 3,
                  onChanged: (v) => s.bio = v,
                ),
              ],
              if (step == 2) ...[
                FormFieldTile(
                  'Country',
                  initial: s.country,
                  onChanged: (v) => s.country = v,
                ),
                FormFieldTile(
                  'City',
                  initial: s.city,
                  onChanged: (v) => s.city = v,
                ),
                FormFieldTile(
                  'Province',
                  initial: s.province,
                  onChanged: (v) => s.province = v,
                ),
                FormFieldTile(
                  'Address',
                  initial: s.work,
                  onChanged: (v) => s.work = v,
                ),
              ],
              if (step == 3) ...[
                const Text('Your hobby?', style: TextStyle(color: muted)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Men'),
                        value: s.showMen,
                        onChanged: (v) => s.update(() => s.showMen = v!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Women'),
                        value: s.showWomen,
                        onChanged: (v) => s.update(() => s.showWomen = v!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SectionLabel('Interest'),
                ),
                const InterestChips(editable: true),
                const SizedBox(height: 32),
              ],
              if (step == 4) ...[
                FormFieldTile(
                  'Mail',
                  initial: s.email,
                  onChanged: (v) => s.email = v,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.contains('@') && v.contains('.')
                      ? null
                      : 'Enter a valid email',
                ),
                FormFieldTile(
                  'Password',
                  secret: true,
                  onChanged: (v) => password = v,
                  validator: (v) => (v?.length ?? 0) >= 6
                      ? null
                      : 'Use at least 6 characters',
                ),
                FormFieldTile(
                  'Confirm password',
                  secret: true,
                  onChanged: (v) => confirmation = v,
                  validator: (v) =>
                      v == password ? null : 'Passwords do not match',
                ),
              ],
              if (step == 5)
                const Text(
                  'Your account is now active. Add more info, images, music… to find your other half. Good luck!',
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 28),
              BrandButton(step == 5 ? 'Success' : 'Next', () {
                if (!form.currentState!.validate()) return;
                if (step == 5) {
                  s.update(() {
                    s.signedIn = true;
                    s.onboarded = true;
                  });
                  home(context);
                } else {
                  s.update(() {});
                  setState(() => step++);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
