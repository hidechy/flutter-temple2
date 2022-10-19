// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_temple2/models/temple_search_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/http/client.dart';
//import '../models/temple_search_model.dart';

import '../state/temple_search_state.dart';

class TempleSearchScreen extends ConsumerWidget {
  const TempleSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templeSearchState = ref.watch(templeSearchProvider);

//    print(templeSearchState);

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
                              child: dispTempleName(
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

  Widget dispTempleName({required List<TempleData> data}) {
//    print(data as List<Map<String, dynamic>>);

    print(data);
    print(data.length);

    return Container();
  }

// Widget dispTempleName({required data}) {
//   print(data);
//
//   return Container();
//
//   // final list = <Widget>[];
//   // for (var i = 0; i < data.length; i++) {
//   //   list.add(Text(data[i].temple));
//   // }
//   //
//   // return Wrap(
//   //   children: list,
//   // );
// }
}

// ///
// Widget dispTempleName({required List<TempleData> data}) {
//   final list = <Widget>[];
//   for (var i = 0; i < data.length; i++) {
//     list.add(Text(data[i].temple));
//   }
//
//   return Wrap(
//     children: list,
//   );
// }
//}

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
    final response = await client.post(
      path: 'getTempleName',
      body: {'name': name},
    ) as Map<String, dynamic>;

//    var data = response['data'] as List<SearchData>;

    List<SearchData> list = [];
    for (var i = 0; i < response['data'].length; i++) {}

    //
    //
    //
    //
    // state = state.copyWith(
    //   record: response['data'] as List<SearchData>,
    // );
    //
    //
    //
    //
  }
}
