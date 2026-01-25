import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class AddsToCard extends StatelessWidget {
  const AddsToCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUuidCubit, AddUuidState>(
      builder: (context, state) {
        if (state is AddUuidSuccess) {
          return Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(color: Color(0xFFEAEAEA), width: 2),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.only(left: 35, right: 35, bottom: 20),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${state.add.price} TMT", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      "state.add.createdAt",
                      style: TextStyle(color: Color(0xFF969696), fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFF3F3F3), width: 1.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Icon(Icons.bookmark_border_outlined)),
                    ),
                    Box(w: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: Col.primary,
                          border: Border.all(color: Color(0xFFF3F3F3), width: 1.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Icon(Icons.call, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
