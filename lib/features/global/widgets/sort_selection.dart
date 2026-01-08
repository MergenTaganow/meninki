import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers.dart';
import '../blocs/sort_cubit/sort_cubit.dart';

class SortSelection extends StatelessWidget {
  SortSelection({super.key, required this.listSort, required this.sortKey});

  final List<Sort> listSort;
  final String sortKey;

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Color(0xFF474747)),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Сортировка элементов"),
        Box(h: 6),
        BlocBuilder<SortCubit, SortState>(
          builder: (context, state) {
            if (state is SortSuccess) {
              return DropdownMenu<Sort>(
                width: MediaQuery.of(context).size.width - 40,
                menuStyle: MenuStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(left: 10),
                  constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                  fillColor: Colors.white,
                  filled: true,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  hintStyle: TextStyle(color: Color(0xFF969696)),
                ),

                hintText: "Yzygiderligi saýla",
                // dropdownColor: Colors.white,
                trailingIcon: Icon(Icons.keyboard_arrow_down_outlined),
                selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_outlined),
                initialSelection: state.sort?[sortKey],
                onSelected: (value) {
                  if (value != null) {
                    context.read<SortCubit>().selectSort(key: sortKey, newSort: value);
                  }
                },
                dropdownMenuEntries:
                    listSort
                        .map(
                          (e) => DropdownMenuEntry(
                            value: e,
                            label: e.text ?? '',
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              );
            }

            return Container();
          },
        ),
      ],
    );
  }
}
