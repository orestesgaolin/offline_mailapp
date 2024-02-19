import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/synchronization/synchronization.dart';

class SyncTasksView extends StatelessWidget {
  const SyncTasksView({
    super.key,
    required this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SyncBloc>().state;
    return ListView.builder(
      controller: scrollController,
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              switch (task.status) {
                SynchronizationTaskStatus.pending =>
                  const Icon(CupertinoIcons.clock),
                SynchronizationTaskStatus.inProgress =>
                  const CupertinoActivityIndicator(),
                SynchronizationTaskStatus.failed =>
                  const Icon(CupertinoIcons.exclamationmark_triangle),
                SynchronizationTaskStatus.completed =>
                  const Icon(CupertinoIcons.checkmark),
                SynchronizationTaskStatus.canceled =>
                  const Icon(CupertinoIcons.xmark),
              },
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${task.name} ${task.entityId} (${task.status.name})'),
                  Text(
                    'Created ${task.createdAt.timeAgo()}, updated ${task.updatedAt.timeAgo()}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on DateTime {
  String timeAgo() {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
