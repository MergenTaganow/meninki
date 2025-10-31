import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/auth/bloc/otp_cubit/otp_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../global/widgets/custom_snack_bar.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen(this.phoneNumber, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
        resizeToAvoidBottomInset: false,
        body: Padd(
          pad: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Box(h: MediaQuery.of(context).size.height * 0.15),
              Text(
                "Введите код, отправленный на номер \n ${widget.phoneNumber}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Box(h: 20),
              Pinput(
                length: 4,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 40,
                  height: 50,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2, color: Colors.grey)),
                  ),
                ),
                onCompleted: (value) {
                  var otp = int.parse(value);
                  context.read<OtpCubit>().checkOtp(
                    otp: otp,
                    phoneNumber: widget.phoneNumber.replaceAll("+993 ", ''),
                  );
                },
              ),
              Box(h: 14),
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
                        child: Text(
                          "Отправить смс еще раз",
                          style: TextStyle(color: Color(0xFF005FF0)),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Продолжая, вы принимаете условия конфиденциальности и ",
                  style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFAFA8B4)),
                  children: [
                    TextSpan(
                      text: "пользовательское соглашение",
                      style: TextStyle(color: Color(0xFF3B353F), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
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
