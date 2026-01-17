import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';

import '../../../core/helpers.dart';

class HomeAdd extends StatefulWidget {
  const HomeAdd({super.key});

  @override
  State<HomeAdd> createState() => _HomeAddState();
}

class _HomeAddState extends State<HomeAdd> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Box(h: 20),

          ///filter
          Padd(
            hor: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Обзоры", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        Svvg.asset("sort", size: 20, color: Color(0xFF969696)),
                        Text("По дате - сначала новые", style: TextStyle(color: Color(0xFF969696))),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Go.to(Routes.addCreatePage);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Col.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: Icon(Icons.add_circle, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Box(h: 10),

          ///categories
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padd(left: 10, child: Svvg.asset('home', color: Colors.black));
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFFF3F3F3),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    "Автомобили",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF474747)),
                  ),
                );
              },
              separatorBuilder: (context, index) => Box(w: 6),
              itemCount: 8,
            ),
          ),

          Box(h: 20),

          Padd(
            hor: 10,
            child: MasonryGridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 8,
              itemCount: 19,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 168,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      "Pellentesque mauris cras feugiat lectus quam cras",
                      style: TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("1313 TMT", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
