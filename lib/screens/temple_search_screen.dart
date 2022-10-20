// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/http/client.dart';

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
                final year = templeSearchState.record[index].year;
                final month = templeSearchState.record[index].month;
                final day = templeSearchState.record[index].day;
                final date = '$year-$month-$day';

                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(date),
                            ),
                            Expanded(
                              child: getTempleName(
                                data: templeSearchState.record[index].data,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(),
              itemCount: templeSearchState.record.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget getTempleName({required List<TempleData> data}) {
    final list = <Widget>[];
    for (var i = 0; i < data.length; i++) {
      list.add(
        Text(data[i].temple),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: list,
    );
  }
}

///////////////////////////////////////////////////////////////

final templeSearchProvider =
    StateNotifierProvider.autoDispose<TempleSearchNotifier, TempleSearchState>(
        (ref) {
  final client = ref.read(httpClientProvider);

  return TempleSearchNotifier(
    const TempleSearchState(record: []),
    client,
  );
});

class TempleSearchNotifier extends StateNotifier<TempleSearchState> {
  TempleSearchNotifier(TempleSearchState state, this.client) : super(state);

  final HttpClient client;

  ///
  Future<void> getSearchTemple({required String name}) async {
    await client
        .post(path: 'getTempleName', body: {'name': name}).then((value) {
      final list = <SearchData>[];
      for (var i = 0; i < int.parse(value['data'].length.toString()); i++) {
        final list2 = <TempleData>[];
        for (var j = 0;
            j < int.parse(value['data'][i]['data'].length.toString());
            j++) {
          list2.add(
            TempleData(
              temple: value['data'][i]['data'][j]['temple'].toString(),
              address: value['data'][i]['data'][j]['address'].toString(),
              lat: value['data'][i]['data'][j]['lat'].toString(),
              lng: value['data'][i]['data'][j]['lng'].toString(),
            ),
          );
        }

        list.add(
          SearchData(
            year: value['data'][i]['year'].toString(),
            month: value['data'][i]['month'].toString(),
            day: value['data'][i]['day'].toString(),
            data: list2,
          ),
        );
      }

      state = state.copyWith(record: list);
    });
  }
}
