import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argos_home/l10n/app_localizations.dart';

// Entity
import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/views/utils/app_bar.dart' as appbar;

// Widgets
import 'package:argos_home/widgets/search_box.dart' as search_box;

// Views
import 'package:argos_home/views/task/board.dart' as board_view;

// Providers
import 'package:argos_home/providers/board_provider.dart' as provider_board;


class BoardListView extends ConsumerWidget {
  const BoardListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _searchController = TextEditingController();
    final query = _searchController.text.trim();

    final request = const entity_paginator.PaginatorRequest(
      page: 1,
      filters:  {
        "name": "",
      }
    );

    final boardListAsync = ref.watch(
        provider_board.boardListProvider(request)
    );

    return Scaffold(
      appBar: appbar.CustomAppBar(
        title: AppLocalizations.of(context)!.boards,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          search_box.SearchField(
            controller: _searchController,
            labelTextContext: (context) => AppLocalizations.of(context)!.search,
            hintTextContext: (context) => AppLocalizations.of(context)!.search_in_board,
          ),
          Expanded(
            child: boardListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error: $err'),
                    TextButton(
                      onPressed: () => ref.invalidate(provider_board.boardListProvider(request)),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
              data: (entity_paginator.Paginator<entity_board.Board> paginator) {
                if (paginator.total == 0 || paginator.elements.length == 0) {
                  return Center(
                    child: Text(
                        query.isEmpty
                          ? AppLocalizations.of(context)!.not_found_boards
                          : '${AppLocalizations.of(context)!.not_found_boards_with_query} "$query".',
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: paginator.total,
                  itemBuilder: (context, index) {
                    final board = paginator.elements[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const board_view.BoardScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: styles.kAccentColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            board.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    );
                  }
                );
              }
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: styles.kAccentColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.on_building)),
          );
        },
      ),
    );
  }
}