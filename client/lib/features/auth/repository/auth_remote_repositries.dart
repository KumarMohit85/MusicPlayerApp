import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repositries.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<Failure, UserModel>> SignUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      print("signup request called");
      final response = await http.post(
          Uri.parse('${ServerConstants.server_url}/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({'name': name, 'email': email, 'password': password}));

      final res_body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        return Left(Failure(res_body['detail']));
      }

      return Right(UserModel.fromMap(res_body));
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> LogIn(
      {required String email, required String password}) async {
    try {
      print("login request called");
      final response = await http.post(
          Uri.parse('${ServerConstants.server_url}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));

      final res_body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(Failure(res_body['detail']));
      }

      return Right(UserModel.fromMap(res_body['user'])
          .copyWith(token: res_body['token']));
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getCurrentUser(String token) async {
    try {
      print("login request called");
      final response = await http.get(
        Uri.parse('${ServerConstants.server_url}/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final res_body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(Failure(res_body['detail']));
      }

      return Right(UserModel.fromMap(res_body).copyWith(token: token));
    } catch (e) {
      print(e);
      return Left(Failure(e.toString()));
    }
  }
}
