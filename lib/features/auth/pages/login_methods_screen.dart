import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../widgets/change_lang.dart';

class LoginMethodsScreen extends StatefulWidget {
  const LoginMethodsScreen({super.key});

  @override
  State<LoginMethodsScreen> createState() => _LoginMethodsScreenState();
}

class _LoginMethodsScreenState extends State<LoginMethodsScreen> {
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    numberController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppLocalizations lg = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpSend && state.navigate) {
              Go.popUntil();
              Go.to(Routes.otpScreen, argument: {'phoneNumber': "+993 ${numberController.text}"});
            }
            if (state is OtpFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title:
                    state.failure.statusCode == 400
                        ? "lg.usernameAndPasswordWrong"
                        : state.failure.message ?? "lg.smthWentWrong",
                isError: true,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padd(
          pad: 40,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Авторизация", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  EditLang(),
                ],
              ),
              Box(h: MediaQuery.of(context).size.height * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Введите свой номер:", style: TextStyle(fontWeight: FontWeight.w500)),
                  Box(h: 6),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4EFEB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '+993',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFAFA8B4)),
                        ),
                        const SizedBox(width: 12),
                        Padd(
                          ver: 14,
                          child: const VerticalDivider(
                            color: Color(0xFFAFA8B4),
                            thickness: 1,
                            width: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: numberController,
                            keyboardType: TextInputType.phone,
                            maxLength: 8,
                            style: TextStyle(fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'your number',
                              counterText: '',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E2B2B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Box(h: 20),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            numberController.text.length == 8
                                ? Color(0xFF7A4267)
                                : Color(0xFFF0ECE1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      onPressed: () {
                        if (numberController.text.length == 8 && state is! OtpLoading) {
                          context.read<OtpCubit>().sendOtp(numberController.text);
                        }
                      },
                      child:
                          state is OtpLoading
                              ? Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              )
                              : Text(
                                "Продолжить",
                                style: TextStyle(
                                  color:
                                      numberController.text.length == 8
                                          ? Colors.white
                                          : Color(0xFFAFA8B4),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                    ),
                  );
                },
              ),
              Spacer(),
              Column(
                children: [
                  signWithButton(withGoogle: true),
                  Box(h: 14),
                  signWithButton(withGoogle: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox signWithButton({required bool withGoogle}) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF4EFEB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              withGoogle ? "Войти с Google" : "Войти с Apple ID",
              style: TextStyle(color: Color(0xFF3B353F), fontWeight: FontWeight.w500),
            ),
            Svvg.asset(withGoogle ? 'google' : 'apple'),
          ],
        ),
      ),
    );
  }
}
