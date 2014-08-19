## 0.0.9

- Added method `getIndexes() => Iterable<int> ` to `SparseList<E>`

## 0.0.8

- Added field `groups => List<GroupedRangeList<E>>` to `SparseList<E>`

## 0.0.7

- Added field `end => int` to `SparseList<E>` 
- Added field `start => int` to `SparseList<E>`

## 0.0.6

- Added class `SparseBoolList`
- Modified method in `SparseList<E>` from `getGroups(RangeList range)` to `getGroups([RangeList range])`

## 0.0.5

- Improved (up to 15%) the performance of the `SparseList.addGroup()` when the group added to the end

## 0.0.4

- Added class `GroupedRangeList<E>`
- Added class `SparseList<E>`
- Added method `includes(RangeList other) => bool` to `RangeList`
- Added method `intersection(RangeList other) => RangeList` to `RangeList`
- Added method `subtract(RangeList other) => List<RangeList>` to `RangeList`
- Added operator `+(RangeList other) => RangeList` to `RangeList`

