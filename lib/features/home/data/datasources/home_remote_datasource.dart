import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> fetch();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeModel> fetch() async {
    // Replace with ApiClient call.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const HomeModel(id: '1', title: 'Home');
  }
}
