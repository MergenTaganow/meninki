import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/bloc/register_cubit/register_cubit.dart';

import '../../../core/colors.dart';

class RegisterScreen extends StatefulWidget {
  final String temporaryToken;

  const RegisterScreen(this.temporaryToken, {super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool usernameError = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailed && (state.failure.message?.isNotEmpty ?? false)) {
          setState(() {
            usernameError = true;
            error = state.failure.message!;
          });
        }
        if (state is RegisterSuccess) {
          context.read<AuthBloc>().add(SetUser(state.user));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            lg.tellAboutYourself,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padd(
          pad: 30,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lg.registerDescription,
                  style: TextStyle(color: Color(0xFF969696)),
                ),
                Box(h: 20),
                TitleAndTextField(title: lg.firstName, controller: nameController, hint: lg.enterFirstName),
                TitleAndTextField(
                  title: lg.lastName,
                  controller: surnameController,
                  hint: lg.enterLastName,
                ),
                Text(lg.username, style: TextStyle(fontWeight: FontWeight.w500)),
                Box(h: 6),
                TexField(
                  ctx: context,
                  cont: usernameController,
                  border: true,
                  borderRadius: 14,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  hintCol: Color(0xFFAFA8B4),
                  borderColor: usernameError ? Color(0xFFB71764) : Col.primary,
                  preTex: "@  ",
                  hint: lg.enterUsername,
                ),
                Padd(
                  top: 4,
                  child: Text(
                    error ?? lg.usernameRequirements,
                    style: TextStyle(
                      color: error != null ? Color(0xFFB71764) : Color(0xFF969696),
                      fontSize: 12,
                    ),
                  ),
                ),
                Box(h: 20),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Col.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (state is! RegisterLoading) {
                            context.read<RegisterCubit>().register({
                              'first_name': nameController.text,
                              "last_name": surnameController.text,
                              "token": widget.temporaryToken,
                              "username": usernameController.text,
                              "lang": "tk",
                              "fcm_token": "fcm_token1",
                            });
                          }
                        },
                        child:
                            state is RegisterLoading
                                ? Padd(
                                  pad: 4,
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                                : Text(
                                  lg.done,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAndTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;

  const TitleAndTextField({
    required this.controller,
    required this.title,
    required this.hint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        Box(h: 6),
        TexField(
          ctx: context,
          cont: controller,
          border: true,
          borderColor: Col.primary,
          borderRadius: 14,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          hint: hint,
          hintCol: Color(0xFFAFA8B4),
        ),
        Box(h: 20),
      ],
    );
  }
}
