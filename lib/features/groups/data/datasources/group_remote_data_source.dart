import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getMyGroups();
  Future<GroupModel> createGroup({
    required String name,
    required double contributionAmount,
    required String frequency,
    required String startDate,
  });
  Future<void> startGroup(int groupId, bool randomize);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<GroupModel>> getMyGroups() async {
    final response = await apiClient.get(ApiConstants.myGroupsEndpoint);
    final list = response.data as List;
    return list.map((json) => GroupModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    required double contributionAmount,
    required String frequency,
    required String startDate,
  }) async {
    final response = await apiClient.post(
      ApiConstants.groupsEndpoint,
      data: {
        'name': name,
        'contribution_amount': contributionAmount,
        'frequency': frequency,
        'start_date': startDate,
      },
    );
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> startGroup(int groupId, bool randomize) async {
    await apiClient.post('${ApiConstants.groupsEndpoint}/$groupId/start?randomize=$randomize');
  }
}
