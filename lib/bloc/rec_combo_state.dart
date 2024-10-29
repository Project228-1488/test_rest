part of 'rec_combo_bloc.dart';

abstract class RecComboState extends Equatable {
  const RecComboState();

  @override
  List<Object> get props => [];
}

class RecComboInitial extends RecComboState {}

class RecCombosLoaded extends RecComboState {
  final List<RecCombo> items;

  const RecCombosLoaded({required this.items});

  @override
  List<Object> get props => [items];
}