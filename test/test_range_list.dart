import "package:lists/lists.dart";
import "package:unittest/unittest.dart";

void main() {
  testContains();
  testIterable();
  testList();
  testReversed();
}

void testContains() {
  var result = list(0, 5).contains(5);
  expect(result, true, reason: "RangeList.contains");
  result = list(0, 5).contains(6);
  expect(result, false, reason: "RangeList.contains");
}

void testIterable() {
  var result = list(0, 5);
  expect(result is Iterable<int>, true, reason: "RangeList is Iterable<int>");
  var length = result.length;
  var i = result.start;
  for (var value in result) {
    expect(value, i++, reason: "RangeList.current");
  }
}

void testList() {
  var result = list(0, 5);
  expect(result is List<int>, true, reason: "RangeList is List<int>");
  var length = result.length;
  for (var i = 0; i < length; i++) {
    expect(result[i], i, reason: "RangeList[$i]");
  }
}

void testReversed() {
  var result = list(-1, 1).reversed;
  expect(result, [1, 0, -1], reason: "RangeList.reversed");
}

RangeList list(int start, int end) => new RangeList(start, end);
