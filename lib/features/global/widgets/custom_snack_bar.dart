import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class Sizes {
  Sizes();
  double dpWidth(BuildContext context) => //for tablet
      MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width;

  double? btnWidth(double width) => //for tablet
      width < 400 ? width - 32 : 400;
}

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext context,
    required String title,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isError ? Col.redTask : Col.greenTask,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dpWidth * 0.02),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(
                isError ? 'danger' : 'active',
                h: dpWidth * 0.05,
                w: dpWidth * 0.05,
                color: Colors.white,
              ),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static void showYellowSnackBar({
    required BuildContext context,
    required String title,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Col.primYellow,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dpWidth * 0.02),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(
                'danger',
                h: dpWidth * 0.05,
                w: dpWidth * 0.05,
                color: Col.white,
              ),
              Box(w: dpWidth * 0.03),
              Flexible(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static newDesignSnackBar({
    required BuildContext context,
    required String title,
    required bool isError,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dpWidth * 0.02),
            side: BorderSide(
                color: isError ? const Color(0xFFD32F2F) : const Color(0xFF1E4620), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(
                isError ? 'dangerNew' : 'success',
                h: dpWidth * 0.05,
                w: dpWidth * 0.05,
              ),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isError ? const Color(0xFF5F2120) : Colors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }
}