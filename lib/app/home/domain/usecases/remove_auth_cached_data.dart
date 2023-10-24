import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/errors/local_storage_exception.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../protocols/home_protocols.dart';

class RemoveAuthCachedData implements UseCase<void, NoParams> {
  final HomeProtocols homeRepository = Modular.get<HomeProtocols>();

  @override
  Future<void> call(NoParams params) async {
    final IResult<void> response = homeRepository.removeAuthCachedData();

    if (response.isError) {
      throw response.error as LocalStorageException;
    }
  }
}
