import "package:lists/lists.dart";

void main() {
  bitList();
  filledList();
  rangeList();
  stepList();
  wrappedList();
}

void bitList() {
  // The bit state list with 65536 elements
  // Real size of the list (in memory) 30 times less
  // Exact size 2185 elements of 'Smi' values
  var list = new BitList(65536);
  list.set(32767);
  print(list.get(32767));

  // The list with 65536 elements set to true
  list = new BitList(65536, true);
  print(list.get(32767));

  // The list with 1073741824 elements
  list = new BitList(1073741824);
}

void filledList() {
  // The read only list with 40 values of "="
  var list = new FilledList<String>(40, "=");
  print("${list.join()}");

  // The list with 10000000000000 values of "hello"
  list = new FilledList<String>(10000000000000, "hello");
}

void wrappedList() {
  // The read only wrapper for list
  var source = [0, 1, 2, 3];
  var list = new WrappedList<int>(source);
  try {
    list[0] = 0;
  } catch (e, s) {
    print("$e");
  }

  try {
    list.length = 0;
  } catch (e, s) {
    print("$e");
  }
}

void rangeList() {
  // The values from 0 to 10
  var list = new RangeList(0, 10);
  print("${list.join(", ")}");

  // The same values in reversed order
  var reversed = list.reversed;
  print("${reversed.join(", ")}");

  // The same list with step 2
  var list2 = list.step(2);
  print("${list2.join(", ")}");

  //  The values from -10000000000000 to 10000000000000
  list = new RangeList(10000000000000, 10000000000000);
}

void stepList() {
  // The values from 0 to 10
  var list = new StepList(0, 10);
  print("${list.join(", ")}");

  // The values from 10 to 0
  list = new StepList(10, 0);
  print("${list.join(", ")}");

  // The values from 0 to 10 with step 2
  list = new StepList(0, 10, 2);
  print("${list.join(", ")}");

  // The values from 10 to 0 with step -2
  list = new StepList(10, 0, -2);
  print("${list.join(", ")}");

  // The values from 0 to 255 with step 64
  const MIN_BYTE = 0;
  const MAX_BYTE = 255;
  list = new StepList(MIN_BYTE, MAX_BYTE, (MAX_BYTE >> 2) + 1);
  print("${list.join(", ")}");

  // The values from -10000000000000 to 10000000000000 with step 1
  list = new StepList(-10000000000000, 10000000000000);
}
