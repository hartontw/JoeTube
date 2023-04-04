import 'package:flutter_test/flutter_test.dart';
import 'package:joetube/class/song_collection.dart';
import 'package:joetube/models/song_model.dart';
import 'package:joetube/models/thumbnails_model.dart';

void main() {
  List<Song> songs = [
    Song(
      id: "s1",
      title: "TestSong1",
      authorId: "a1",
      author: "TestAuthor1",
      duration: const Duration(seconds: 120),
      thumbnails: Thumbnails(high: '', medium: '', low: ''),
    ),
    Song(
      id: "s2",
      title: "TestSong2",
      authorId: "a1",
      author: "TestAuthor1",
      duration: const Duration(seconds: 120),
      thumbnails: Thumbnails(high: '', medium: '', low: ''),
    ),
    Song(
      id: "s3",
      title: "TestSong3",
      authorId: "a2",
      author: "TestAuthor2",
      duration: const Duration(seconds: 120),
      thumbnails: Thumbnails(high: '', medium: '', low: ''),
    ),
  ];

  sequential(songs);
  random(songs);
}

void sequential(List<Song> songs) {
  SongCollection collection = SongCollection();

  test('Sequential -> Zero', () {
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, false);
  });

  test('Sequential -> Zero Loop', () {
    collection.loop = true;
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, false);
    collection.loop = false;
  });

  test('Sequential -> One', () {
    collection.add(songs[0]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, false);
    collection.remove(songs[0].id);
  });

  test('Sequential -> One Loop', () {
    collection.loop = true;
    collection.add(songs[0]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, false);
    collection.remove(songs[0].id);
    collection.loop = false;
  });

  test('Sequential -> Two', () {
    collection.add(songs[0]);
    collection.add(songs[1]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, false);
    collection.goBack();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.remove(songs[0].id);
    collection.remove(songs[1].id);
  });

  test('Sequential -> Two Loop', () {
    collection.loop = true;
    collection.add(songs[0]);
    collection.add(songs[1]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goBack();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.remove(songs[0].id);
    collection.remove(songs[1].id);
    collection.loop = false;
  });

  test('Sequential -> Three', () {
    collection.add(songs[0]);
    collection.add(songs[1]);
    collection.add(songs[2]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[2]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, false);
    collection.goBack();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goBack();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.remove(songs[0].id);
    collection.remove(songs[1].id);
    collection.remove(songs[2].id);
  });

  test('Sequential -> Three Loop', () {
    collection.loop = true;
    collection.add(songs[0]);
    collection.add(songs[1]);
    collection.add(songs[2]);
    expect(collection.current, null);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[2]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.goForward();
    expect(collection.current, songs[1]);
    expect(collection.hasLast, true);
    expect(collection.hasNext, true);
    collection.goBack();
    expect(collection.current, songs[0]);
    expect(collection.hasLast, false);
    expect(collection.hasNext, true);
    collection.remove(songs[0].id);
    collection.remove(songs[1].id);
    collection.remove(songs[2].id);
    collection.loop = false;
  });
}

void random(List<Song> songs) {
  SongCollection random = SongCollection();

  test('Random -> Zero', () {
    expect(random.hasLast, false);
    expect(random.current, null);
    expect(random.hasNext, false);
  });

  test('Random -> Zero Loop', () {
    random.loop = true;
    expect(random.hasLast, false);
    expect(random.current, null);
    expect(random.hasNext, false);
    random.loop = false;
  });

  test('Random -> One', () {
    random.add(songs[0]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, false);
    random.remove(songs[0].id);
  });

  test('Random -> One Loop', () {
    random.loop = true;
    random.add(songs[0]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, false);
    random.remove(songs[0].id);
    random.loop = false;
  });

  test('Random -> Two', () {
    random.add(songs[0]);
    random.add(songs[1]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[1]);
    expect(random.hasLast, true);
    expect(random.hasNext, false);
    random.goBack();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.remove(songs[0].id);
    random.remove(songs[1].id);
  });

  test('Random -> Two Loop', () {
    random.loop = true;
    random.add(songs[0]);
    random.add(songs[1]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[1]);
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[1]);
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goBack();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.remove(songs[0].id);
    random.remove(songs[1].id);
    random.loop = false;
  });

  test('Random -> Three', () {
    random.add(songs[0]);
    random.add(songs[1]);
    random.add(songs[2]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, false);
    random.goBack();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goBack();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.remove(songs[0].id);
    random.remove(songs[1].id);
    random.remove(songs[2].id);
  });

  test('Random -> Three Loop', () {
    random.loop = true;
    random.add(songs[0]);
    random.add(songs[1]);
    random.add(songs[2]);
    expect(random.current, null);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.goForward();
    expect(random.current, anyOf(songs[1], songs[2]));
    expect(random.hasLast, true);
    expect(random.hasNext, true);
    random.goBack();
    expect(random.current, songs[0]);
    expect(random.hasLast, false);
    expect(random.hasNext, true);
    random.remove(songs[0].id);
    random.remove(songs[1].id);
    random.remove(songs[2].id);
    random.loop = false;
  });
}
