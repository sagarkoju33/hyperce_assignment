import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  const HomeEntity({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
