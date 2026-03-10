import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/reels/model/query.dart';
import '../../../core/helpers.dart';
import '../bloc/market_orders_bloc/get_market_orders_bloc.dart';
import '../widgets/market_order_items_card.dart';

class MarketOrdersPage extends StatefulWidget {
  final int marketId;
  const MarketOrdersPage(this.marketId, {super.key});

  @override
  State<MarketOrdersPage> createState() => _MarketOrdersPageState();
}

class _MarketOrdersPageState extends State<MarketOrdersPage> {
  @override
  void initState() {
    context.read<GetMarketOrdersBloc>().add(GetMarketOrder(Query(market_ids: [widget.marketId])));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(lg.orders)),
      body: Padd(
        hor: 20,
        child: BlocBuilder<GetMarketOrdersBloc, GetMarketOrdersState>(
          builder: (context, state) {
            if (state is GetMarketOrderLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetMarketOrderSuccess) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () async {
                      if (state.orders[index].order?.code != null) {
                        await HapticFeedback.heavyImpact();
                        await Clipboard.setData(
                          ClipboardData(text: state.orders[index].order?.code ?? ''),
                        );
                      }
                    },
                    onTap: () {
                      Go.to(
                        Routes.myProductDetailPage,
                        argument: {"productId": state.orders[index].product_id},
                      );
                    },
                    child: MarketOrderProductTile(product: state.orders[index], context: context),
                  );
                },
                itemCount: state.orders.length,
                separatorBuilder: (BuildContext context, int index) => Box(h: 10),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
