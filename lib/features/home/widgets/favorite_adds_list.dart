import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meninki/features/adds/bloc/get_public_adds_bloc/get_adds_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../adds/bloc/add_uuid_cubit/add_uuid_cubit.dart';
import '../../adds/models/add.dart';
import '../../global/widgets/meninki_network_image.dart';

class FavoriteAddsList extends StatelessWidget {
  const FavoriteAddsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFavoriteAddsBloc, GetAddsState>(
      builder: (context, state) {
        final isLoading = state is GetAddLoading;

        final adds =
            isLoading
                ? List.generate(6, (_) => Add())
                : state is GetAddSuccess
                ? state.adds
                : <Add>[];

        return Skeletonizer(
          enabled: isLoading,
          effect: ShimmerEffect(
            baseColor: const Color(0xFFEAEAEA),
            highlightColor: const Color(0xFFF5F5F5),
          ),
          child: MasonryGridView.count(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 8,
            itemCount: adds.length,
            itemBuilder: (context, index) {
              final add = adds[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<AddUuidCubit>().getAdd(add.id ?? 0);
                      Go.to(Routes.addDetailPage, argument: {'add': add});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 168,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            add.cover_image != null
                                ? IgnorePointer(
                                  ignoring: true,
                                  child: MeninkiNetworkImage(
                                    file: add.cover_image!,
                                    networkImageType: NetworkImageType.medium,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),
                  const Box(h: 6),
                  Text(
                    add.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Box(h: 4),
                  Text("${add.price} TMT", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
