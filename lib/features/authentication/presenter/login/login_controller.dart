import 'package:answer_me_app/core/errors/remote_client_exception.dart';
import 'package:answer_me_app/core/mixins/loading_mixin.dart';
import 'package:answer_me_app/core/mixins/message_mixin.dart';
import 'package:answer_me_app/core/mixins/validators_mixin.dart';
import 'package:answer_me_app/core/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/usecases/login.dart';
import '../../domain/usecases/write_token_on_local_storage.dart';
import '../../domain/usecases/write_user_on_local_storage.dart';

class LoginController extends GetxController
    with LoaderMixin, MessageMixin, ValidatorsMixin {
  final RxBool showBlueBackground = false.obs;
  final RxBool showModalPage = false.obs;
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();
  final GlobalKey<FormState> loginGK = GlobalKey<FormState>();
  final TextEditingController emailEC = TextEditingController();
  final TextEditingController passwordEC = TextEditingController();
  final RxBool isPasswordVisible = false.obs;

  final UseCase _loginUsecase;
  final UseCase _writeTokenOnLocalStorage;
  final UseCase _writeUserOnLocalStorage;

  LoginController({
    required UseCase loginUsecase,
    required UseCase writeTokenOnLocalStorage,
    required UseCase writeUserOnLocalStorage,
  })  : _loginUsecase = loginUsecase,
        _writeTokenOnLocalStorage = writeTokenOnLocalStorage,
        _writeUserOnLocalStorage = writeUserOnLocalStorage;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 2680), () {
      showModalPage.toggle();
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      showBlueBackground.toggle();
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailEC.dispose();
    passwordEC.dispose();
  }

  Future<void> handleSubmitButtonEvent() async {
    try {
      Get.focusScope?.unfocus();
      if (loginGK.currentState?.validate() ?? false) {
        loading.toggle();
        await login();
        loading.toggle();
      }
      await Get.toNamed('/home');
    } on RemoteClientException catch (e) {
      loading.toggle();
      message(MessageModel(
        title: 'Erro',
        message: e.message,
        type: MessageType.error,
      ));
    }
  }

  Future<void> login() async {
    final Response response = await _loginUsecase.call(LoginParams(
      email: emailEC.text,
      password: passwordEC.text,
    ));

    _writeTokenOnLocalStorage.call(WTOLSParams(
      token: response.body['token'],
    ));

    _writeUserOnLocalStorage.call(WUOLSParams(
      user: response.body['usr'],
    ));
  }

  void handleNextFieldEvent(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }
}