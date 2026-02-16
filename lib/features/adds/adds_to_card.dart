import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meninki/features/adds/bloc/add_favorite_cubit/add_favorite_cubit.dart';
import 'package:meninki/features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';

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
                    if (state.add.created_at != null)
                      Text(
                        DateFormat('dd.MM.yyyy').format(state.add.created_at!),
                        style: TextStyle(color: Color(0xFF969696), fontSize: 12),
                      ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    BlocBuilder<AddFavoriteCubit, AddFavoriteState>(
                      builder: (context, addState) {
                        bool alreadyFavorite = false;
                        if (addState is AddFavoritesSuccess) {
                          alreadyFavorite = addState.addIds.contains(state.add.id);
                        }
                        return GestureDetector(
                          onTap: () {
                            context.read<AddFavoriteCubit>().toggleFavorite(state.add.id ?? 0);
                          },
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: alreadyFavorite ? Color(0xFFF3F3F3) : Colors.white,
                              border: Border.all(color: Color(0xFFF3F3F3), width: 1.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child:
                                  addState is AddFavoritesLoading
                                      ? Padd(pad: 12, child: CircularProgressIndicator())
                                      : Icon(
                                        alreadyFavorite
                                            ? Icons.bookmark
                                            : Icons.bookmark_border_outlined,
                                        color: Color(0xFF474747),
                                      ),
                            ),
                          ),
                        );
                      },
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
