import "package:lists/lists.dart";
import "package:unittest/unittest.dart";

void main() {
  testContent();
  testModify();
}

void testContent() {
  var result = list([0, 1, 2, 3, 4, 5]);
  expect(result, [0, 1, 2, 3, 4, 5], reason: "WrappedList");
}

void testModify() {
  var result = false;
  try {
    var l = list([0, 1, 2]);
    l[0] = 0;
  } on UnsupportedError catch (e) {
    result = true;
  }

  expect(result, true, reason: "WrappedList");

  result = false;
  try {
    var l = list([0, 1, 2]);
    l.length = 0;
  } on UnsupportedError catch (e) {
    result = true;
  }

  expect(result, true, reason: "WrappedList");
}

WrappedList list(List source) => new WrappedList(source);
