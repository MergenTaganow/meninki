import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../../core/failure.dart'; // Assuming this import based on usage
import 'package:meninki/core/helpers.dart'; // Already imported
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.fl, this.onRefresh});

  final Failure? fl;
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (fl?.statusCode == null) Svvg.asset('connection_error') else Svvg.asset('error'),
        Padd(
          top: 10,
          bot: 15,
          child: Text(
            (fl?.statusCode == null) ? lg.checkConnection : lg.errorOccuredOnSystem,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            if (fl?.statusCode != null)
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1890FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${lg.error} ${fl?.statusCode ?? ''}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const Box(h: 25),
                              Text(
                                fl?.message ?? '',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              const Box(h: 25),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      lg.ok,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 45,
                      child: Center(
                        child: Text(
                          lg.showDetails,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    )),
              ),
            if (fl != null && onRefresh != null) const Box(w: 15),
            if (onRefresh != null)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Col.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: onRefresh,
                  child: SizedBox(
                    height: 45,
                    child: Center(
                      child: Text(
                        lg.retry,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
