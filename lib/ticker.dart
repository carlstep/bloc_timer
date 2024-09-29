// ticker will be the data source for the timer app.
// the ticker class is a function, it takes the number of ticks (seconds) we want,
// and returns a STREAM, this STREAM emits the remaining seconds, every second.
// it will expose a STREAM of ticks which we can subscribe to and react to.

class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
