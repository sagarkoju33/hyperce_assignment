import '../../domain/entities/home_entity.dart';

class HomeModel extends HomeEntity {
  const HomeModel({required super.id, required super.title});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Home',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
