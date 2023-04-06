import 'dart:math';

import '../models/song_model.dart';

class SongCollection {
  final List<Song> _collection = [];

  final List<Song> _played = [];

  Song? _current;
  Song? get current => _current;

  final List<Song> _remaining = [];

  bool _random = false;

  bool loop = false;

  bool get hasNext => loop && _collection.length > 1 || _remaining.isNotEmpty;

  bool get hasLast => _played.isNotEmpty;

  bool get hasCurrent => _current != null;

  Song get next => _remaining.first;

  Song get last => _played.last;

  bool get random => _random;
  set random(bool r) {
    if (r && !random) {
      _switchToRandom();
    } else if (!r && random) {
      _switchToSequential();
    }
    _random = r;
  }

  void _switchToSequential() {
    _played.clear();
    _remaining.clear();
    if (_current != null) {
      int index = _collection.indexOf(_current as Song);
      _played.addAll(_collection.getRange(0, index));
      _remaining.addAll(_collection.getRange(index + 1, _collection.length));
    } else if (_collection.isNotEmpty) {
      _remaining.addAll(_collection);
      _current = _remaining.first;
      _remaining.remove(_current);
    }
  }

  void _switchToRandom() {
    List<Song> temp = _collection.toList();
    if (_current != null) {
      temp.remove(_current);
    }
    _played.clear();
    _remaining.clear();
    _remaining.addAll(_newRandomList(temp));
  }

  List<Song> _newRandomList(List<Song> songs) {
    List<Song> newList = songs.toList();
    newList.shuffle();
    return newList;
  }

  void addCurrentToPlayed() {
    if (_current != null) {
      _played.add(_current as Song);
    }
    _current = null;
  }

  void _addCurrentToRemaining() {
    if (_current != null) {
      _remaining.insert(0, _current as Song);
    }
    _current = null;
  }

  void goForward() {
    if (!hasNext) throw Exception('No remaining songs');

    addCurrentToPlayed();

    if (_remaining.isEmpty && loop) {
      if (random) {
        List<Song> newList = _newRandomList(_collection.toList());
        _remaining.addAll(newList);
        if (_played.length > _collection.length) {
          _played.removeRange(0, _collection.length);
        }
      } else {
        _remaining.addAll(_collection);
        _played.clear();
      }
    }

    _current = _remaining.first;
    _remaining.remove(_current);
  }

  void goBack() {
    if (!hasLast) throw Exception('No played songs');

    _addCurrentToRemaining();
    _current = _played.last;
    _played.removeLast();
  }

  void goTo(int index) {
    if (index < 0 || index >= _collection.length) {
      throw Exception('Index out of range');
    }

    _played.clear();
    _remaining.clear();

    _current = _collection[index];

    _played.addAll(_collection.getRange(0, index));
    _remaining.addAll(_collection.getRange(index + 1, _collection.length));
  }

  bool contains(String id) {
    return _collection.any((e) => e.id == id) ||
        current != null && current!.id == id;
  }

  int get count => _collection.length;

  void add(Song song) {
    if (!contains(song.id)) {
      if (random) {
        Random random = Random();
        int index = random.nextInt(_remaining.length);
        _remaining.insert(index, song);
      } else {
        _remaining.add(song);
      }
      _collection.add(song);
    }
  }

  void remove(String id) {
    if (contains(id)) {
      _collection.removeWhere((s) => s.id == id);
      _played.removeWhere((s) => s.id == id);
      _remaining.removeWhere((s) => s.id == id);
      if (_current != null && _current!.id == id) {
        _current = null;
      }
    }
  }

  void load(List<Song> songs) {
    _collection.clear();
    _played.clear();
    _remaining.clear();
    _current = null;
    _collection.addAll(songs);
    if (random) {
      _remaining.addAll(_newRandomList(_collection));
    } else {
      _remaining.addAll(_collection);
    }
  }
}
