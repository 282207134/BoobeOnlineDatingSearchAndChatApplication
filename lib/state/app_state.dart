import 'package:flutter/foundation.dart';

import '../data/local_store.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState(this.store);
  final LocalStore store;
  bool onboarded = false, signedIn = false, gold = false, paused = false;
  String name = 'Tony Stark', email = 'tonyst@gmail.com', gender = 'Male';
  String country = 'United States', city = 'New York', province = 'Manhattan';
  String work = 'Amsterdam', bio = 'Enjoy the little things';
  String education = 'NY University', company = 'MainTheater';
  String instagram = '', phone = '', birthday = '23 July 1995';
  bool showMen = true, showWomen = false, showMe = true;
  bool hideAge = false, hideDistance = false, instagramConnected = false;
  int tab = 1, cardIndex = 0, superLikes = 3, songIndex = -1, plan = 1;
  double distance = 20, minAge = 18, maxAge = 24;
  final interests = <String>{'Photography', 'Running', 'Food'};
  final notifications = <String, bool>{
    'New match': true,
    'Message': true,
    'Super like (Someone Super like you)': true,
    'Top selection': true,
    'Discount, sale Gold User': true,
    'Other': false,
  };
  final liked = <String>{}, muted = <String>{}, removed = <String>{};
  final Map<String, List<ChatMessage>> conversations = {};
  final List<int> history = [];
  final photoNames = <String>['tony', 'tony_1', 'tony_0', 'tony_3'];
  Future<void> _pendingSave = Future.value();

  Future<void> restore() async {
    final data = await store.read();
    onboarded = data['onboarded'] == true;
    signedIn = data['signedIn'] == true;
    gold = data['gold'] == true;
    paused = data['paused'] == true;
    final profile = Map<String, dynamic>.from(data['profile'] ?? {});
    name = profile['name'] ?? name;
    email = profile['email'] ?? email;
    gender = profile['gender'] ?? gender;
    bio = profile['bio'] ?? bio;
    country = profile['country'] ?? country;
    city = profile['city'] ?? city;
    province = profile['province'] ?? province;
    work = profile['work'] ?? work;
    education = profile['education'] ?? education;
    company = profile['company'] ?? company;
    instagram = profile['instagram'] ?? instagram;
    phone = profile['phone'] ?? phone;
    birthday = profile['birthday'] ?? birthday;
    showMen = data['showMen'] ?? showMen;
    showWomen = data['showWomen'] ?? showWomen;
    showMe = data['showMe'] ?? showMe;
    hideAge = data['hideAge'] ?? hideAge;
    hideDistance = data['hideDistance'] ?? hideDistance;
    instagramConnected = data['instagramConnected'] ?? false;
    songIndex = data['songIndex'] ?? -1;
    superLikes = data['superLikes'] ?? 3;
    if (data['photos'] != null) {
      photoNames
        ..clear()
        ..addAll(List<String>.from(data['photos']));
    }
    distance = (data['distance'] ?? 20).toDouble();
    minAge = (data['minAge'] ?? 18).toDouble();
    maxAge = (data['maxAge'] ?? 24).toDouble();
    for (final key in ['liked', 'muted', 'removed']) {
      final target = key == 'liked'
          ? liked
          : key == 'muted'
          ? muted
          : removed;
      target.addAll(List<String>.from(data[key] ?? []));
    }
    if (data['interests'] != null) {
      interests
        ..clear()
        ..addAll(List<String>.from(data['interests']));
    }
    if (data['notifications'] != null) {
      notifications.addAll(Map<String, bool>.from(data['notifications']));
    }
    (data['conversations'] as Map<String, dynamic>? ?? {}).forEach((
      key,
      value,
    ) {
      conversations[key] = (value as List)
          .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    });
  }

  Map<String, dynamic> toJson() => {
    'onboarded': onboarded,
    'signedIn': signedIn,
    'gold': gold,
    'paused': paused,
    'profile': {
      'name': name,
      'email': email,
      'gender': gender,
      'bio': bio,
      'country': country,
      'city': city,
      'province': province,
      'work': work,
      'education': education,
      'company': company,
      'instagram': instagram,
      'phone': phone,
      'birthday': birthday,
    },
    'showMen': showMen,
    'showWomen': showWomen,
    'showMe': showMe,
    'hideAge': hideAge,
    'hideDistance': hideDistance,
    'instagramConnected': instagramConnected,
    'songIndex': songIndex,
    'superLikes': superLikes,
    'photos': photoNames.toList(),
    'distance': distance,
    'minAge': minAge,
    'maxAge': maxAge,
    'interests': interests.toList(),
    'notifications': notifications,
    'liked': liked.toList(),
    'muted': muted.toList(),
    'removed': removed.toList(),
    'conversations': conversations.map(
      (key, value) => MapEntry(key, value.map((m) => m.toJson()).toList()),
    ),
  };
  void update(VoidCallback change, {bool persist = true}) {
    change();
    notifyListeners();
    if (persist) {
      final snapshot = toJson();
      _pendingSave = _pendingSave
          .catchError((Object _) {})
          .then((_) => store.write(snapshot));
    }
  }

  Future<void> flush() => _pendingSave;
  Future<void> deleteLocalAccount() async {
    await flush();
    await store.write(AppState(store).toJson());
    liked.clear();
    muted.clear();
    removed.clear();
    conversations.clear();
    history.clear();
    await restore();
    tab = 1;
    cardIndex = 0;
    notifyListeners();
  }

  Person get current => people[cardIndex % people.length];
  void swipe({bool like = false}) => update(() {
    history.add(cardIndex);
    if (like) liked.add(current.name);
    cardIndex++;
  });
  void undo() {
    if (history.isNotEmpty) {
      update(() {
        cardIndex = history.removeLast();
      });
    }
  }

  void send(Person person, String value, {bool image = false}) {
    if (value.trim().isEmpty) return;
    update(() {
      conversations
          .putIfAbsent(person.name, () => [])
          .add(ChatMessage(value.trim(), image: image));
    });
  }

  void toggleInterest(String value) => update(() {
    interests.contains(value) ? interests.remove(value) : interests.add(value);
  });
}
