import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../gold/gold_screens.dart';
import '../../ui/design.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int benefit = 0;
  final pages = PageController();
  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    const headings = [
      'Buy Gold User',
      'Super Like',
      'Speed up',
      'See who likes you',
      'No ads',
    ];
    const descriptions = [
      'See who likes you and more!',
      'Increase your chance to find a match with 5 Super Likes each day.',
      'Speed up your profile and find more opportunities.',
      'Discover people who already like you.',
      'Enjoy an uninterrupted experience.',
    ];
    const colors = [
      gold,
      Color(0xFFFFBD3C),
      Color(0xFF7855C5),
      Color(0xFF85ADF5),
      muted,
    ];
    const icons = [
      Icons.favorite,
      Icons.star,
      Icons.bolt,
      Icons.people,
      Icons.block,
    ];
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(260, 60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x08000000),
                    offset: Offset(0, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        open(context, '/person', Person(s.name, 'tony', 2)),
                    child: const Avatar('tony', size: 120),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    '${s.name} (24)',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (s.gold)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'GOLD MEMBER',
                        style: TextStyle(color: gold, fontSize: 10),
                      ),
                    ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _ProfileAction(
                          'Account',
                          Icons.account_circle_outlined,
                          '/account',
                        ),
                      ),
                      const Expanded(
                        child: _ProfileAction(
                          'Edit info',
                          Icons.edit_outlined,
                          '/edit',
                        ),
                      ),
                      Expanded(
                        child: _ProfileAction(
                          'Setting',
                          Icons.settings_outlined,
                          '/settings',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: pages,
                itemCount: headings.length,
                onPageChanged: (i) => setState(() => benefit = i),
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[i], color: colors[i], size: 22),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              headings[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (i) => GestureDetector(
                  onTap: () => pages.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[benefit].withValues(
                        alpha: i == benefit ? 1 : .3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: BrandButton(
                s.gold ? 'Gold preview active' : 'Upgrade to Gold User',
                () => showGoldSheet(context),
                outlined: true,
                color: gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction(this.label, this.icon, this.route);
  final String label, route;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          tooltip: label,
          onPressed: () => open(context, route),
          icon: Icon(icon, size: 25),
        ),
      ),
      const SizedBox(height: 12),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      'Setting',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Display'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Male'),
            value: s.showMen,
            onChanged: (v) => s.update(() => s.showMen = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Female'),
            value: s.showWomen,
            onChanged: (v) => s.update(() => s.showWomen = v),
          ),
          const SectionLabel('Distance'),
          Center(
            child: Text(
              '${s.distance.round()}km',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Slider(
            value: s.distance,
            min: 1,
            max: 100,
            divisions: 99,
            label: '${s.distance.round()}km',
            onChanged: (v) => s.update(() => s.distance = v),
          ),
          const SectionLabel('Age'),
          Text(
            '${s.minAge.round()} – ${s.maxAge.round()}',
            style: const TextStyle(fontSize: 13),
          ),
          RangeSlider(
            values: RangeValues(s.minAge, s.maxAge),
            min: 18,
            max: 70,
            divisions: 52,
            labels: RangeLabels('${s.minAge.round()}', '${s.maxAge.round()}'),
            onChanged: (v) => s.update(() {
              s.minAge = v.start;
              s.maxAge = v.end;
            }),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show me on Boobe'),
            value: s.showMe,
            onChanged: (v) => s.update(() => s.showMe = v),
          ),
          _RouteTile('Notification', '/notifications'),
          ...['Help', 'License', 'Terms of Service', 'Privacy Policy'].map(
            (label) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: const TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: muted),
              onTap: () => open(context, '/legal', label),
            ),
          ),
          const Divider(),
          Center(
            child: TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Log out?'),
                  content: const Text(
                    'Your local profile and messages will be kept on this device.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        s.update(() => s.signedIn = false);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/welcome',
                          (_) => false,
                        );
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              ),
              child: const Text('Log out'),
            ),
          ),
          Center(child: photo('logo', width: 60)),
          const Center(
            child: Text(
              'Boobe 1.0.0',
              style: TextStyle(fontSize: 10, color: muted),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => open(context, '/delete'),
              child: const Text(
                'Delete Account',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteTile extends StatelessWidget {
  const _RouteTile(this.label, this.route);
  final String label, route;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label, style: const TextStyle(fontSize: 13)),
    trailing: const Icon(Icons.chevron_right, color: muted),
    onTap: () => open(context, route),
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      'Notification',
      child: Column(
        children: s.notifications.entries
            .map(
              (e) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.key, style: const TextStyle(fontSize: 12)),
                value: e.value,
                onChanged: (v) => s.update(() => s.notifications[e.key] = v),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final form = GlobalKey<FormState>();
  String oldPassword = '', newPassword = '', confirm = '';
  @override
  Widget build(BuildContext context) => PageFrame(
    'Account',
    child: Form(
      key: form,
      child: Column(
        children: [
          const SizedBox(height: 12),
          photo('logo', width: 105),
          const SizedBox(height: 24),
          const Text(
            'Your account',
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 24),
          FormFieldTile(
            'Mail',
            initial: AppScope.of(context).email,
            onChanged: (v) => AppScope.of(context).email = v,
            validator: (v) => v!.contains('@') ? null : 'Enter a valid email',
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionLabel('Change password'),
          ),
          FormFieldTile(
            'Old password',
            secret: true,
            onChanged: (v) => oldPassword = v,
            validator: (v) =>
                v!.isEmpty ? 'Enter your current demo password' : null,
          ),
          FormFieldTile(
            'New password',
            secret: true,
            onChanged: (v) => newPassword = v,
            validator: (v) =>
                (v?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
          ),
          FormFieldTile(
            'Confirmation password',
            secret: true,
            onChanged: (v) => confirm = v,
            validator: (v) =>
                v != newPassword ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 18),
          BrandButton('Change', () {
            if (form.currentState!.validate()) {
              AppScope.of(context).update(() {});
              notice(
                context,
                'Account saved locally. Password change is a demo; no server is connected.',
              );
            }
          }),
        ],
      ),
    ),
  );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final Map<String, String> draft;
  bool initialized = false;
  final form = GlobalKey<FormState>();
  late List<String> photos;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final s = AppScope.of(context);
      photos = List.of(s.photoNames);
      draft = {
        'Name': s.name,
        'Introduce yourself': s.bio,
        'Phone': s.phone,
        'Email': s.email,
        'Education': s.education,
        'Company': s.company,
        'Country': s.country,
        'City': s.city,
        'Province': s.province,
        'Work': s.work,
      };
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      'Edit Profile',
      action: TextButton(onPressed: _save, child: const Text('Save')),
      child: Form(
        key: form,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: .95,
              ),
              itemBuilder: (c, i) => GestureDetector(
                onTap: () => _choosePhoto(i),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: i < photos.length
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            photo(photos[i]),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                tooltip: 'Remove photo ${i + 1}',
                                onPressed: () =>
                                    setState(() => photos.removeAt(i)),
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Color(0xFFCCCCCC),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _field('Name'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Date of birth',
                style: TextStyle(fontSize: 11, color: muted),
              ),
              subtitle: Text(s.birthday),
              trailing: const Icon(Icons.calendar_month_outlined, color: pink),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1995, 7, 23),
                  firstDate: DateTime(1920),
                  lastDate: DateTime(DateTime.now().year - 18),
                );
                if (date != null) {
                  s.update(
                    () => s.birthday = '${date.day}/${date.month}/${date.year}',
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Male', label: Text('♂ Male')),
                ButtonSegment(value: 'Female', label: Text('♀ Female')),
              ],
              selected: {s.gender},
              onSelectionChanged: (v) => s.update(() => s.gender = v.first),
            ),
            const SizedBox(height: 20),
            _field('Introduce yourself', lines: 3),
            ...[
              'Phone',
              'Email',
              'Education',
              'Company',
              'Country',
              'City',
              'Province',
              'Work',
            ].map((v) => _field(v)),
            const Align(
              alignment: Alignment.centerLeft,
              child: SectionLabel('I like'),
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: s.showMen,
                    onChanged: (v) => s.update(() => s.showMen = v!),
                    title: const Text('Men'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: s.showWomen,
                    onChanged: (v) => s.update(() => s.showWomen = v!),
                    title: const Text('Women'),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'My soundtrack',
                style: TextStyle(fontSize: 13),
              ),
              subtitle: s.songIndex >= 0
                  ? Text(
                      songs[s.songIndex].title,
                      style: const TextStyle(fontSize: 11, color: muted),
                    )
                  : null,
              trailing: TextButton(
                onPressed: () => open(context, '/soundtrack'),
                child: Text(s.songIndex < 0 ? 'Add' : 'Change'),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Show Instagram images',
                style: TextStyle(fontSize: 12),
              ),
              trailing: TextButton(
                onPressed: () {
                  s.update(() => s.instagramConnected = !s.instagramConnected);
                  notice(
                    context,
                    s.instagramConnected
                        ? 'Demo gallery connected locally'
                        : 'Demo gallery disconnected',
                  );
                },
                child: Text(s.instagramConnected ? 'Disconnect' : 'Connect'),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: SectionLabel('Display profile'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Don't show my age",
                style: TextStyle(fontSize: 13),
              ),
              value: s.hideAge,
              onChanged: (v) => s.update(() => s.hideAge = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Hide my distance',
                style: TextStyle(fontSize: 13),
              ),
              value: s.hideDistance,
              onChanged: (v) => s.update(() => s.hideDistance = v),
            ),
            const SizedBox(height: 20),
            BrandButton('Save profile', _save),
          ],
        ),
      ),
    );
  }

  Widget _field(String key, {int lines = 1}) => FormFieldTile(
    key,
    initial: draft[key]!,
    lines: lines,
    onChanged: (v) => draft[key] = v,
    validator: key == 'Name'
        ? (v) => v!.trim().isEmpty ? 'Enter your name' : null
        : null,
  );
  void _save() {
    if (!form.currentState!.validate()) return;
    final s = AppScope.of(context);
    s.update(() {
      s.name = draft['Name']!;
      s.bio = draft['Introduce yourself']!;
      s.phone = draft['Phone']!;
      s.email = draft['Email']!;
      s.education = draft['Education']!;
      s.company = draft['Company']!;
      s.country = draft['Country']!;
      s.city = draft['City']!;
      s.province = draft['Province']!;
      s.work = draft['Work']!;
      s.photoNames
        ..clear()
        ..addAll(photos);
    });
    Navigator.pop(context);
    notice(context, 'Profile saved');
  }

  void _choosePhoto(int index) => showModalBottomSheet<void>(
    context: context,
    builder: (c) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a demo photo'),
            const SizedBox(height: 18),
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (index < photos.length) {
                          photos[index] = 'tony_$i';
                        } else {
                          photos.add('tony_$i');
                        }
                      });
                      Navigator.pop(c);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: photo('tony_$i', height: 100),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap Save to keep your photo arrangement.',
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}

class SoundtrackScreen extends StatefulWidget {
  const SoundtrackScreen({super.key});
  @override
  State<SoundtrackScreen> createState() => _SoundtrackScreenState();
}

class _SoundtrackScreenState extends State<SoundtrackScreen> {
  final controller = TextEditingController();
  String query = '';
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context),
        filtered = songs
            .where(
              (song) => '${song.title} ${song.artist}'.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
    return PageFrame(
      'My Soundtrack',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBox(
            controller: controller,
            onChanged: (v) => setState(() => query = v),
            hint: 'Find your soundtrack',
          ),
          const SectionLabel('Your soundtrack'),
          if (s.songIndex >= 0)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: photo(songs[s.songIndex].cover, width: 48, height: 48),
              title: Text(
                songs[s.songIndex].title,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                tooltip: 'Remove soundtrack',
                onPressed: () => s.update(() => s.songIndex = -1),
                icon: const Icon(Icons.cancel_outlined, color: muted),
              ),
            ),
          SectionLabel(
            query.isEmpty ? 'Highlight' : 'Search result (${filtered.length})',
          ),
          if (filtered.isEmpty)
            const Text('No soundtracks found', style: TextStyle(color: muted)),
          ...filtered.map(
            (song) => ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              leading: photo(song.cover, width: 48, height: 48),
              title: Text(song.title, style: const TextStyle(fontSize: 13)),
              subtitle: Text(
                song.artist,
                style: const TextStyle(fontSize: 10, color: muted),
              ),
              trailing: Icon(
                s.songIndex == songs.indexOf(song)
                    ? Icons.check_circle
                    : Icons.add_circle_outline,
                color: s.songIndex == songs.indexOf(song) ? pink : line,
              ),
              onTap: () {
                s.update(() => s.songIndex = songs.indexOf(song));
                notice(context, 'Soundtrack added to your profile');
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Music selection preview. Audio playback is not connected.',
            style: TextStyle(fontSize: 10, color: muted),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Delete Account')),
    body: PatternBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('STOP MY ACCOUNT', style: TextStyle(fontSize: 23)),
              const SizedBox(height: 25),
              const Text(
                'If you want to keep your account but not show it to others, you can choose not to display your account. You can turn off the display feature in settings.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: muted),
              ),
              const SizedBox(height: 32),
              BrandButton('Stop my account', () {
                final s = AppScope.of(context);
                s.update(() {
                  s.paused = true;
                  s.showMe = false;
                });
                Navigator.pop(context);
                notice(
                  context,
                  'Profile hidden. Turn on Show me in settings to return.',
                );
              }),
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Delete local account?'),
                    content: const Text(
                      'This removes your local profile and messages. This cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final s = AppScope.of(context);
                          await s.deleteLocalAccount();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/welcome',
                            (_) => false,
                          );
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
                child: const Text(
                  'Delete My Account',
                  style: TextStyle(color: pink),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => PageFrame(
    title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 24),
        Text(switch (title) {
          'Help' => 'Explore the four tabs at the top: your profile, Discover, Gold and Messages. Swipe a card or tap the heart to see a demo match. Edit your profile and select a soundtrack from your profile tab.',
          'License' => 'UI reference: Boobe, supplied by the user via Pixso. Photos, logo, illustrations and covers were exported from that document. Poppins is distributed under the SIL Open Font License; see assets/fonts/OFL.txt.',
          'Privacy Policy' => 'This offline prototype stores your demo profile, preferences and messages on this device. It does not send messages, upload photos, access location or collect payment details. Local data can be removed from Delete Account or Android app settings.',
          _ => 'Boobe is an offline UI demonstration for adults aged 18 and above. Matching, login and Gold checkout are simulations. There is no live dating service, subscription or real payment. The final service terms must be provided before a public launch.',
        }, style: const TextStyle(height: 1.9, fontSize: 14)),
      ],
    ),
  );
}
