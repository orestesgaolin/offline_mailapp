import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<Event> sequential<Event>() {
  return (events, mapper) => events.asyncExpand(mapper);
}

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc(this.storage) : super(const SyncInitial([])) {
    on<ProcessEmail>(
      (event, emit) async => await _processEmail(event, emit),
      transformer: sequential(),
    );
    on<TasksUpdated>(onTasksUpdated);

    _syncTaskSubImmediate =
        storage.watchAll<SynchronizationTask>().listen((event) {
      // iterate through tasks
      // find ones with status == SynchronizationStatus.pending
      // if found, emit SyncInProgress
      // and delegate the action that is linked with the task
      add(TasksUpdated(event));
    });

    // TODO(dominik): 3. Listen to synchronization tasks and process them
    // with debouncing
    // Make sure they are in pending or failed state

    // _syncTaskSub =
  }

  FutureOr<void> onTasksUpdated(TasksUpdated event, Emitter<SyncState> emit) {
    // if the previous state is empty and new one is not, we want to
    // reset states of the inProgress tasks to failed
    // as this may indicate they haven't been processed in the previous run
    if (state.tasks.isEmpty && event.tasks.isNotEmpty) {
      for (final task in event.tasks) {
        if (task.status == SynchronizationTaskStatus.inProgress) {
          storage.save<SynchronizationTask>(
            task.id,
            task.copyWith(
              status: SynchronizationTaskStatus.failed,
              updatedAt: DateTime.now(),
            ),
          );
        }
      }
    }

    emit(state.copyWith(tasks: event.tasks));
  }

  final Storage storage;
  StreamSubscription<List<SynchronizationTask>>? _syncTaskSub;
  StreamSubscription<List<SynchronizationTask>>? _syncTaskSubImmediate;

  Future<void> _processEmail(
      ProcessEmail event, Emitter<SyncState> emit) async {
    try {
      // Normally this would be delegated to other service e.g. repository

      // TODO(dominik): 4. Send the email

      // 1. Get email and task from storage
      // 2. Update the state to SyncInProgress and sending
      // 3. Update the task to indicate that it's in progress
      // 4. Send the email
      // 5. Update the email
      // 6. Update the task to indicate that it's completed

      emit(SyncInitial(state.tasks));
    } catch (e) {
      // If there's an error, update the task to indicate that it's failed

      // TODO(dominik): 5. Handle failure to send the email

      emit(SyncInitial(state.tasks));
    }
  }

  @override
  Future<void> close() {
    _syncTaskSub?.cancel();
    _syncTaskSubImmediate?.cancel();
    return super.close();
  }
}

// Events

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object> get props => [];
}

final class ProcessEmail extends SyncEvent {
  const ProcessEmail(this.task);

  final SynchronizationTask task;

  @override
  List<Object> get props => [task];
}

final class TasksUpdated extends SyncEvent {
  const TasksUpdated(this.tasks);

  final List<SynchronizationTask> tasks;

  @override
  List<Object> get props => [tasks];
}

// States

sealed class SyncState extends Equatable {
  const SyncState(this.tasks);

  final List<SynchronizationTask> tasks;

  @override
  List<Object> get props => [tasks];

  SyncState copyWith({
    List<SynchronizationTask>? tasks,
  });
}

final class SyncInitial extends SyncState {
  const SyncInitial(super.tasks);

  @override
  SyncState copyWith({
    List<SynchronizationTask>? tasks,
  }) {
    return SyncInitial(tasks ?? super.tasks);
  }
}

final class SyncInProgress extends SyncState {
  const SyncInProgress(super.tasks);

  @override
  SyncState copyWith({
    List<SynchronizationTask>? tasks,
  }) {
    return SyncInProgress(tasks ?? super.tasks);
  }
}

// _syncTaskSub = storage
//         .watchAll<SynchronizationTask>()
//         .debounceTime(const Duration(seconds: 5))
//         .listen((event) {
//       // iterate through tasks
//       // find ones with status == SynchronizationStatus.pending/failed
//       // if found, emit SyncInProgress
//       // and delegate the action that is linked with the task
//       for (final task in event.reversed) {
//         if (task.status == SynchronizationTaskStatus.pending ||
//             task.status == SynchronizationTaskStatus.failed) {
//           if (task.table == SynchronizationTaskTable.email) {
//             add(ProcessEmail(task));
//           }
//         }
//       }
// });

//       final email = await storage.read<Email>(event.task.entityId);
//       if (email == null) return;

//       final task = await storage.read<SynchronizationTask>(event.task.id);
//       if (task == null) return;

//       if (task.status != SynchronizationTaskStatus.pending &&
//           task.status != SynchronizationTaskStatus.failed) return;

//       // Update task to indicate that it's in progress
//       await storage.save<SynchronizationTask>(
//         task.id,
//         task.copyWith(
//           status: SynchronizationTaskStatus.inProgress,
//           updatedAt: DateTime.now(),
//         ),
//       );
//       emit(SyncInProgress(state.tasks));

//       // Update email
//       await storage.save<Email>(
//         email.id,
//         email.copyWith(
//           status: EmailStatus.sending,
//           updatedAt: DateTime.now(),
//         ),
//       );
//       await Future.delayed(const Duration(seconds: 5));
//       // fail randomly
//       if (DateTime.now().second % 3 == 0) {
//         throw Exception('Failed to send email');
//       }

//       // Update email
//       await storage.save<Email>(
//         email.id,
//         email.copyWith(
//           status: EmailStatus.sent,
//           updatedAt: DateTime.now(),
//         ),
//       );

//       // Update task to indicate that it's completed
//       await storage.save<SynchronizationTask>(
//         event.task.id,
//         event.task.copyWith(
//           status: SynchronizationTaskStatus.completed,
//           updatedAt: DateTime.now(),
//         ),
//       );

// await storage.save<SynchronizationTask>(
//   event.task.id,
//   event.task.copyWith(
//     status: SynchronizationTaskStatus.failed,
//     updatedAt: DateTime.now(),
//   ),
// );
// await storage.save<Email>(
//   event.task.entityId,
//   (await storage.read<Email>(event.task.entityId))!.copyWith(
//     status: EmailStatus.pendingSending,
//     updatedAt: DateTime.now(),
//   ),
// );
