// import 'package:flutter/material.dart';
//
// class ErrorPage extends StatelessWidget {
//   const ErrorPage({super.key, this.fl, this.onRefresh});
//
//   final Failure? fl;
//   final void Function()? onRefresh;
//
//   @override
//   Widget build(BuildContext context) {
//     AppLocalizations lg = AppLocalizations.of(context)!;
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (fl?.statusCode == null) Svvg.asset('connection_error') else Svvg.asset('error'),
//         Padd(
//           top: 10,
//           bot: 15,
//           child: Text(
//             (fl?.statusCode == null) ? lg.checkConnection : lg.errorOccuredOnSystem,
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Row(
//           children: [
//             if (fl?.statusCode != null)
//               Expanded(
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1890FF),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           content: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 'Error ${fl?.statusCode ?? ''}',
//                                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                               ),
//                               const Box(h: 25),
//                               Text(
//                                 fl?.message ?? '',
//                                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
//                               ),
//                               const Box(h: 25),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const SizedBox(
//                                   height: 45,
//                                   width: double.infinity,
//                                   child: Center(
//                                     child: Text(
//                                       'OK',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     child: const SizedBox(
//                       height: 45,
//                       child: Center(
//                         child: Text(
//                           'Show Details',
//                           style: TextStyle(color: Colors.white, fontSize: 13),
//                         ),
//                       ),
//                     )),
//               ),
//             if (fl != null && onRefresh != null) const Box(w: 15),
//             if (onRefresh != null)
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Col.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   onPressed: onRefresh,
//                   child: const SizedBox(
//                     height: 45,
//                     child: Center(
//                       child: Text(
//                         'Tazeden synanys',
//                         style: TextStyle(color: Colors.white, fontSize: 13),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }
