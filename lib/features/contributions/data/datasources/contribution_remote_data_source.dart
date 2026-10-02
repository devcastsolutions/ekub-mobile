import '../../../../core/network/api_client.dart';
import '../models/contribution_model.dart';

abstract class ContributionRemoteDataSource {
  Future<ContributionModel> logContribution({
    required int roundId,
    required int memberId,
    required double amount,
    required String status,
  });
  Future<void> closeRound(int roundId);
}

class ContributionRemoteDataSourceImpl implements ContributionRemoteDataSource {
  final ApiClient apiClient;
  ContributionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ContributionModel> logContribution({
    required int roundId,
    required int memberId,
    required double amount,
    required String status,
  }) async {
    final response = await apiClient.post(
      '/rounds/$roundId/contributions',
      data: {
        'member_id': memberId,
        'amount': amount,
        'status': status,
      },
    );
    return ContributionModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> closeRound(int roundId) async {
    await apiClient.post('/rounds/$roundId/close');
  }
}
