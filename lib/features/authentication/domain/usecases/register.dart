import 'package:answer_me_app/core/errors/remote_client_exception.dart';
import 'package:answer_me_app/features/authentication/domain/repositories/user_repository_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class Register {
  final UserRepositoryInterface userRepository;
  Register(this.userRepository);

  Future<Either<RemoteClientException, Response>> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    final Either<RemoteClientException, Response> response =
        await userRepository.register(
      name: name,
      email: email,
      password: password,
    );

    if (response.isLeft()) {
      final RemoteClientException? exception =
          response.fold((l) => l, (r) => null);
      throw exception!;
    }

    final Response? responseValue = response.fold((l) => null, (r) => r);

    userRepository.writeTokenOnLocalStorage(responseValue!.body['token']);
    userRepository.writeUserOnLocalStorage(responseValue.body['usr']);

    return response;
  }
}
