import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';

import '../../../core/colors.dart';
import '../../global/widgets/custom_snack_bar.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen(this.phoneNumber, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpFailed) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: state.failure.message ?? "lg.smthWentWrong",
            isError: true,
          );
        }
        if (state is OtpSuccess) {
          Go.too(Routes.registerScreen, argument: {"temporaryToken": state.temporaryToken});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Авторизация", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        body: Padd(
          pad: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Box(h: MediaQuery.of(context).size.height * 0.1),
              RichText(
                text: TextSpan(
                  text: "Введите код, отправленный на номер ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Box(h: 20),
              Form(
                key: _formKey,
                child: TexField(
                  ctx: context,
                  cont: otpController,
                  border: true,
                  borderColor: Col.primary,
                  borderRadius: 14,
                  keyboard: TextInputType.number,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLen: 4,
                  textAlign: TextAlign.center,
                  validate: (text) => text?.length != 4 ? 'должно быть 4 цыфры' : null,
                ),
              ),
              Box(h: 10),
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
                        splashColor: Colors.white.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.15),
                        onTap:
                            (state is OtpSend && state.checkLoading)
                                ? null
                                : () {
                                  final isValid = _formKey.currentState!.validate();

                                  if (!isValid) {
                                    // ❌ invalid → border becomes red automatically
                                    return;
                                  }
                                  if (otpController.text.length == 4) {
                                    HapticFeedback.mediumImpact();

                                    final otp = int.parse(otpController.text);
                                    context.read<OtpCubit>().checkOtp(
                                      otp: otp,
                                      phoneNumber: widget.phoneNumber.replaceAll("+993 ", ''),
                                    );
                                  }
                                },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Col.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child:
                                (state is OtpSend && state.checkLoading)
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
              Box(h: 40),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  if (state is OtpSend) {
                    if (state.retrySeconds > 0) {
                      return Text(
                        "Переотправить через: ${formatSeconds(state.retrySeconds)}",
                        style: TextStyle(color: Color(0xFFA0A0A0)),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          context.read<OtpCubit>().sendOtp(
                            widget.phoneNumber.replaceAll("+993 ", ''),
                          );
                        },
                        child: Text("Отправить смс еще раз", style: TextStyle(color: Col.primary)),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
