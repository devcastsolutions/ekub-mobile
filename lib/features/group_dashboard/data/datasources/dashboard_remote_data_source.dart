import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/round_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<RoundModel>> getGroupRounds(int groupId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;
  DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RoundModel>> getGroupRounds(int groupId) async {
    final response = await apiClient.get('${ApiConstants.groupsEndpoint}/$groupId/rounds');
    final list = response.data as List;
    return list.map((j) => RoundModel.fromJson(j as Map<String, dynamic>)).toList();
  }
}
