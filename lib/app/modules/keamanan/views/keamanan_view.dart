import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kepulangan/app/widgets/text_form_field_widget.dart';

import '../controllers/keamanan_controller.dart';

class KeamananView extends GetView<KeamananController> {
  const KeamananView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan Akun'),
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await controller.save();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
      body: Form(
        key: controller.formState,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: const [
            PasswordCurrent(),
            Password(),
            PasswordConfirmation(),
          ],
        ),
      ),
    );
  }
}

class PasswordCurrent extends GetView<KeamananController> {
  const PasswordCurrent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KeamananController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Password Saat ini",
            suffixIcon: IconButton(
              onPressed: () {
                controller.isHidePasswordCurrent =
                    !controller.isHidePasswordCurrent;
                controller.update();
              },
              icon: Icon(
                controller.isHidePasswordCurrent == true
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            readOnly: false,
            controller: controller.passwordCurrentController,
            obscureText: controller.isHidePasswordCurrent,
            keyboardType: TextInputType.text,
            validator: (value) => controller.validator(value!),
          ),
        );
      },
    );
  }
}

class Password extends GetView<KeamananController> {
  const Password({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KeamananController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Password Baru",
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
            validator: (value) => controller.validator(value!),
          ),
        );
      },
    );
  }
}

class PasswordConfirmation extends GetView<KeamananController> {
  const PasswordConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KeamananController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormFieldWidget(
            labelText: "Konfirmasi Password Baru",
            suffixIcon: IconButton(
              onPressed: () {
                controller.isHidePasswordConfirmation =
                    !controller.isHidePasswordConfirmation;
                controller.update();
              },
              icon: Icon(
                controller.isHidePasswordConfirmation == true
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
            readOnly: false,
            controller: controller.passwordConfirmationController,
            obscureText: controller.isHidePasswordConfirmation,
            keyboardType: TextInputType.text,
            validator: (value) => controller.validator(value!),
          ),
        );
      },
    );
  }
}
