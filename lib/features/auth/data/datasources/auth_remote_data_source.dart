import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  });
  Future<String> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(
    this.apiClient, {
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId:
                  '697090691949-dfcappnudr05pabk7d5lr20ask7o8q3v.apps.googleusercontent.com',
            );

  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<String> login(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    final token = response.data['access_token'] as String;
    apiClient.setAuthToken(token);
    return token;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final response = await apiClient.post(
      ApiConstants.registerEndpoint,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      },
    );
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('access_token')) {
      final token = data['access_token'] as String;
      apiClient.setAuthToken(token);
    }
    final userData = data.containsKey('user') ? data['user'] as Map<String, dynamic> : data;
    return UserModel.fromJson(userData);
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In canceled by user.');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    final email = firebaseUser?.email ?? googleUser.email;
    final name = firebaseUser?.displayName ?? googleUser.displayName ?? 'Google User';

    // Exchange with Backend to register/login user and obtain backend JWT access token
    final response = await apiClient.post(
      '/auth/google',
      data: {
        'email': email,
        'name': name,
        'google_id': firebaseUser?.uid ?? googleUser.id,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final token = data['access_token'] as String;
    apiClient.setAuthToken(token);
    return token;
  }
}
