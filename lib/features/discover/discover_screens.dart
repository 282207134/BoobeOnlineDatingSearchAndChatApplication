import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../ui/design.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 42),
          child: Column(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0).abs() > 150) {
                    _swipe(context, s, (d.primaryVelocity ?? 0) > 0);
                  }
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 6,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => open(context, '/person', s.current),
                        child: Stack(
                          children: [
                            photo(
                              s.current.image,
                              width: double.infinity,
                              height: (constraints.maxHeight * .54).clamp(
                                270,
                                390,
                              ),
                            ),
                            Positioned(
                              top: 14,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (i) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: 12,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: i == 0 ? 1 : .4,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -13),
                        child: GestureDetector(
                          onTap: () => open(context, '/person', s.current),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: brandGradient,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Text(
                              '♥  95% Match!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                s.current.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'More info',
                              onPressed: () =>
                                  open(context, '/person', s.current),
                              icon: const Icon(
                                Icons.info_outline,
                                color: pink,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '⌖  ${s.current.distance}km away',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "Love is something you can't tell. Just close your eyes, silence and feel.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ActionRow(
                        onSkip: () => _swipe(context, s, false),
                        onLike: () => _swipe(context, s, true),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: s.history.isEmpty ? null : s.undo,
                icon: const Icon(Icons.undo, size: 15),
                label: const Text(
                  'Rewind last swipe',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _swipe(BuildContext context, AppState s, bool like) {
    final person = s.current;
    s.swipe(like: like);
    if (like) {
      open(context, '/match', person);
    }
  }
}

class ActionRow extends StatelessWidget {
  const ActionRow({super.key, required this.onSkip, required this.onLike});
  final VoidCallback onSkip, onLike;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _CircleAction('Super like', Icons.star, const Color(0xFFFFBD3C), 42, () {
        final s = AppScope.of(context);
        if (s.superLikes == 0) {
          notice(context, 'No Super Likes left. Explore Gold for more.');
          open(context, '/home');
          s.update(() => s.tab = 0, persist: false);
          return;
        }
        s.update(() {
          s.superLikes--;
          s.liked.add(s.current.name);
        });
        showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            icon: const Icon(Icons.star, size: 70, color: Color(0xFFFFBD3C)),
            title: const Text('CONGRATULATIONS'),
            content: Text('Super Like sent! ${s.superLikes} Super Likes left.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Yeah, got it!'),
              ),
            ],
          ),
        );
      }),
      _CircleAction('Skip', Icons.close, ink, 60, onSkip),
      _CircleAction('Like', Icons.favorite, pink, 60, onLike),
      _CircleAction(
        'Speed up',
        Icons.bolt,
        const Color(0xFF7855C5),
        42,
        () => open(context, '/searching'),
      ),
    ],
  );
}

class _CircleAction extends StatelessWidget {
  const _CircleAction(this.label, this.icon, this.color, this.size, this.tap);
  final String label;
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: IconButton(
      tooltip: label,
      onPressed: tap,
      icon: Icon(icon, color: color, size: size == 60 ? 28 : 19),
    ),
  );
}

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key, required this.person});
  final Person person;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      top: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => open(context, '/picture', person),
                      child: photo(
                        person.image,
                        width: double.infinity,
                        height: 390,
                      ),
                    ),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            tooltip: 'Back',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            tooltip: 'View picture',
                            onPressed: () => open(context, '/picture', person),
                            icon: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -16, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: brandGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          '♥ 95% Match!',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(person.title, style: const TextStyle(fontSize: 23)),
                      const SizedBox(height: 10),
                      Text('⌖ ${person.distance}km away'),
                      const SizedBox(height: 20),
                      const _InfoLine(
                        Icons.home_outlined,
                        'Live in Manhattan, New York',
                      ),
                      const _InfoLine(
                        Icons.school_outlined,
                        'Learning NY University',
                      ),
                      const _InfoLine(
                        Icons.work_outline,
                        'Musician in MainTheater',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Love is something you can't tell. Just close your eyes, silence and feel.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SectionLabel('My soundtrack'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: photo('album_0', width: 55, height: 55),
                        title: const Text(
                          'All We Know',
                          style: TextStyle(fontSize: 13),
                        ),
                        subtitle: const Text(
                          'The Chainsmokers ft. Phoebe Ryan',
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                        trailing: const Icon(
                          Icons.music_note_outlined,
                          color: pink,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SectionLabel('Instagram images'),
                      ),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          6,
                          (i) => GestureDetector(
                            onTap: () => open(
                              context,
                              '/picture',
                              Person(person.name, 'person_$i', person.distance),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: photo('person_$i'),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SectionLabel('Hobbies'),
                      ),
                      const InterestChips(),
                      const SizedBox(height: 26),
                      TextButton(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Report profile'),
                            content: const Text(
                              'Reporting is unavailable in the offline demo. No data will be sent.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                        child: Text(
                          'Report ${person.firstName}',
                          style: const TextStyle(color: pink),
                        ),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .97),
                borderRadius: BorderRadius.circular(40),
              ),
              child: ActionRow(
                onSkip: () {
                  AppScope.of(context).swipe();
                  home(context);
                },
                onLike: () {
                  AppScope.of(
                    context,
                  ).update(() => AppScope.of(context).liked.add(person.name));
                  open(context, '/match', person);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.icon, this.text);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.person});
  final Person person;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: WaveBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
              const Spacer(),
              const Text(
                "IT'S A MATCH!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Avatar('tony', size: 100),
                  const SizedBox(width: 8),
                  Avatar(person.image, size: 100),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                person.title,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manhattan, New York',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 60),
              BrandButton(
                'Say Hi to ${person.firstName} <3',
                () => Navigator.pushReplacementNamed(
                  context,
                  '/conversation',
                  arguments: person,
                ),
                outlined: true,
                color: Colors.white,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Keep swiping',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Searching near here')),
    body: WaveBackground(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                  border: Border.all(color: Colors.white70),
                ),
                child: const Avatar('tony', size: 94),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Searching near here…',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Discover people within your distance preference',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: 220,
              child: BrandButton(
                'View nearby people',
                () {
                  final s = AppScope.of(context);
                  s.update(() => s.tab = 1, persist: false);
                  home(context);
                },
                color: Colors.white,
                outlined: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key, required this.person});
  final Person person;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text('Instagram of ${person.firstName}'),
    ),
    body: Center(
      child: InteractiveViewer(
        minScale: .8,
        maxScale: 4,
        child: photo(person.image, width: double.infinity, fit: BoxFit.contain),
      ),
    ),
  );
}
