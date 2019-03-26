import "package:lists/lists.dart";
import "package:test/test.dart";

void main() {
  test('', () {
    testContent();
  });
}

FilledList list(int length, dynamic fill) => new FilledList(length, fill);

void testContent() {
  var result = list(5, "1");
  expect(result, ["1", "1", "1", "1", "1"], reason: "FilledList");
}
