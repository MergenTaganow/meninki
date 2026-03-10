import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/basket/bloc/get_basket_cubit/get_basket_cubit.dart';
import 'package:meninki/features/basket/bloc/prepare_basket_cubit/prepare_basket_cubit.dart';
import 'package:meninki/features/basket/models/prepared_basket.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/orders/bloc/order_create_cubit/order_create_cubit.dart';
import 'package:meninki/features/orders/bloc/order_id_cubit/order_id_cubit.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../basket/models/basket_product.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../model/order.dart';
// ─────────────────────────────────────────────────────────────────────────────
// OrderDetailPage — Redesigned (light theme, matches PreparedBasketPage)
// ─────────────────────────────────────────────────────────────────────────────

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          lg.orderDetail,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderIdCubit, OrderIdState>(
        builder: (context, state) {
          if (state is OrderIdLoading) {
            return Center(child: CircularProgressIndicator(color: Col.primary));
          }
          if (state is OrderIdSuccess) {
            return _OrderDetailContent(order: state.order, lg: lg);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OrderDetailContent
// ─────────────────────────────────────────────────────────────────────────────

class _OrderDetailContent extends StatelessWidget {
  const _OrderDetailContent({required this.order, required this.lg});

  final MeninkiOrder order;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ── status + code banner ─────────────────────────────────────────
        SliverToBoxAdapter(child: _StatusBanner(order: order, lg: lg)),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── order summary card ───────────────────────────────────────────
        SliverToBoxAdapter(child: _OrderSummaryCard(order: order, lg: lg)),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── delivery info card ───────────────────────────────────────────
        SliverToBoxAdapter(child: _DeliveryInfoCard(order: order, lg: lg)),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── section label ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              lg.productsCount,
              style: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // ── products list ────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: order.items?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final product = order.items?[index];
              if (product == null) return const SizedBox.shrink();
              return _OrderProductTile(product: product, context: context);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatusBanner  — shows order code + colored status chip
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.order, required this.lg});

  final MeninkiOrder order;
  final AppLocalizations lg;

  // Map status strings to colors — adjust keys to match your API values
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return const Color(0xFF22C55E);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return Col.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // order code
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lg.orderNumber,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.code ?? '#—',
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),

            // status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order.status ?? '—',
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OrderSummaryCard  — costs breakdown
// ─────────────────────────────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order, required this.lg});

  final MeninkiOrder order;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    final taxes = order.taxes ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _LineItem(
              label: '${lg.productsCount} (${order.items?.length ?? 0})',
              value: '${order.total_cost?.toStringAsFixed(2) ?? '—'} TMT',
            ),
            const SizedBox(height: 10),
            _LineItem(
              label: lg.deliveryCost,
              value: '${order.delivery_cost?.toStringAsFixed(2) ?? '—'} TMT',
            ),

            // taxes
            if (taxes.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...taxes.map(
                (tax) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _LineItem(
                    label: tax.name?.trans(context) ?? 'Tax',
                    value: '${tax.tax?.toStringAsFixed(2) ?? '0.00'} TMT',
                  ),
                ),
              ),
            ],

            if (order.net_taxes != null) ...[
              const SizedBox(height: 10),
              _LineItem(label: lg.netTaxes, value: '${order.net_taxes?.toStringAsFixed(2)} TMT'),
            ],

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: const Color(0xFFEEEEEE), height: 1, thickness: 1),
            ),

            // grand total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lg.summary,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${order.total_cost?.toStringAsFixed(2) ?? '—'} TMT',
                  style: TextStyle(
                    color: Col.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DeliveryInfoCard  — address, contact, notes
// ─────────────────────────────────────────────────────────────────────────────

class _DeliveryInfoCard extends StatelessWidget {
  const _DeliveryInfoCard({required this.order, required this.lg});

  final MeninkiOrder order;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // address
            if (order.address != null)
              _InfoRow(icon: Icons.location_on_outlined, label: order.address!),

            if (order.address != null && (order.region_name != null || order.phonenumber != null))
              _Divider(),

            // region
            if (order.region_name != null)
              _InfoRow(icon: Icons.map_outlined, label: order.region_name!.trans(context) ?? '—'),

            if (order.region_name != null && order.phonenumber != null) _Divider(),

            // primary phone
            if (order.phonenumber != null)
              _InfoRow(icon: Icons.phone_outlined, label: order.phonenumber!),

            // additional phone
            if (order.additional_phonenumber != null &&
                order.additional_phonenumber!.isNotEmpty) ...[
              _Divider(),
              _InfoRow(
                icon: Icons.phone_forwarded_outlined,
                label: order.additional_phonenumber!,
                sublabel: lg.contactNumber,
              ),
            ],

            // notes
            if (order.additional_notes != null && order.additional_notes!.isNotEmpty) ...[
              _Divider(),
              _InfoRow(
                icon: Icons.notes_rounded,
                label: order.additional_notes!,
                sublabel: lg.extraInfo,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// small helper divider inside cards
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: const Color(0xFFEEEEEE), height: 1, thickness: 1),
    );
  }
}

// icon + text row used inside _DeliveryInfoCard
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.sublabel});

  final IconData icon;
  final String label;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Col.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Col.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sublabel != null)
                Text(
                  sublabel!,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (sublabel != null) const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LineItem  — reusable label/value row (same as PreparedBasketPage)
// ─────────────────────────────────────────────────────────────────────────────

class _LineItem extends StatelessWidget {
  const _LineItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OrderProductTile
// ─────────────────────────────────────────────────────────────────────────────

class _OrderProductTile extends StatelessWidget {
  const _OrderProductTile({required this.product, required this.context});

  final OrderProduct product;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── image ──────────────────────────────────────────────────
          if (product.file != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                // color: const Color(0xFFF0F0F0),
                child: MeninkiNetworkImage(
                  file: product.file!,
                  networkImageType: NetworkImageType.small,
                  fit: BoxFit.cover,
                ),
                // Uncomment when cover_image is available on OrderProduct:
                // child: product.cover_image != null
                //     ? MeninkiNetworkImage(
                //         file: product.cover_image!,
                //         networkImageType: NetworkImageType.medium,
                //         fit: BoxFit.cover,
                //       )
                //     : null,
              ),
            ),
          const SizedBox(width: 12),

          // ── details ────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title?.trans(context) ?? '',
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // quantity badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Col.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '× ${product.quantity}',
                    style: TextStyle(color: Col.primary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${product.price?.toStringAsFixed(2) ?? '—'} TMT',
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
