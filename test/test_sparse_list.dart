import "package:lists/lists.dart";
import "package:unittest/unittest.dart";

void main() {
  testAdd();
  testClear();
  testGetGroups();
  testLength();
  testRemoveValues();
  testResetValues();
  testSetDifferent();
  testSetTheSame();
  testSetWithStep();
  testsetGroupDifferent();
  testSetGroupTheSame();
  testStartAndEnd();
}

void testAdd() {
  var subject = "SparseList.addGroup()";
  //
  var sparse = new SparseList<int>();
  sparse.addGroup(grp(1, 3, 1));
  var actual = sparse;
  expect(actual, [null, 1, 1, 1], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  var length = sparse.length;
  expect(length, 4, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.addGroup(grp(1, 3, null));
  actual = sparse;
  expect(actual, [null, null, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  length = sparse.length;
  expect(length, 4, reason: subject);
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
}

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

void testRemoveValues() {
  var subject = "SparseList.removeValues()";
  var sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(0, 2));
  var actual = sparse;
  expect(actual, [], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  //
  sparse = new SparseList<int>();
  sparse.length = 3;
  sparse.setGroup(grp(0, 2, 1));
  sparse.removeValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
}

void testResetValues() {
  var subject = "SparseList.resetValues()";
  /*
   * -
   * -
   */
  var sparse = new SparseList<int>(length: 1);
  sparse[0] = 1;
  sparse.resetValues(rng(0, 0));
  var actual = sparse;
  expect(actual, [null], reason: subject);
  var groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  /*
   * --
   * -
   */
  sparse = new SparseList<int>(length: 2);
  sparse[0] = 1;
  sparse[1] = 1;
  sparse.resetValues(rng(0, 0));
  actual = sparse;
  expect(actual, [null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * -
   * --
   */
  sparse = new SparseList<int>(length: 2);
  sparse[0] = 1;
  sparse.resetValues(rng(0, 1));
  actual = sparse;
  groupCount = sparse.groupCount;
  expect(actual, [null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 0, reason: subject);
  /*
   * -
   *  -
   */
  sparse = new SparseList<int>(length: 2);
  sparse[0] = 1;
  sparse.resetValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * --
   *  -
   */
  sparse = new SparseList<int>(length: 2);
  sparse[0] = 1;
  sparse[1] = 1;
  sparse.resetValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  -
   */
  sparse = new SparseList<int>(length: 3);
  sparse[0] = 1;
  sparse[1] = 1;
  sparse[2] = 1;
  sparse.resetValues(rng(1, 1));
  actual = sparse;
  expect(actual, [1, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
  /*
   * ---
   *  --
   */
  sparse = new SparseList<int>(length: 3);
  sparse[0] = 1;
  sparse[1] = 1;
  sparse[2] = 1;
  sparse.resetValues(rng(1, 2));
  actual = sparse;
  expect(actual, [1, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * ---
   *  ---
   */
  sparse = new SparseList<int>(length: 4);
  sparse[0] = 1;
  sparse[1] = 1;
  sparse[2] = 1;
  sparse.resetValues(rng(1, 3));
  actual = sparse;
  expect(actual, [1, null, null, null], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 1, reason: subject);
  /*
   * - - -
   *  ---
   */
  sparse = new SparseList<int>(length: 5);
  sparse[0] = 1;
  sparse[2] = 1;
  sparse[4] = 1;
  sparse.resetValues(rng(1, 3));
  actual = sparse;
  expect(actual, [1, null, null, null, 1], reason: subject);
  groupCount = sparse.groupCount;
  expect(groupCount, 2, reason: subject);
}

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

GroupedRangeList grp(int start, int end, dynamic value) {
  return new GroupedRangeList(start, end, value);
}

RangeList rng(int start, int end) {
  return new RangeList(start, end);
}
