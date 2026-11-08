import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../ui/design.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final search = TextEditingController();
  String query = '';
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final list = people
        .where(
          (p) =>
              !s.removed.contains(p.name) &&
              p.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SearchBox(
          controller: search,
          onChanged: (v) => setState(() => query = v),
        ),
        if (query.isEmpty) ...[
          SectionLabel('New match (${list.length})'),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, index) => const SizedBox(width: 22),
              itemBuilder: (c, i) => InkWell(
                onTap: () => open(context, '/conversation', list[i]),
                child: Column(
                  children: [
                    Avatar(list[i].image, size: 62, online: i < 2),
                    const SizedBox(height: 9),
                    Text(
                      list[i].firstName,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        SectionLabel(
          query.isEmpty
              ? 'Message (2 Unread)'
              : 'Search result (${list.length})',
        ),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('No people found', style: TextStyle(color: muted)),
            ),
          ),
        ...list.asMap().entries.map((entry) {
          final i = entry.key, p = entry.value;
          final messages = s.conversations[p.name] ?? [];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: Avatar(p.image, size: 46, online: i == 0),
            title: Text(
              p.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              messages.isNotEmpty
                  ? (messages.last.image ? 'Photo' : messages.last.text)
                  : i == 0
                  ? "It's time tomorrow 1pm"
                  : 'Nice to meet you, Tony',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: muted, fontSize: 11),
            ),
            trailing: Text(
              messages.isNotEmpty
                  ? 'Now'
                  : i < 2
                  ? 'July 11'
                  : 'April 30',
              style: const TextStyle(color: muted, fontSize: 10),
            ),
            onTap: () => open(context, '/conversation', p),
          );
        }),
      ],
    );
  }
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.person});
  final Person person;
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final input = TextEditingController(), scroll = ScrollController();
  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context), p = widget.person;
    final messages = s.conversations[p.name] ?? [];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () => open(context, '/person', p),
          child: Row(
            children: [
              Avatar(p.image, size: 30),
              const SizedBox(width: 10),
              Text(p.name, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Conversation options',
            onPressed: () => open(context, '/conversation/options', p),
            icon: const Icon(Icons.more_vert, color: pink),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'You are match with ${p.name}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'July 11, 2019',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                          const SizedBox(height: 24),
                          Avatar(p.image, size: 160),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scroll,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (c, i) {
                        final m = messages[i];
                        return Align(
                          alignment: m.mine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: const BoxConstraints(maxWidth: 270),
                            padding: m.image
                                ? const EdgeInsets.all(4)
                                : const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                            decoration: BoxDecoration(
                              color: m.mine ? pink : line,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: m.image
                                ? GestureDetector(
                                    onTap: () => open(
                                      context,
                                      '/picture',
                                      Person(p.name, m.text, 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: photo(
                                        m.text,
                                        width: 240,
                                        height: 190,
                                      ),
                                    ),
                                  )
                                : Text(
                                    m.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: m.mine ? Colors.white : ink,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: line)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Attach photo',
                    onPressed: _attachment,
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      size: 21,
                      color: muted,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Type your message…',
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send message',
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded, size: 21, color: pink),
                  ),
                  IconButton(
                    tooltip: 'Send heart',
                    onPressed: () {
                      s.send(p, '♥');
                      _scrollDown();
                    },
                    icon: const Icon(Icons.favorite, size: 21, color: pink),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    final s = AppScope.of(context);
    s.send(widget.person, input.text);
    input.clear();
    _scrollDown();
  }

  void _scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && scroll.hasClients) {
      scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  });
  void _attachment() => showModalBottomSheet<void>(
    context: context,
    builder: (c) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a demo photo'),
            const SizedBox(height: 8),
            const Text(
              'Local design images · No device access needed',
              style: TextStyle(fontSize: 11, color: muted),
            ),
            const SizedBox(height: 20),
            Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(c);
                      AppScope.of(context)
                          .send(widget.person, 'person_$i', image: true);
                      _scrollDown();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: photo('person_$i', height: 110),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ConversationOptionsScreen extends StatelessWidget {
  const ConversationOptionsScreen({super.key, required this.person});
  final Person person;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      '',
      child: Column(
        children: [
          const SizedBox(height: 25),
          Avatar(person.image, size: 150),
          const SizedBox(height: 25),
          Text(person.title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 35),
          ListTile(
            title: const Text('See profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(context, '/person', person),
          ),
          SwitchListTile(
            title: const Text(
              'Disable notifications for this conversation',
              style: TextStyle(fontSize: 12),
            ),
            value: s.muted.contains(person.name),
            onChanged: (v) => s.update(() {
              v ? s.muted.add(person.name) : s.muted.remove(person.name);
            }),
          ),
          ListTile(
            title: const Text(
              'Delete this match',
              style: TextStyle(color: pink),
            ),
            onTap: () => showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Delete this match?'),
                content: Text(
                  'Remove ${person.name} and your local conversation?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      s.update(() {
                        s.removed.add(person.name);
                        s.conversations.remove(person.name);
                      });
                      s.update(() => s.tab = 3, persist: false);
                      home(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
