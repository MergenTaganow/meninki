import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/bloc/aut_bloc/auth_bloc.dart';
import 'package:meninki/features/auth/bloc/register_cubit/register_cubit.dart';

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
  String error = '';

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: Text("Расскажи о себе"),
          backgroundColor: Color(0xFFF4EFEB),
          automaticallyImplyLeading: false,
        ),
        body: Padd(
          pad: 40,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndTextField(
                  title: "Введи свое имя",
                  controller: nameController,
                  hint: 'Ваше имя',
                ),
                TitleAndTextField(
                  title: "Введи свою фамилию",
                  controller: surnameController,
                  hint: 'Ваше фамилия',
                ),
                Text('Придумай юзернейм', style: TextStyle(fontWeight: FontWeight.w500)),
                Box(h: 6),
                TexField(
                  ctx: context,
                  cont: usernameController,
                  filCol: Color(0xFFF4EFEB),
                  border: usernameError,
                  borderColor: usernameError ? Color(0xFFB71764) : null,
                  borderRadius: 10,
                  preTex: "@  ",
                  hint: 'юзернейм',
                  hintCol: Color(0xFFAFA8B4),
                ),
                if (usernameError)
                  Padd(
                    top: 4,
                    child: Text(error, style: TextStyle(color: Color(0xFFB71764), fontSize: 12)),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return Container(
              height: 45,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A4267),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
                        ? Padd(pad: 4, child: CircularProgressIndicator(color: Colors.white))
                        : Text(
                          "Завершить",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          filCol: Color(0xFFF4EFEB),
          borderRadius: 10,
          hint: hint,
          hintCol: Color(0xFFAFA8B4),
        ),
        Box(h: 20),
      ],
    );
  }
}
