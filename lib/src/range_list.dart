part of lists;

class RangeList extends Object with ListMixin<int> {
  final int end;

  final int start;

  int _length;

  RangeList(this.start, this.end) {
    if (start == null) {
      throw new ArgumentError("start: $start");
    }

    if (end == null) {
      throw new ArgumentError("end: $end");
    }

    if (start > end) {
      throw new StateError("Start '$start' greater then end '$end'");
    }

    _length = end - start + 1;
  }

  /**
   * Returns the length of list.
   */
  int get length => _length;

  /**
   * Sets the length of list.
   */
  void set length(int length) {
    throw new UnsupportedError("length=");
  }

  int operator [](int index) {
    if (index == null) {
      throw new ArgumentError("index: $index");
    }

    if (index < 0 || index >= _length) {
      if (length == 0) {
        throw new RangeError(index);
      } else {
        throw new RangeError.range(index, 0, _length - 1);
      }
    }

    return start + index;
  }

  void operator []=(int index, int value) {
    throw new UnsupportedError("operator []=");
  }

  /**
   * Returns true if list contains the [value]; otherwise false.
   */
  bool contains(int value) {
    if (value == null || value > end || value < start) {
      return false;
    }

    return true;
  }

  /*
   * Returns the list of elements with specified step.
   */
  StepList step(int step) => new StepList(start, end, step);

  /**
   * Returns the string representation of range.
   */
  String toString() {
    return "[$start..$end]";
  }
}
