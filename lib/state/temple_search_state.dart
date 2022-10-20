import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/temple_search_model.dart';

part 'temple_search_state.freezed.dart';

@freezed
class TempleSearchState with _$TempleSearchState {
  const factory TempleSearchState({
    required List<SearchData> record,
  }) = _TempleSearchState;
}
