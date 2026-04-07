import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import 'package:meninki/features/adds/models/add.dart';
import 'package:meninki/features/adds/widgets/adds_sheet.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../adds_to_card.dart';

class AddDetailPage extends StatefulWidget {
  final Add add;

  const AddDetailPage(this.add, {super.key});

  @override
  State<AddDetailPage> createState() => _AddDetailPageState();
}

class _AddDetailPageState extends State<AddDetailPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(lg.ads),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Color(0xFFF3F3F3),
                context: context,
                builder: (context) {
                  return PublicAddsSheet(widget.add);
                },
              );
            },
            child: Padd(right: 16, child: Icon(Icons.more_vert_outlined)),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddsToCard(),
      body: BlocBuilder<AddUuidCubit, AddUuidState>(
        builder: (context, state) {
          if (state is AddUuidLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is AddUuidSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AddUuidCubit>().getAdd(widget.add.id!);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.add.files?.isNotEmpty ?? false)
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padd(
                              left: index == 0 ? 10 : 0,
                              child: SizedBox(
                                height: 250,
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: MeninkiNetworkImage(
                                    borderRadius: 14,
                                    file: state.add.files![index],
                                    networkImageType: NetworkImageType.medium,
                                    fit: BoxFit.cover,
                                    otherFiles: state.add.files,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Box(w: 10),
                          itemCount: state.add.files?.length ?? 0,
                        ),
                      ),
                    Padd(
                      hor: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Box(h: 20),
                          Text(
                            state.add.title ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Box(h: 20),
                          //market
                          GestureDetector(
                            onTap: () {
                              context.read<GetProfileCubit>().getPublicProfile(
                                state.add.user?.id ?? 0,
                              );
                              Go.to(Routes.publicProfilePage);
                            },
                            child: Container(
                              height: 66,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: Row(
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 2),
                                    ),
                                  ),
                                  Box(w: 10),
                                  Expanded(
                                    child: Text(
                                      state.add.user?.username ?? '',
                                      maxLines: 2,
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  // Box(w: 10),
                                  // Container(
                                  //   height: 46,
                                  //   width: 46,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(14),
                                  //   ),
                                  //   child: Center(child: Svvg.asset("message")),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Box(h: 20),
                          Text(state.add.description ?? '', style: TextStyle(fontSize: 16)),
                          Box(h: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                if (state.add.created_at != null)
                                  Row(
                                    children: [
                                      Text(
                                        lg.publishedAt,
                                        style: TextStyle(color: Color(0xFF969696)),
                                      ),
                                      Expanded(
                                        child: Text(
                                          DateFormat('dd.MM.yyyy').format(state.add.created_at!),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Text(lg.category, style: TextStyle(color: Color(0xFF969696))),
                                    Expanded(
                                      child: Text(
                                        state.add.category?.name?.trans(context) ?? '-',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Box(h: 150),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
