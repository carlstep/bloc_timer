import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  /*
  define the initial state of our TimerBloc. In this case, 
  we want the TimerBloc to start off in the TimerInitial 
  state with a preset duration of 1 minute (60 seconds).
  */
  static const int _duration = 60;

  // This variable will hold a reference to the Ticker instance that will be used to generate ticks.
  final Ticker _ticker;

  // This variable will hold a reference to the subscription to the Ticker's stream, allowing
  // the TimerBloc to listen for ticks.
  StreamSubscription<int>? _tickerSubscription;

  // Defines the constructor for the TimerBloc class.
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(_duration)) {
    // Event Handler - TimerStarted event...
    on<TimerStarted>(_onStarted);

    // Event Handler - TimerPaused event...
    on<TimerPaused>(_onPaused);

    // Event Handler - TimerResumed event...
    on<TimerResumed>(_onResumed);

    // Event Handler - TimerReset event...
    on<TimerReset>(_onReset);

    // Event Handler - TimerTicked event...
    on<_TimerTicked>(_onTicked);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  /*
  If the TimerBloc receives a TimerStarted event, it pushes a 
  TimerRunInProgress state with the start duration. In addition, 
  if there was already an open _tickerSubscription we need to 
  cancel it to deallocate the memory. We also need to override 
  the close method on our TimerBloc so that we can cancel the 
  _tickerSubscription when the TimerBloc is closed. Lastly, we 
  listen to the _ticker.tick stream and on every tick we add a 
  _TimerTicked event with the remaining duration.
  */

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(_TimerTicked(duration: duration)));
  }

  /*
  In _onPaused if the state of our TimerBloc is TimerRunInProgress, 
  then we can pause the _tickerSubscription and push a TimerRunPause 
  state with the current timer duration.
  */

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  /*
  The TimerResumed event handler is very similar to the TimerPaused 
  event handler. If the TimerBloc has a state of TimerRunPause and 
  it receives a TimerResumed event, then it resumes the 
  _tickerSubscription and pushes a TimerRunInProgress state with 
  the current duration.
  */

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  /*
  If the TimerBloc receives a TimerReset event, it needs to cancel 
  the current _tickerSubscription so that it isn’t notified of any 
  additional ticks and pushes a TimerInitial state with the original 
  duration.
  */

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  /*
  Every time a _TimerTicked event is received, if the tick’s 
  duration is greater than 0, we need to push an updated 
  TimerRunInProgress state with the new duration. Otherwise, 
  if the tick’s duration is 0, our timer has ended and we need 
  to push a TimerRunComplete state.
  */
  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0 // This is a countdown timer
          // if greater the 0, do this...
          ? TimerRunInProgress(event.duration)
          // if at 0, do this...
          : TimerRunComplete(),
    );
  }
}
