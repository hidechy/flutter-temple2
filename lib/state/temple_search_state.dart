import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/temple_search_model.dart';

part 'temple_search_state.freezed.dart';

@freezed
class TempleSearchState with _$TempleSearchState {
  const factory TempleSearchState({
    required AsyncValue<List<SearchData>> record,
  }) = _TempleSearchState;
}
