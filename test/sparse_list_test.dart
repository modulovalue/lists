import "package:lists/lists.dart";
import "package:test/test.dart";

const int FAILURE = 13;

const int SUCCESS = 41;

void main() {
  test('', () {
    testAddGroup();
    testClear();
    testGetAllSpace();
    testGetAlignedGroups();
    testGetGroups();
    testGetIndexes();
    testLength();
    testRemoveValues();
    testResetValues();
    testSetDifferent();
    testSetTheSame();
    testSetWithStep();
    testsetGroupDifferent();
    testSetGroupTheSame();
    testStartAndEnd();
    testTrim();
  });
}

void testAddGroup() {
  var subject = "SparseList.AddGroup()";
  var depth = 5;
  void action(List<bool> first, List<bool> second) {
    var sparse = new SparseList<int>();
    var ranges = _patternToRanges(first);
    // Add group
    for (var range in ranges) {
      sparse.addGroup(grp(range.start, range.end, SUCCESS));
    }

    // Test group count
    var groupCount = sparse.groupCount;
    expect(groupCount, ranges.length, reason: subject);

    // Test groups
    for (var i = 0; i < groupCount; i++) {
      var group = sparse.groups[i];
      var range = ranges[i];
      expect(group.start, range.start, reason: subject);
      expect(group.end, range.end, reason: subject);
    }

    // Test length
    var length = patternLength(first);
    expect(length, sparse.length, reason: subject);

    // Test values
    for (var i = 0; i < first.length; i++) {
      if (first[i]) {
        expect(sparse[i], SUCCESS, reason: subject);
      }
    }
  }

  _walk(depth, action);
}

void testClear() {
  var subject = "SparseList.clear()";
  //
  var sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.clear();
  var actual = sparse;
  expect(actual, [], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
}

// TODO: Rewrite with walker
void testGetAllSpace() {
  var subject = "SparseList.testAllSpace()";
  var sparse = new SparseList<int>(defaultValue: FAILURE);
  sparse.length = 10;
  sparse.addGroup(grp(2, 3, SUCCESS));
  sparse.addGroup(grp(7, 8, SUCCESS));
  var space = sparse.getAllSpace(rng(0, 10));
  expect(space, [[0, 1], [2, 3], [4, 5, 6], [7, 8], [9, 10]], reason: subject);
}

void testGetAlignedGroups() {
  var subject = "SparseList.testGetAlignedGroups()";
  var depth = 5;
  void action(List<bool> first, List<bool> second) {
    var sparse = new SparseList<int>(defaultValue: FAILURE);
    var ranges = _patternToRanges(first);
    // Add group
    for (var range in ranges) {
      sparse.addGroup(grp(range.start, range.end, SUCCESS));
    }

    ranges = _patternToRanges(second);
    for (var range in ranges) {
      var groups = sparse.getAlignedGroups(range);
      var min = -1;
      var max = -1;
      var start = -1;
      var end = -1;
      for (var group in groups) {
        if (min == -1) {
          min = range.start;
        } else if (min > range.start) {
          min = range.start;
        }

        if (max == -1) {
          max = range.end;
        } else if (max < range.end) {
          max = range.end;
        }

        if (start == -1) {
          start = group.start;
        } else if (start > group.start) {
          start = group.start;
        }

        if (end == -1) {
          end = group.end;
        } else if (end < group.end) {
          end = group.end;
        }

        var indexes = sparse.getIndexes().toList();
        if (indexes.length == 0) {
          // Sparse list is empty
          expect(group.key, FAILURE, reason: subject);
        } else {
          // Sparse list is not empty
          var listStart = indexes.first;
          var listEnd = indexes.last;
          //
          if (group.start < listStart) {
            expect(group.key, FAILURE, reason: subject);
          }

          if (group.start >= listStart && group.start <= listStart) {
            expect(group.key, SUCCESS, reason: subject);
          }

          if (group.start > listEnd) {
            expect(group.key, FAILURE, reason: subject);
          }
        }
      }

      // Test alignment in specified range
      expect(start, min, reason: subject);
      expect(end, max, reason: subject);
    }
  }

  _walk(depth, action);
}

// TODO: Rewrite with walker
void testGetGroups() {
  var subject = "SparseList.getGroups()";
  //
  var sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 0, 1));
  sparse.addGroup(grp(2, 2, 1));
  sparse.addGroup(grp(4, 4, 1));
  var groups = sparse.getGroups(rng(0, 4)).toList();
  var actual = groups;
  expect(actual, [[0], [2], [4]], reason: subject);
  //
  groups = sparse.getGroups(rng(0, 0)).toList();
  actual = groups;
  expect(actual, [[0]], reason: subject);
  //
  groups = sparse.getGroups(rng(0, 2)).toList();
  actual = groups;
  expect(actual, [[0], [2]], reason: subject);
  //
  groups = sparse.getGroups(rng(2, 2)).toList();
  actual = groups;
  expect(actual, [[2]], reason: subject);
  //
  groups = sparse.getGroups(rng(2, 4)).toList();
  actual = groups;
  expect(actual, [[2], [4]], reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  groups = sparse.getGroups(rng(1, 1)).toList();
  actual = groups;
  expect(actual, [[0, 1, 2]], reason: subject);
  // Get all groups
  sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  groups = sparse.getGroups().toList();
  actual = groups;
  expect(actual, [[0, 1, 2]], reason: subject);
  // From empty list
  sparse = new SparseList<int>();
  groups = sparse.getGroups(rng(0, 0)).toList();
  actual = groups;
  expect(actual, [], reason: subject);
  // From empty list
  sparse = new SparseList<int>();
  groups = sparse.getGroups(rng(1, 2)).toList();
  actual = groups;
  expect(actual, [], reason: subject);
}

// TODO: Rewrite with walker
void testGetIndexes() {
  var subject = "SparseList.getIndexes()";
  //
  var sparse = new SparseList<int>();
  sparse.addGroup(grp(2, 4, 1));
  var actual = sparse.getIndexes();
  expect(actual, [2, 3, 4], reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(2, 4, 1));
  sparse.addGroup(grp(6, 8, 1));
  actual = sparse.getIndexes();
  expect(actual, [2, 3, 4, 6, 7, 8], reason: subject);
}

// TODO: Rewrite with walker
void testLength() {
  var subject = "SparseList.length=";
  //
  var sparse = new SparseList<int>();
  sparse.length = 10;
  sparse.setGroup(grp(0, 9, 1));
  sparse.length = 3;
  var actual = sparse;
  expect(actual, [1, 1, 1], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.add(1);
  sparse.length = 3;
  actual = sparse;
  expect(actual, [1, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
}

// TODO: Rewrite with walker
void testRemoveValues() {
  var subject = "SparseList.removeValues()";
  var sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(0, 2));
  var actual = sparse;
  expect(actual, [], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  var actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(0, 2));
  actual = sparse;
  expect(actual, [], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(0, 1));
  actual = sparse;
  expect(actual, [], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(0, 2, 1));
  sparse.removeValues(rng(0, 1));
  actual = sparse;
  expect(actual, [null, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
  // Out of bounds
  sparse = new SparseList<int>();
  sparse.length = 5;
  sparse.setGroup(grp(2, 4, 1));
  sparse.removeValues(rng(0, 5));
  actual = sparse;
  expect(actual, [], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  // Out of bounds
  sparse = new SparseList<int>();
  sparse.length = 5;
  sparse.setGroup(grp(0, 1, 1));
  sparse.setGroup(grp(3, 4, 1));
  sparse.removeValues(rng(0, 5));
  actual = sparse;
  expect(actual, [], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 0, reason: subject);
  // Descrease length
  sparse = new SparseList<int>();
  sparse.length = 2;
  sparse[1] = 1;
  sparse.removeValues(rng(4, 6));
  actual = sparse;
  expect(actual, [null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 2, reason: subject);
  // After last
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(5, 7));
  actual = sparse;
  expect(actual, [null, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  actualLength = sparse.length;
  expect(actualLength, 3, reason: subject);
}

void testResetValues() {
  var subject = "SparseList.resetValues()";
  var depth = 5;
  void action(List<bool> first, List<bool> second) {
    var sparse = new SparseList<int>(length: depth);
    // Set values
    for (var i = 0; i < depth; i++) {
      if (first[i]) {
        sparse[i] = 1;
      }
    }

    var ranges = _patternToRanges(second);
    // Reset values
    for (var range in ranges) {
      sparse.resetValues(range);
    }

    // Test values
    for (var range in ranges) {
      for (var i = range.start; i <= range.end; i++) {
        var actual = sparse[i];
        expect(actual, null, reason: subject);
      }
    }
  }

  _walk(depth, action);
}

// TODO: Rewrite with walker
void testSetDifferent() {
  var subject = "SparseList.[]";
  /*
   * -
   * -
   */
  var sparse = new SparseList<String>(length: 1);
  sparse[0] = "1";
  sparse[0] = "2";
  var actual = sparse;
  expect(actual, ["2"], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = new SparseList<String>(length: 2);
  sparse[0] = "1";
  sparse[1] = "1";
  sparse[0] = "2";
  actual = sparse;
  expect(actual, ["2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * -
   * --
   */
  sparse = new SparseList<String>(length: 2);
  sparse[0] = "1";
  sparse[0] = "2";
  sparse[1] = "2";
  actual = sparse;
  expect(actual, ["2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse[0] = "1";
  sparse[1] = "2";
  actual = sparse;
  expect(actual, ["1", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * --
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse[0] = "1";
  sparse[1] = "1";
  sparse[1] = "2";
  actual = sparse;
  expect(actual, ["1", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = new SparseList<String>(length: 3);
  sparse[0] = "1";
  sparse[1] = "1";
  sparse[2] = "1";
  sparse[1] = "2";
  actual = sparse;
  expect(actual, ["1", "2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = new SparseList<String>(length: 3);
  sparse[0] = "1";
  sparse[1] = "1";
  sparse[2] = "1";
  sparse[1] = "2";
  sparse[2] = "2";
  actual = sparse;
  expect(actual, ["1", "2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = new SparseList<String>(length: 4);
  sparse[0] = "1";
  sparse[1] = "1";
  sparse[2] = "1";
  sparse[1] = "2";
  sparse[2] = "2";
  sparse[3] = "2";
  actual = sparse;
  expect(actual, ["1", "2", "2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * - - -
   *  ---
   */
  sparse = new SparseList<String>(length: 5);
  sparse[0] = "1";
  sparse[2] = "1";
  sparse[4] = "1";
  sparse[1] = "2";
  sparse[2] = "2";
  sparse[3] = "2";
  actual = sparse;
  expect(actual, ["1", "2", "2", "2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
}

// TODO: Rewrite with walker
void testSetTheSame() {
  var subject = "SparseList.[]";
  /*
   * -
   * -
   */
  var sparse = new SparseList<String>(length: 1);
  sparse[0] = "1";
  var actual = sparse;
  expect(actual, ["1"], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = new SparseList<String>(length: 2);
  sparse[0] = "1";
  actual = sparse;
  expect(actual, ["1", null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse[1] = "1";
  actual = sparse;
  expect(actual, [null, "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = new SparseList<String>(length: 3);
  sparse[1] = "1";
  actual = sparse;
  expect(actual, [null, "1", null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = new SparseList<String>(length: 3);
  sparse[1] = "1";
  sparse[2] = "1";
  actual = sparse;
  expect(actual, [null, "1", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = new SparseList<String>(length: 4);
  sparse[1] = "1";
  sparse[2] = "1";
  sparse[3] = "1";
  actual = sparse;
  expect(actual, [null, "1", "1", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
}

void testSetWithStep() {
  var count = 10000;
  var maxStep = count;
  for (var step = 1; step < maxStep; step++) {
    var sparseList = new SparseList(length: count);
    var stepList = new StepList(0, count - 1, step);
    for (var i in stepList) {
      sparseList[i] = true;
      expect(true, sparseList[i], reason: "SparseList[]");
    }
  }
}

// TODO: Rewrite with walker
void testsetGroupDifferent() {
  var subject = "SparseList.setGroup()";
  /*
   * -
   * -
   */
  var sparse = new SparseList<String>(length: 1);
  sparse.setGroup(grp(0, 0, "1"));
  sparse.setGroup(grp(0, 0, "2"));
  var actual = sparse;
  expect(actual, ["2"], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   * -
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(0, 1, "1"));
  sparse.setGroup(grp(0, 0, "2"));
  actual = sparse;
  expect(actual, ["2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * -
   * --
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(0, 0, "1"));
  sparse.setGroup(grp(0, 1, "2"));
  actual = sparse;
  expect(actual, ["2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(0, 0, "1"));
  sparse.setGroup(grp(1, 1, "2"));
  actual = sparse;
  expect(actual, ["1", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * --
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(0, 1, "1"));
  sparse.setGroup(grp(1, 1, "2"));
  actual = sparse;
  expect(actual, ["1", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = new SparseList<String>(length: 3);
  sparse.setGroup(grp(0, 2, "1"));
  sparse.setGroup(grp(1, 1, "2"));
  actual = sparse;
  expect(actual, ["1", "2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = new SparseList<String>(length: 3);
  sparse.setGroup(grp(0, 2, "1"));
  sparse.setGroup(grp(1, 2, "2"));
  actual = sparse;
  expect(actual, ["1", "2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = new SparseList<String>(length: 4);
  sparse.setGroup(grp(0, 2, "1"));
  sparse.setGroup(grp(1, 3, "2"));
  actual = sparse;
  expect(actual, ["1", "2", "2", "2"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * - - -
   *  ---
   */
  sparse = new SparseList<String>(length: 5);
  sparse.setGroup(grp(0, 4, "1"));
  sparse.setGroup(grp(1, 3, "2"));
  actual = sparse;
  expect(actual, ["1", "2", "2", "2", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 3, reason: subject);
}

// TODO: Rewrite with walker
void testSetGroupTheSame() {
  var subject = "SparseList.setGroup()";
  /*
   * -
   * -
   */
  var sparse = new SparseList<String>(length: 1);
  sparse.setGroup(grp(0, 0, "1"));
  var actual = sparse;
  expect(actual, ["1"], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   *
   */
  sparse = new SparseList<String>(length: 1);
  actual = sparse;
  expect(actual, [null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  /*
   * --
   * -
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(0, 0, "1"));
  actual = sparse;
  expect(actual, ["1", null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   *  -
   */
  sparse = new SparseList<String>(length: 2);
  sparse.setGroup(grp(1, 1, "1"));
  actual = sparse;
  expect(actual, [null, "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = new SparseList<String>(length: 3);
  sparse.setGroup(grp(1, 1, "1"));
  actual = sparse;
  expect(actual, [null, "1", null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = new SparseList<String>(length: 3);
  sparse.setGroup(grp(1, 2, "1"));
  actual = sparse;
  expect(actual, [null, "1", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = new SparseList<String>(length: 4);
  sparse.setGroup(grp(1, 3, "1"));
  actual = sparse;
  expect(actual, [null, "1", "1", "1"], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
}

void testStartAndEnd() {
  var sparse = new SparseList<int>();
  var actual = sparse.start;
  expect(actual, null, reason: "Sparse.start");
  actual = sparse.end;
  expect(actual, null, reason: "Sparse.end");
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(1, 3, 1));
  actual = sparse.start;
  expect(actual, 1, reason: "Sparse.start");
  actual = sparse.end;
  expect(actual, 3, reason: "Sparse.end");
}

void testTrim() {
  var subject = "SparseList.addGroup()";
  //
  var sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.trim();
  var actual = sparse;
  expect(actual, [], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  var length = sparse.length;
  expect(length, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse[0] = 1;
  sparse.trim();
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  length = sparse.length;
  expect(length, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse[2] = 1;
  sparse.trim();
  actual = sparse;
  expect(actual, [null, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  length = sparse.length;
  expect(length, 3, reason: subject);
}

List<int> flatten1(SparseList list) {
  var groups = list.getGroups(new RangeList(0, list.length));
  return groups.fold(<int>[], (List<int> p, GroupedRangeList c) {
    p.add(c.start);
    p.add(c.end);
    return p;
  });
}

List<int> flatten2(SparseList list) {
  var groups = list.getGroups(new RangeList(0, list.length));
  return groups.fold([], (List p, GroupedRangeList c) {
    p.add(c.start);
    p.add(c.end);
    p.add(c.key);
    return p;
  });
}

int patternLength(List<bool> pattern) {
  var length = 0;
  for (var i = 0; i < pattern.length; i++) {
    if (pattern[i]) {
      length = i + 1;
    }
  }

  return length;
}

List<RangeList> _patternToRanges(List<bool> pattern) {
  var ranges = [];
  var length = pattern.length;
  int start;
  for (var i = 0; i < length; i++) {
    if (!pattern[i]) {
      if (start != null) {
        ranges.add(rng(start, i - 1));
        start = null;
      }
    } else {
      if (start == null) {
        start = i;
      }
    }
  }

  if (start != null) {
    ranges.add(rng(start, length - 1));
  }

  return ranges;
}

void _walk(int depth, action(List<bool> first, List<bool> second)) {
  var count = 1 << depth;
  for (var i = 0; i < count; i++) {
    var first = new List<bool>.filled(depth, false);
    var flag = i;
    for (var bit = 0; bit < depth; bit++) {
      if (flag & 1 != 0) {
        first[bit] = true;
      }

      flag >>= 1;
    }

    for (var j = 0; j < count; j++) {
      var second = new List<bool>.filled(depth, false);
      var flag = j;
      for (var bit = 0; bit < depth; bit++) {
        if (flag & 1 != 0) {
          second[bit] = true;
        }

        flag >>= 1;
      }

      action(first, second);
    }
  }
}

GroupedRangeList<T> grp<T>(int start, int end, T value) {
  return new GroupedRangeList<T>(start, end, value);
}

RangeList rng(int start, int end) {
  return new RangeList(start, end);
}
