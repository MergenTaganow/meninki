import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import 'package:meninki/features/reels/model/query.dart';

import '../../categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import '../widgets/my_adds_list.dart';

class MyAddsPage extends StatefulWidget {
  const MyAddsPage({super.key});

  @override
  State<MyAddsPage> createState() => _MyAddsPageState();
}

class _MyAddsPageState extends State<MyAddsPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    context.read<CategorySelectingCubit>().emptySelections(
      CategorySelectingCubit.adds_page_category,
    );
    context.read<GetMyAddsBloc>().add(GetAdd(Query(extraUrl: 'advertisements/client')));
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        context.read<GetMyAddsBloc>().add(AddPag(query: Query(extraUrl: 'advertisements/client')));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(lg.myAds)),
      body: Padd(
        hor: 8,
        ver: 10,
        child: SingleChildScrollView(controller: scrollController, child: MyAddsList()),
      ),
    );
  }
}
