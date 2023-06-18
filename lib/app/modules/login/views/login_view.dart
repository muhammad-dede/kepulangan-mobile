import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/button_widget.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: controller.formState,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Center(
                child: Lottie.asset(
                  'assets/lotties/login.json',
                  height: Get.height * 0.325,
                ),
              ),
              const Center(
                child: Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Center(
                child: Text(
                  "Masuk untuk melanjutkan.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Email(),
              const SizedBox(height: 5),
              const Password(),
              const SizedBox(height: 20),
              const Submit(),
            ],
          ),
        ),
      ),
    );
  }
}

class Email extends GetView<LoginController> {
  const Email({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormFieldWidget(
        labelText: "Email",
        readOnly: false,
        controller: controller.emailController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => controller.validator(value!),
      ),
    );
  }
}

class Password extends GetView<LoginController> {
  const Password({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Password",
            suffixIcon: IconButton(
              onPressed: () {
                controller.isHidePassword = !controller.isHidePassword;
                controller.update();
              },
              icon: Icon(
                controller.isHidePassword == true
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            readOnly: false,
            controller: controller.passwordController,
            obscureText: controller.isHidePassword,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => controller.validator(value!),
          ),
        );
      },
    );
  }
}

class Submit extends GetView<LoginController> {
  const Submit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      labelButton: "Lanjutkan",
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () async {
        await controller.login();
      },
    );
  }
}
