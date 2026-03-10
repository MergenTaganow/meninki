import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/address/bloc/address_create_cubit/address_create_cubit.dart';
import 'package:meninki/features/address/bloc/region_selection_cubit/region_selecting_cubit.dart';
import 'package:meninki/features/address/widgets/region_selection.dart';
import 'package:meninki/features/province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import 'package:meninki/features/province/widgets/province_selection.dart';

import '../../../core/colors.dart';
import '../../global/widgets/custom_snack_bar.dart';

class AddressCreatePage extends StatefulWidget {
  const AddressCreatePage({super.key});

  @override
  State<AddressCreatePage> createState() => _AddressCreatePageState();
}

class _AddressCreatePageState extends State<AddressCreatePage> {
  TextEditingController addressInfo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return BlocListener<AddressCreateCubit, AddressCreateState>(
      listener: (context, state) {
        if (state is AddressCreateSuccess) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: lg.successfullyCreated,
            isError: false,
          );
          Go.pop();
        }
        if (state is AddressCreateFailed) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: state.failure.message ?? lg.smthWentWrong,
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(lg.createAddress)),
        body: SafeArea(
          child: Padd(
            hor: 12,
            ver: 20,
            child: Column(
              children: [
                ProvinceSelection(
                  selectionKey: ProvinceSelectingCubit.address_creating_province,
                  singleSelection: true,
                ),
                Box(h: 20),
                RegionSelection(
                  selectionKey: RegionSelectingCubit.address_creating_region,
                  singleSelection: true,
                ),
                Box(h: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.extraInfo),
                      Box(h: 4),
                      TexField(
                        ctx: context,
                        cont: addressInfo,
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadius: 14,
                        hint: AppLocalizations.of(context)!.mandatory,
                        validate:
                            (text) =>
                                (text?.isEmpty ?? false)
                                    ? AppLocalizations.of(context)!.mandatoryField
                                    : null,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createButton() {
    return BlocBuilder<AddressCreateCubit, AddressCreateState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Col.primary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),

              /// ⭐ Ripple tuning
              overlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white.withOpacity(0.18);
                }
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white.withOpacity(0.08);
                }
                return null;
              }),

              /// Optional: remove elevation jump
              elevation: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed) ? 1 : 2,
              ),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();

              var valid = _formKey.currentState?.validate() ?? false;
              if (!valid) return;

              var provinces =
                  context.read<ProvinceSelectingCubit>().selectedMap[ProvinceSelectingCubit
                      .address_creating_province] ??
                  [];
              if (provinces.isEmpty) {
                CustomSnackBar.showYellowSnackBar(
                  context: context,
                  title: AppLocalizations.of(context)!.provinceNotSelected,
                );
                return;
              }
              var region =
                  context.read<RegionSelectingCubit>().selectedMap[RegionSelectingCubit
                      .address_creating_region] ??
                  [];
              if (region.isEmpty) {
                CustomSnackBar.showYellowSnackBar(
                  context: context,
                  title: "AppLocalizations.of(context)!.regionNotSelected",
                );
                return;
              }

              if (state is! AddressCreateLoading) {
                context.read<AddressCreateCubit>().createAddress({
                  "region_id": region.single.id,
                  "info": addressInfo.text.trim(),
                });
              }
            },
            child:
                state is AddressCreateLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.sendForReview,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(Icons.send, color: Colors.white),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
