import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/home/widgets/home_widget.dart';
import '../../reels/blocs/get_reels_bloc/get_reels_bloc.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    context.read<GetReelsBloc>().add(GetReel());
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TabBarView(
              controller: tabController,
              children: [HomeWidget(), Container(), Container(), ProfilePageWidget()],
            ),
            BottomNavBar(tabController),
          ],
        ),
      ),
    );
  }
}
