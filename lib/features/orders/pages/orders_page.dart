import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/orders/bloc/get_orders_bloc/get_orders_bloc.dart';
import 'package:meninki/features/orders/model/order.dart';

import '../../../core/helpers.dart';
import '../bloc/order_id_cubit/order_id_cubit.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    context.read<GetOrdersBloc>().add(GetOrder());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(lg.orders)),
      body: Padd(
        hor: 20,
        child: BlocBuilder<GetOrdersBloc, GetOrdersState>(
          builder: (context, state) {
            if (state is GetOrderLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetOrderSuccess) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return OrderCard(state.orders[index]);
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

class OrderCard extends StatelessWidget {
  final MeninkiOrder order;
  const OrderCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        context.read<OrderIdCubit>().getOrder(order.id ?? 0);
        Go.to(Routes.orderDetailPage);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFF3F3F3)),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.code ?? '-', style: TextStyle(fontWeight: FontWeight.w500)),
                      if (order.created_at != null)
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(order.created_at!),
                          style: TextStyle(color: Color(0xFF969696), fontSize: 12),
                        ),
                    ],
                  ),
                ),
                Text(
                  "${order.total_cost} ТМТ",
                  style: TextStyle(color: Col.primary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            Padd(ver: 10, child: Divider(color: Color(0xFFF3F3F3), height: 1)),

            // Region + address row
            if (order.region_name != null)
              Row(
                children: [
                  Svvg.asset('location'), // or Icon(Icons.location_on_outlined)
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      [
                        order.region_name?.trans(context),
                        order.address,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            SizedBox(height: 6),

            // Market cost + tax row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.delivery_cost == 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lg.freeDelivery,
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  )
                else
                  Text(
                    '${lg.deliveryCost}: ${order.delivery_cost} ТМТ',
                    style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                  ),
                if (order.net_taxes != null && order.net_taxes! > 0)
                  Text(
                    '${lg.netTaxes}: ${order.net_taxes} ТМТ',
                    style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                  ),
              ],
            ),

            SizedBox(height: 8),

            // Status bar
            Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: _statusColor(order.status).withOpacity(0.12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _statusLabel(context,order.status),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _statusColor(order.status),
                    ),
                  ),
                  Svvg.asset(_statusIcon(order.status)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Col.primary;
      case 'shipping':
        return Colors.orange;
      default:
        return Color(0xFF969696);
    }
  }

  String _statusLabel(BuildContext context, String? status) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    switch (status) {
      case 'completed':
        return lg.completed;
      case 'cancelled':
        return lg.cancelled;
      case 'pending':
        return lg.pending;
      case 'shipping':
        return lg.onWay;
      default:
        return status ?? '';
    }
  }

  String _statusIcon(String? status) {
    switch (status) {
      case 'completed':
        return 'completed';
      case 'cancelled':
        return 'cancelled';
      case 'shipping':
        return 'shipping';
      default:
        return 'pending';
    }
  }
}
