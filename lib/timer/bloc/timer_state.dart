// STATES

/*
- The TimerState class is defined as a sealed class, meaning it can only be extended by the classes listed within it.
- By mixing in Equatable, the TimerState class ensures that instances of its subclasses can be compared based on their duration property.
- This is important for the Bloc to determine if a new state is different from the previous state and trigger a rebuild of the UI. 

*/

part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  final int duration;

  const TimerState(
    this.duration,
  );

  @override
  List<Object> get props => [duration];
}

// if the state is TimerInitial, the user will be able to start the timer.
final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

// if the state is TimerRunInProgress the user will be able to pause and
// reset the timer as well as see the remaining duration.
final class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

// if the state is TimerRunPause the user will be able to resume the timer and reset the timer.
final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

// if the state is TimerRunComplete the user will be able to reset the timer.
final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}


/*
Note that all of the TimerStates extend the sealed base class 
TimerState which has a duration property. This is because no matter 
what state our TimerBloc is in, we want to know how much time is 
remaining. Additionally, TimerState extends Equatable to optimize 
our code by ensuring that our app does not trigger rebuilds if the 
same state occurs.

*/