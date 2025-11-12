import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';

class Svvg extends SvgPicture {
  Svvg.asset(
    String iconName, {
    super.key,
    double? size,
    double? h,
    double? w,
    BoxFit? fit,
    Color? color,
    String? fileName,
  }) : super.asset(
         'assets/${fileName ?? 'icons'}/$iconName.svg',
         height: size ?? h,
         width: size ?? w,
         fit: fit ?? BoxFit.contain,
         // ignore: deprecated_member_use
         color: color,
       );
}

class TexField extends TextFormField {
  TexField({
    super.key,
    TextEditingController? cont,
    BuildContext? ctx,
    String? label,
    double? horPad,
    String? preTex,
    String? hint,
    TextInputType? keyboard,
    bool? suffix,
    Widget? suffixWidget,
    String? Function(String? value)? validate,
    double? verPad,
    bool? obsc,
    bool? autoCorrect,
    bool showHint = true,
    double? letSpace,
    double? borderRadius,
    Widget? prefix,
    Color? filCol = Colors.white,
    Color? hintCol,
    Color? textColor,
    Color? suffixColor,
    Color? borderColor,
    int? maxLine = 1,
    int? minLine,
    super.enabled,
    String? initial,
    bool? autoFocus,
    bool border = false,
    super.expands,
    TextInputAction? inputAction,
    void Function(String str)? onChange,
    super.onTap,
    void Function()? onSuffix,
    super.focusNode,
    void Function(String?)? onSubmit,
    int? maxLen,
    double? hintFontSize,
    int? customMaxLen,
    TextCapitalization? textCapitalization,
    List<TextInputFormatter>? inpFormatters,
    TextStyle? textStyle,
    TextAlign? textAlign,
    BorderRadius? borderRadiusType,
  }) : super(
         controller: cont,
         style:
             textStyle ??
             Theme.of(ctx!).textTheme.bodyMedium!.copyWith(
               color: textColor ?? Colors.black,
               fontSize: 16,
               letterSpacing: letSpace,
             ),
         validator: validate,
         textAlign: textAlign ?? TextAlign.start,
         textInputAction:
             inputAction ?? (maxLine == 1 ? TextInputAction.next : TextInputAction.newline),
         keyboardType: keyboard ?? (maxLine == 1 ? null : TextInputType.multiline),
         autofocus: autoFocus ?? false,
         maxLength: maxLen,
         autocorrect: autoCorrect ?? true,
         maxLines: maxLine,
         minLines: minLine,
         obscureText: obsc ?? false,
         obscuringCharacter: '*',
         onFieldSubmitted: onSubmit,
         initialValue: initial,
         onChanged: onChange,
         decoration: InputDecoration(
           counter: const SizedBox(),
           contentPadding: EdgeInsets.symmetric(horizontal: horPad ?? 16, vertical: verPad ?? 10),
           fillColor: filCol,
           filled: true,
           labelText: label ?? '',
           suffixIcon:
               suffix != null
                   ? (obsc != null)
                       ? GestureDetector(
                         onTap: onSuffix,
                         child: Padd(
                           right: 12,
                           left: 8,
                           bot: 8,
                           top: 8,
                           child: Svvg.asset(
                             obsc ? 'eyeC' : 'eye',
                             fit: BoxFit.cover,
                             color: suffixColor,
                           ),
                         ),
                       )
                       : GestureDetector(
                         onTap: onSuffix,
                         child: Padd(
                           right: 15,
                           left: 5,
                           bot: 5,
                           child: const Icon(
                             Icons.close,
                             color: Color.fromARGB(255, 108, 113, 118),
                             size: 20,
                           ),
                         ),
                       )
                   : suffixWidget,
           suffixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 60),
           errorStyle: const TextStyle(height: 0.7, fontWeight: FontWeight.normal),
           hintText: hint,
           floatingLabelBehavior:
               !showHint ? FloatingLabelBehavior.auto : FloatingLabelBehavior.always,
           hintStyle: Theme.of(ctx!).textTheme.bodyMedium!.copyWith(
             color: hintCol ?? Col.borderColor,
             fontSize: hintFontSize,
             fontWeight: FontWeight.normal,
           ),
           prefixIcon: prefix,
           prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 45),
           prefixStyle: Theme.of(
             ctx,
           ).textTheme.labelLarge!.copyWith(color: const Color(0xff333333)),
           prefixText: preTex,
           labelStyle: Theme.of(ctx).textTheme.bodySmall!.copyWith(color: const Color(0xff817F77)),
           border: OutlineInputBorder(
             borderSide: BorderSide(
               color: border ? borderColor ?? Col.borderColor : Col.transparent,
               width: 1,
             ),
             borderRadius: borderRadiusType ?? BorderRadius.circular(borderRadius ?? 2),
           ),
           errorBorder: OutlineInputBorder(
             borderSide: const BorderSide(color: Colors.redAccent, width: .5),
             borderRadius: borderRadiusType ?? BorderRadius.circular(borderRadius ?? 2),
           ),
           focusedErrorBorder: OutlineInputBorder(
             borderSide: const BorderSide(color: Colors.red, width: .5),
             borderRadius: borderRadiusType ?? BorderRadius.circular(borderRadius ?? 2),
           ),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: border ? borderColor ?? Col.borderColor : Col.transparent,
               width: 1,
             ),
             borderRadius: borderRadiusType ?? BorderRadius.circular(borderRadius ?? 2),
           ),
           errorMaxLines: 2,
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: border ? borderColor ?? Col.primBlue : Col.transparent,
               width: 1,
             ),
             borderRadius: borderRadiusType ?? BorderRadius.circular(borderRadius ?? 2),
           ),
         ),
         inputFormatters:
             inpFormatters ?? <TextInputFormatter>[LengthLimitingTextInputFormatter(customMaxLen)],
         textCapitalization: textCapitalization ?? TextCapitalization.sentences,
       );
}

class Padd extends Padding {
  Padd({
    super.key,
    double? pad,
    double? hor,
    double? ver,
    double? top,
    double? bot,
    double? left,
    double? right,
    super.child,
  }) : super(
         padding:
             hor != null || ver != null
                 ? EdgeInsets.symmetric(horizontal: hor ?? 0, vertical: ver ?? 0)
                 : top != null || bot != null || right != null || left != null
                 ? EdgeInsets.only(
                   bottom: bot ?? 0,
                   left: left ?? 0,
                   right: right ?? 0,
                   top: top ?? 0,
                 )
                 : pad != null
                 ? EdgeInsets.all(pad)
                 : EdgeInsets.zero,
       );
}

// ignore: must_be_immutable
class EBtn extends StatelessWidget {
  EBtn({
    super.key,
    // required this.lg,
    this.onTap,
    this.col,
    this.text,
    this.h,
    this.w,
    this.radius,
    this.border,
    this.size,
    this.txcol,
    this.borCol,
    this.backCol,
    this.hor = 15,
    this.ver,
    this.weight,
    this.child,
  });
  final Function()? onTap;
  final Color? col;
  final String? text;
  double? h = 40;
  double? w;
  double? hor;
  double? ver;
  final double? radius;
  final bool? border;
  final Color? txcol;
  final Color? borCol;
  final Color? backCol;
  final FontWeight? weight;
  final Widget? child;
  // final AppLocalizations lg;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: col,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 8),
          side: BorderSide(color: borCol ?? Col.transparent),
        ),
      ),
      // ignore: avoid_returning_null_for_void
      onPressed: text == '' ? () => null : onTap,
      child:
          child ??
          SizedBox(
            width: w,
            height: h,
            child: Padd(
              hor: hor,
              ver: ver,
              child: Center(
                child:
                    text == ''
                        ? const Box(
                          d: 25,
                          child: CircularProgressIndicator(color: Col.white, strokeWidth: 3),
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            text ?? "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: size,
                              color: txcol ?? Col.white,
                              fontWeight: weight ?? FontWeight.w500,
                            ),
                          ),
                        ),
              ),
            ),
          ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SingleChildScroll extends StatelessWidget {
  const SingleChildScroll({super.key, this.controller, this.physics, this.child});
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(controller: controller, physics: physics, child: child),
    );
  }
}

class Box extends SizedBox {
  const Box({super.key, super.child, double? h, double? w, double? d})
    : super(height: d ?? h, width: d ?? w);
}

class Snackba {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar({
    required BuildContext context,
    required String title,
    bool isError = false,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Col.white, fontWeight: FontWeight.w500),
        ),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: isError ? Col.secondRed : null,
      ),
    );
  }
}

List<BoxShadow>? getBoxShadow({double? blurRad, Color? color}) {
  return [
    BoxShadow(
      color: color ?? const Color(0x19494949),
      blurRadius: blurRad ?? 15,
      offset: const Offset(0, 0),
      spreadRadius: 0,
    ),
  ];
}

class StorageSizeConverter {
  static bytToMB(int byt) {
    // Convert bytes to megabytes
    double sizeInMB = byt / (1024 * 1024); // 1 MB = 1024 * 1024 bytes

    return sizeInMB;
  }
}
