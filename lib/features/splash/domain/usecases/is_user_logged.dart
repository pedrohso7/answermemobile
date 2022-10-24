import 'package:clean_architeture_project/core/errors/remote_client_exception.dart';
import 'package:clean_architeture_project/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/splash_repository_interface.dart';

class IsUserLogged implements UseCase<Future<bool>, IsUserLoggedParams> {
  final SplashRepositoryInterface splashRepository;
  IsUserLogged(this.splashRepository);

  @override
  Future<bool> call(IsUserLoggedParams params) async {
    final Either<RemoteClientException, bool> response =
        await splashRepository.isUserTokenValid(
      token: params.token,
      userId: params.userId,
    );

    if (response.isLeft()) {
      final RemoteClientException? exception =
          response.fold((l) => l, (r) => null);
      throw exception!;
    }

    return response.fold((l) => false, (r) => r);
  }
}

class IsUserLoggedParams {
  final String token;
  final String userId;

  IsUserLoggedParams(
    this.token,
    this.userId,
  );
}
