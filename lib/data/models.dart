class Person {
  const Person(this.name, this.image, this.distance, {this.age = 24});
  final String name, image;
  final int distance, age;
  String get firstName => name.split(' ').first;
  String get title => '$name ($age)';
}

const people = [
  Person('Wesley Gome', 'wesley', 2),
  Person('Taylor Don', 'person_1', 5),
  Person('Gabriella Montez', 'person_2', 6),
  Person('Sharpay Evans', 'person_3', 12),
  Person('Hannah Lee', 'person_4', 2),
  Person('Stacy Jr', 'person_5', 2),
];
const self = Person('Tony Stark', 'tony', 2);

class Song {
  const Song(this.title, this.artist, this.cover);
  final String title, artist, cover;
}

const songs = [
  Song('All We Know', 'The Chainsmokers ft. Phoebe Ryan', 'album_0'),
  Song("It's Gonna Be Okay", 'The Piano Guys', 'album_1'),
  Song('Be Alright', 'Justin Bieber', 'album_2'),
  Song('All into Nothing', 'R3HAB / Mokita', 'album_3'),
  Song('Somebody That I Used to Know', 'Gotye (feat. Kimbra)', 'album_5'),
  Song('I Want You To Know', 'Zedd ft. Selena Gomez', 'album_4'),
];

class ChatMessage {
  const ChatMessage(this.text, {this.mine = true, this.image = false});
  final String text;
  final bool mine, image;
  Map<String, dynamic> toJson() => {'text': text, 'mine': mine, 'image': image};
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    json['text'] as String,
    mine: json['mine'] as bool,
    image: json['image'] as bool,
  );
}
