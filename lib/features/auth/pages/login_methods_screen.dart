import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import '../../../core/colors.dart';
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
  final _formKey = GlobalKey<FormState>();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Авторизация", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          actions: [Padd(right: 20, child: EditLang())],
        ),
        body: Padd(
          pad: 30,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Box(h: MediaQuery.of(context).size.height * 0.05),
                        Svvg.asset('app_logo'),
                        Box(h: MediaQuery.of(context).size.height * 0.03),
                        Text(
                          'Чтобы пользоваться Meniñki, необходимо авторизоваться.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Box(h: MediaQuery.of(context).size.height * 0.03),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Введите свой номер:",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Box(h: 6),
                            Form(
                              key: _formKey,
                              child: TexField(
                                ctx: context,
                                cont: numberController,
                                border: true,
                                borderColor: Col.primary,
                                borderRadius: 14,
                                preTex: "+993  ",
                                hint: "XX XXXXXX",
                                keyboard: TextInputType.number,
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                validate: (text) {
                                  return text?.length != 8 ? 'Пишите правилный номер' : null;
                                },
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
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  splashColor: Colors.white.withOpacity(0.22),
                                  highlightColor: Colors.white.withOpacity(0.12),
                                  onTap: () {
                                    final isValid = _formKey.currentState!.validate();

                                    if (!isValid) {
                                      // ❌ invalid → border becomes red automatically
                                      return;
                                    }

                                    if (state is! OtpLoading) {
                                      HapticFeedback.mediumImpact();

                                      context.read<OtpCubit>().sendOtp(numberController.text);
                                    }
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: Col.primary,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child:
                                          state is OtpLoading
                                              ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.4,
                                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                                ),
                                              )
                                              : const Text(
                                                "Отправить СМС-код",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                    ),
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
                            Box(h: 10),
                            signWithButton(withGoogle: false),
                            Box(h: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Продолжая, вы принимаете условия конфиденциальности и ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFAFA8B4),
                                ),
                                children: [
                                  TextSpan(
                                    text: "пользовательское соглашение",
                                    style: TextStyle(
                                      color: Color(0xFF3B353F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget signWithButton({required bool withGoogle}) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xFFF4EFEB), borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
    );
  }
}
