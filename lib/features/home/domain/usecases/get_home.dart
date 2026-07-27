import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHome {
  GetHome(this._repository);

  final HomeRepository _repository;

  Future<HomeEntity> call() => _repository.fetch();
}
