import '../../../../core/network/api_client.dart';
import '../models/member_status_model.dart';

abstract class MemberStatusRemoteDataSource {
  Future<MemberStatusModel> getMyStatus(int groupId);
}

class MemberStatusRemoteDataSourceImpl implements MemberStatusRemoteDataSource {
  final ApiClient apiClient;
  MemberStatusRemoteDataSourceImpl(this.apiClient);

  @override
  Future<MemberStatusModel> getMyStatus(int groupId) async {
    final response = await apiClient.get('/members/me/groups/$groupId/status');
    return MemberStatusModel.fromJson(response.data as Map<String, dynamic>);
  }
}
