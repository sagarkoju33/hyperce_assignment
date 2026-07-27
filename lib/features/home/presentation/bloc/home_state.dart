import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.title = '',
    this.message,
  });

  final HomeStatus status;
  final String title;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    String? title,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      title: title ?? this.title,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, title, message];
}
