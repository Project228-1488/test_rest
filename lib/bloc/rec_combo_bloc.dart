import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_rest/model/rec_combo.dart';

part 'rec_combo_event.dart';

part 'rec_combo_state.dart';

class RecComboBloc extends Bloc<RecComboEvent, RecComboState> {
  RecComboBloc() : super(RecComboInitial()) {
    on<LoadRecCombos>(_onLoadRecCombos);
    on<SearchRecCombos>(_onSearchRecCombos);
  }

  void _onLoadRecCombos(LoadRecCombos event, Emitter<RecComboState> emit) {
    final items = event.items;
    emit(RecCombosLoaded(items: items));
  }

  void _onSearchRecCombos(SearchRecCombos event, Emitter<RecComboState> emit) {
    final query = event.query;
    final items = event.items;
    final filteredItems = items
        .where(
            (item) => item.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    emit(RecCombosLoaded(items: filteredItems));
  }
}
