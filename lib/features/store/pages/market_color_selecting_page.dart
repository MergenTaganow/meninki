import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/store/models/market.dart';

import '../../../core/helpers.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../bloc/get_market_by_id/get_market_by_id_cubit.dart';
import '../bloc/store_create_cubit/store_create_cubit.dart';
import '../widgets/ColorPicker.dart';
import '../widgets/store_background_color_selection.dart';

class MarketColorSelectingPage extends StatefulWidget {
  final Market market;

  const MarketColorSelectingPage(this.market, {super.key});

  @override
  State<MarketColorSelectingPage> createState() => _MarketColorSelectingPageState();
}

class _MarketColorSelectingPageState extends State<MarketColorSelectingPage> {
  Color selectedColor = Colors.white;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedColor = widget.market.profile_color ?? Colors.white;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreCreateCubit, StoreCreateState>(
      listener: (context, state) {
        if (state is StoreCreateFailed) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: state.failure.message ?? "smthWentWrong",
            isError: true,
          );
        }
        if (state is StoreEditSuccess) {
          context.read<GetMarketByIdCubit>().getStoreById(widget.market.id);
          CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.success,
            isError: false,
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Цветовая схема"),
          actions: [
            BlocBuilder<StoreCreateCubit, StoreCreateState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    if (state is! StoreCreateLoading) {
                      context.read<StoreCreateCubit>().editStore(widget.market.id, {
                        "profile_color":
                            '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}',
                      });
                    }
                  },
                  child: Padd(
                    pad: 16,
                    child:
                        state is StoreCreateLoading
                            ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                            : Text("done"),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padd(
            ver: 20,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.selectStoreColor),
                    Box(h: 10),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),

                Padd(hor: 10, ver: 16, child: MarketThemePreview(backgroundColor: selectedColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
