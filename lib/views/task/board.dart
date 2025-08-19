import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/views/utils/app_bar.dart' as appbar;

// Entity
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;
import 'package:argos_home/domain/entity/task.dart' as entity_task;

// Providers
import 'package:argos_home/providers/task_provider.dart' as provider_task;


class BoardView extends HookConsumerWidget {
  final String boardId;

  const BoardView({required this.boardId, super.key});

  Color? getColorByPriority(entity_task.PriorityType priority) {
    switch (priority) {
      case entity_task.PriorityType.CRITICAL:
        return Colors.red[800];
      case entity_task.PriorityType.HIGH:
        return Colors.red[300];
      case entity_task.PriorityType.MEDIUM:
        return Colors.amber[400];
      case entity_task.PriorityType.LOW:
        return Colors.grey[400];
      }
  }

  void _showEditDialog(int listIndex, int cardIndex) {

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<entity_task.TaskStatus, List<entity_task.Task>> listData = {
      entity_task.TaskStatus.TODO: [],
      entity_task.TaskStatus.DOING: [],
      entity_task.TaskStatus.DONE: []
    };
    Map<int, entity_task.TaskStatus> listDataIndex = {
      0: entity_task.TaskStatus.TODO,
      1: entity_task.TaskStatus.DOING,
      2: entity_task.TaskStatus.DONE
    };
    final request = useMemoized(() {
      return entity_paginator.PaginatorRequest(
        page: 1,
        filters: {'board_id': boardId},
      );
    }, [boardId]);

    print("request hashcode ${request.hashCode}");

    final taskListAsync = ref.watch(
        provider_task.taskListProvider(request)
    );

    return Scaffold(
      appBar: appbar.CustomAppBar(
        title: "Tus Tableros",
      ),
      body: taskListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error: $err'),
                TextButton(
                  onPressed: () => ref.invalidate(provider_task.taskListProvider(request)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (entity_paginator.Paginator<entity_task.Task> paginator) {
            if (paginator.total == 0 || paginator.elements.length == 0) {
              return Center(child: Text("Task Not Found"));
            }
            for (entity_task.Task task in paginator.elements) {
              if (task.status == entity_task.TaskStatus.TODO) {
                listData[task.status]!.add(task);
              }
              if (task.status == entity_task.TaskStatus.DOING) {
                listData[task.status]!.add(task);
              }
              if (task.status == entity_task.TaskStatus.DONE) {
                listData[task.status]!.add(task);
              }
            }

            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(listData.keys.length, (listIndex) {
                  return DragTarget<Map<String, dynamic>>(
                    onWillAccept: (_) => true,
                    onAccept: (data) {
                      final task = data['task'] as entity_task.Task;
                      final fromList = data['fromList'] as int;
                      final index = data['index'] as int;

                      // setState(() {
                      //   listData[listDataIndex[fromList]]!.removeAt(index);
                      //   listData[listDataIndex[listIndex]]!.add(task);
                      // });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listDataIndex[listIndex]!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(listData[listDataIndex[listIndex]]!.length, (taskIndex) {
                              final task = listData[listDataIndex[listIndex]]![taskIndex];
                              return LongPressDraggable<Map<String, dynamic>>(
                                data: {
                                  'fromList': listIndex,
                                  'index': taskIndex,
                                  'task': task
                                },
                                feedback: Material(
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 260,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(task.name),
                                  ),
                                ),
                                childWhenDragging: const SizedBox.shrink(),
                                child: GestureDetector(
                                  onTap: () => _showEditDialog(listIndex, taskIndex),
                                  child: Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(task.name),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4
                                            ),
                                            decoration: BoxDecoration(
                                              color: getColorByPriority(task.priority),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              task.priority.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                )
                              );
                            }),
                            TextButton.icon(
                              onPressed: () {
                                // setState(() {
                                //   lists[listIndex].add(Tarjeta('Nueva tarjeta', 'MEDIA'));
                                // });
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Añadir tarjeta'),
                            ),
                          ]
                        )
                      );
                    }
                  );
                }),

            ));
          }
        ),
    );
  }
}