part of lists;

/// Sparse list based on the grouped range lists.
// TODO: sublist
// TODO: toList
class SparseList<E> extends Object with ListMixin<E> {
  final E defaultValue;

  bool Function(E, E) _equals;

  bool _fixedLength = false;

  bool _frozen = false;

  List<GroupedRangeList<E>> _groups = <GroupedRangeList<E>>[];

  int _length;

  SparseList({this.defaultValue, bool equals(E e1, E e2), int length}) {
    if (length == null) {
      length = 0;
    } else {
      if (length < 0) {
        throw new ArgumentError("length: $length");
      }

      _fixedLength = true;
    }

    _length = length;
    if (equals != null) {
      _equals = equals;
    } else {
      _equals = (E e1, E e2) => e1 == e2;
    }
  }

  /// Returns the 'end' value from the last group (if available); otherwise null.
  int get end {
    var length = _groups.length;
    if (_groups.isEmpty) {
      return null;
    }

    return _groups[length - 1].end;
  }

  /// Returns true if the list is frozen; otherwise false.
  bool get frozen {
    return _frozen;
  }

  /// Returns the number of groups.
  int get groupCount => _groups.length;

  /// Returns a read-only list of the groups.
  List<GroupedRangeList<E>> get groups =>
      new UnmodifiableListView<GroupedRangeList<E>>(_groups);

  /// Returns the length of list.
  int get length => _length;

  /// Sets the length of list.
  set length(int length) {
    if (length == null) {
      throw new ArgumentError("length: $length");
    }

    if (_fixedLength) {
      throw new StateError("Unable to set the length of a fixed list.");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (length < 0) {
      throw new RangeError(length);
    }

    if (_length == length) {
      return;
    }

    if (_length < length) {
      _length = length;
      return;
    }

    if (length == 0) {
      _groups.length = 0;
      _length = 0;
      return;
    }

    _resetValues(new RangeList(length, _length - 1));
    _length = length;
  }

  /// Returns the 'start' value from the first group (if available); otherwise
  /// null.
  int get start {
    if (_groups.isEmpty) {
      return null;
    }

    return _groups[0].start;
  }

  E operator [](int index) {
    if (index == null) {
      throw new ArgumentError("index: $index");
    }

    if (index < 0 || index >= _length) {
      throw new RangeError(index);
    }

    var right = _groups.length;
    if (right == 0) {
      return defaultValue;
    }

    if (right == 1) {
      var group = _groups[0];
      if (index <= group.end && index >= group.start) {
        return group.key;
      } else {
        return defaultValue;
      }
    }

    var left = 0;
    var key = index;
    int middle;
    var value = defaultValue;
    while (left < right) {
      middle = (left + right) >> 1;
      var group = _groups[middle];
      if (group.end < key) {
        left = middle + 1;
      } else {
        if (key >= group.start) {
          return group.key;
        }

        right = middle;
      }
    }

    return value;
  }

  void operator []=(int index, E value) {
    if (index == null) {
      throw new ArgumentError("index: $index");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (index < 0 || index >= _length) {
      throw new RangeError(index);
    }

    if (_equals(value, defaultValue)) {
      _resetValues(new RangeList(index, index));
    } else {
      setGroup(new GroupedRangeList(index, index, value));
    }
  }

  /// Sets the values ​​in accordance with the specified [group] and increases
  /// (if required) the length up to (range.end + 1).
  void addGroup(GroupedRangeList<E> group) {
    if (group == null) {
      throw new ArgumentError("group: $group");
    }

    if (_fixedLength) {
      throw new StateError("Unable to add the group into fixed list.");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (group.start < 0) {
      throw new RangeError(group.start);
    }

    _setGroup(group);
    if (_length < group.end + 1) {
      _length = group.end + 1;
    }
  }

  /// Makes the list unmodifiable.
  void freeze() {
    _frozen = true;
  }

  /// Returns all groups that intersects with the specified [range] which being
  /// expanded (with default value) or shrunk to specified [range].
  List<GroupedRangeList<E>> getAlignedGroups(RangeList range) {
    if (range == null) {
      throw new ArgumentError("range: $range");
    }

    var groups = getGroups(range).toList();
    var length = groups.length;
    if (length == 0) {
      return [new GroupedRangeList<E>(range.start, range.end, defaultValue)];
    }

    var first = groups.first;
    if (range.start > first.start) {
      groups[0] = first.intersection(range);
    } else if (range.start < first.start) {
      var insertion =
          new GroupedRangeList<E>(range.start, first.start - 1, defaultValue);
      groups.insert(0, insertion);
    }

    var last = groups.last;
    if (range.end > last.end) {
      var addition =
          new GroupedRangeList<E>(last.end + 1, range.end, defaultValue);
      groups.add(addition);
    } else if (range.end < last.end) {
      groups[groups.length - 1] = last.intersection(range);
    }

    return groups;
  }

  /// Returns all space as groups (including synthetic groups with default
  /// values from not filled space) that intersects with the specified [range]
  /// which being expanded (with default value) or shrunk to specified [range].
  List<GroupedRangeList<E>> getAllSpace(RangeList range) {
    if (range == null) {
      throw new ArgumentError("range: $range");
    }

    var groups = <GroupedRangeList<E>>[];
    GroupedRangeList<E> previous;
    for (var group in getAlignedGroups(range)) {
      if (previous != null) {
        var start = previous.end + 1;
        var delta = group.start - start;
        if (delta > 0) {
          // Adds the synthetic group
          groups.add(
              new GroupedRangeList<E>(start, group.start - 1, defaultValue));
        }
      }

      groups.add(group);
      previous = group;
    }

    return groups;
  }

  /// Returns all groups that intersects with the specified [range].
  Iterable<GroupedRangeList<E>> getGroups([RangeList range]) {
    if (range == null) {
      return _groups.getRange(0, _groups.length);
    }

    var length = _groups.length;
    var left = _findNearestIndex(0, length, range.start);
    var firstIndex = -1;
    var lastIndex = -1;
    for (var i = left; i < length; i++) {
      if (_groups[i].intersect(range)) {
        if (firstIndex == -1) {
          firstIndex = i;
          lastIndex = i;
        } else {
          lastIndex = i;
        }
      } else if (firstIndex != -1) {
        break;
      }
    }

    if (firstIndex == -1) {
      return <GroupedRangeList<E>>[];
    }

    return _groups.getRange(firstIndex, lastIndex + 1);
  }

  /// Returns the indexes of the elements with a value.
  Iterable<int> getIndexes() {
    Iterable<int> generator() sync* {
      for (var group in groups) {
        var end = group.end;
        for (var i = group.start; i <= end; i++) {
          yield i;
        }
      }
    }

    return generator();
  }

  /// Removes the values in the specified range and decreases (if possible) the
  /// length down to (range.start).
  void removeValues(RangeList range) {
    if (range == null) {
      throw new ArgumentError("range: $range");
    }

    if (_fixedLength) {
      throw new StateError("Unable to remove the values from a fixed list.");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (range.start < 0) {
      throw new RangeError(range.start);
    }

    _resetValues(range);
    if (_groups.isEmpty) {
      if (_length > range.start) {
        _length = range.start;
      }
    } else {
      var length = _groups.last.end + 1;
      if (length > range.start && length < range.end) {
        length = range.start;
      }

      _length = length;
    }
  }

  /// Resets the values in the specified [range] to the default values.
  void resetValues(RangeList range) {
    if (range == null) {
      throw new ArgumentError("range: $range");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (range.start < 0 || range.start >= _length) {
      throw new RangeError(range.start);
    }

    if (range.end >= _length) {
      throw new RangeError(range.end);
    }

    _resetValues(range);
  }

  /// Sets the values ​​in accordance with the specified [group].
  void setGroup(GroupedRangeList<E> group) {
    if (group == null) {
      throw new ArgumentError("group: $group");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    if (group.start < 0 || group.start >= _length) {
      throw new RangeError(group.start);
    }

    if (group.end >= _length) {
      throw new RangeError(group.end);
    }

    _setGroup(group);
  }

  /// Sets the length of list equal to the last not empty index + 1; otherwise
  /// sets the length to 0.
  void trim() {
    if (_fixedLength) {
      throw new StateError("Unable to trim a fixed list.");
    }

    if (frozen) {
      _errorModificationNotAllowed();
    }

    var groupCount = _groups.length;
    if (groupCount == 0) {
      _length = 0;
    } else {
      _length = _groups[groupCount - 1].end + 1;
    }
  }

  void _errorModificationNotAllowed() {
    throw new StateError("Unable to modify the frozen list.");
  }

  int _findNearestIndex(int left, int right, int key) {
    if (right == 0) {
      return 0;
    }

    int middle;
    while (left < right) {
      middle = (left + right) >> 1;
      if (_groups[middle].end < key) {
        left = middle + 1;
      } else {
        right = middle;
      }
    }

    if (left > 0) {
      left--;
    }

    return left;
  }

  void _resetValues(RangeList range) {
    var rangeStart = range.start;
    var rangeEnd = range.end;
    var length = _groups.length;
    var left = _findNearestIndex(0, length, range.start);
    var count = 0;
    var newGroups = <GroupedRangeList<E>>[];
    for (var i = left; i < length; i++) {
      var current = _groups[i];
      var start = current.start;
      if (start > rangeEnd) {
        break;
      }

      var intersect = current.intersect(range);
      if (intersect) {
        var end = current.end;
        var key = current.key;
        if (start < rangeStart) {
          var newGroup = new GroupedRangeList<E>(start, rangeStart - 1, key);
          newGroups.add(newGroup);
        }

        if (end > rangeEnd) {
          var newGroup = new GroupedRangeList<E>(rangeEnd + 1, end, key);
          newGroups.add(newGroup);
        }
      } else {
        newGroups.add(current);
      }

      count++;
    }

    _groups.removeRange(left, left + count);
    _groups.insertAll(left, newGroups);
  }

  void _setGroup(GroupedRangeList<E> group) {
    var groupKey = group.key;
    var length = _groups.length;
    if (length == 0) {
      _groups.add(group);
      return;
    }

    var groupStart = group.start;
    var lastEnd = _groups[length - 1].end;
    int left;
    if (groupStart == lastEnd + 1) {
      left = length - 1;
    } else if (groupStart > lastEnd) {
      _groups.add(group);
      return;
    } else {
      left = _findNearestIndex(0, length, group.start);
    }

    var groupEnd = group.end;
    var count = 0;
    var newGroups = <GroupedRangeList<E>>[];
    for (var i = left; i < length; i++) {
      var current = _groups[i];
      var start = current.start;
      if (start > groupEnd + 1) {
        break;
      }

      var end = current.end;
      var key = current.key;
      var intersect = current.intersect(group);
      if (intersect) {
        if (start < groupStart) {
          if (_equals(key, groupKey)) {
            group = new GroupedRangeList<E>(start, groupEnd, groupKey);
          } else {
            var newGroup = new GroupedRangeList<E>(start, groupStart - 1, key);
            newGroups.add(newGroup);
          }
        }

        if (end > groupEnd) {
          if (_equals(key, groupKey)) {
            group = new GroupedRangeList<E>(groupStart, end, key);
          } else {
            var newGroup = new GroupedRangeList<E>(groupEnd + 1, end, key);
            newGroups.add(newGroup);
          }
        }
      } else {
        if (_equals(key, groupKey)) {
          if (groupStart == end + 1) {
            group = new GroupedRangeList<E>(start, groupEnd, key);
          } else if (start == groupEnd + 1) {
            group = new GroupedRangeList<E>(groupStart, end, key);
          } else {
            newGroups.add(current);
          }
        } else {
          newGroups.add(current);
        }
      }

      count++;
    }

    newGroups.add(group);
    newGroups.sort((a, b) => a.start.compareTo(b.start));
    _groups.removeRange(left, left + count);
    _groups.insertAll(left, newGroups);
  }
}
