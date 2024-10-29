part of 'rec_combo_bloc.dart';

abstract class RecComboEvent extends Equatable {
  const RecComboEvent();

  @override
  List<Object> get props => [];
}

class LoadRecCombos extends RecComboEvent {
  final List<RecCombo> items;

  const LoadRecCombos({required this.items});

  @override
  List<Object> get props => [items];
}

class SearchRecCombos extends RecComboEvent {
  final String query;
  final List<RecCombo> items;

  const SearchRecCombos({required this.query, required this.items});

  @override
  List<Object> get props => [query, items];
}
