import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';

import '../../auth/models/user.dart';
import '../../global/widgets/meninki_network_image.dart';

class UsersProfile extends StatelessWidget {
  final User user;
  const UsersProfile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GetProfileCubit>().getPublicProfile(user.id ?? 999);
        Go.to(Routes.publicProfilePage);
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              child:
                  user.cover_image != null
                      ? MeninkiNetworkImage(
                        borderRadius: 100,
                        file: user.cover_image!,
                        networkImageType: NetworkImageType.small,
                      )
                      : Container(),
            ),
          ),
          // Positioned(bottom: -10, child: Icon(Icons.add_circle, color: Color(0xFFC7281F))),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;

  const ExpandableText({super.key, required this.text, this.style, this.trimLines = 2});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  void _toggleExpanded() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleExpanded,
      child: Text(
        widget.text,
        style: widget.style ?? TextStyle(color: Colors.white, fontSize: 16),
        maxLines: _expanded ? null : widget.trimLines,
        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
