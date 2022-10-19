import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

import '../models/temple_search_model.dart';

import '../state/temple_search_state.dart';

class TempleSearchScreen extends ConsumerWidget {
  const TempleSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templeSearchState = ref.watch(templeSearchProvider);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              ref.watch(templeSearchProvider.notifier).getSearchTemple(
                    name: '日枝',
                  );
            },
            child: const Text('get'),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final date =
                    '${templeSearchState.record.value![index].year}-${templeSearchState.record.value![index].month}-${templeSearchState.record.value![index].day}';

                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(),
              itemCount: templeSearchState.record.value!.length,
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////

final templeSearchProvider =
    StateNotifierProvider.autoDispose<TempleSearchNotifier, TempleSearchState>(
        (ref) {
  return TempleSearchNotifier(
    const TempleSearchState(
      record: AsyncValue<List<SearchData>>.loading(),
    ),
  );
});

class TempleSearchNotifier extends StateNotifier<TempleSearchState> {
  TempleSearchNotifier(TempleSearchState state) : super(state);

  ///
  Future<void> getSearchTemple({required String name}) async {
    const url = 'http://toyohide.work/BrainLog/api/getTempleName';
    final headers = <String, String>{'content-type': 'application/json'};
    final body = json.encode({'name': name});

    final response = await post(Uri.parse(url), headers: headers, body: body);

    final templeSearch = templeSearchFromJson(response.body);

    state = state.copyWith(
      record: AsyncValue.data([...templeSearch.data]),
    );
  }
}
