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

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../global/widgets/meninki_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/basket_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PreparedBasketPage — Redesigned
// ─────────────────────────────────────────────────────────────────────────────

class PreparedBasketPage extends StatefulWidget {
  const PreparedBasketPage({super.key});

  @override
  State<PreparedBasketPage> createState() => _PreparedBasketPageState();
}

class _PreparedBasketPageState extends State<PreparedBasketPage> {
  PreparedBasket? preparedBasket;

  final TextEditingController _infoCont = TextEditingController();
  final TextEditingController _phoneCont = TextEditingController();

  @override
  void dispose() {
    _infoCont.dispose();
    _phoneCont.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  void _submitOrder(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<OrderCreateCubit>().createOrder({
      "address_id": preparedBasket?.address?.id,
      if (_infoCont.text.trim().isNotEmpty) "additional_notes": _infoCont.text.trim(),
      if (_phoneCont.text.trim().isNotEmpty) "additional_phonenumber": _phoneCont.text.trim(),
    });
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return BlocListener<OrderCreateCubit, OrderCreateState>(
      listener: (context, state) {
        if (state is OrderCreateSuccess) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: lg.successfullyCreated,
            isError: false,
          );
          context.read<GetBasketCubit>().getMyBasket();
          Go.popGo(Routes.ordersPage);
        }
        if (state is OrderCreateFailed) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: state.failure.message ?? lg.smthWentWrong,
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        // ── app bar ──────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A), size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            lg.confirmOrder,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: true,
        ),
        // ── body ─────────────────────────────────────────────────────────
        body: BlocBuilder<PrepareBasketCubit, PrepareBasketState>(
          builder: (context, state) {
            if (state is PrepareBasketLoading) {
              return const Center(child: CircularProgressIndicator(color: Col.primary));
            }
            if (state is PrepareBasketSuccess) {
              preparedBasket = state.preparedBasket;
              return _buildContent(context, lg, state.preparedBasket);
            }
            return const SizedBox.shrink();
          },
        ),
        // ── confirm button ────────────────────────────────────────────────
        bottomNavigationBar: _ConfirmButton(onTap: () => _submitOrder(context)),
      ),
    );
  }

  // ── content ──────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, AppLocalizations lg, PreparedBasket basket) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ── order summary card ───────────────────────────────────────────
        SliverToBoxAdapter(child: _SummaryCard(basket: basket, lg: lg)),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── additional fields ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _AdditionalFields(infoCont: _infoCont, phoneCont: _phoneCont, lg: lg),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── section label ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              lg.productsCount, // reuse or add "yourItems" key
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
            itemCount: basket.baskets?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final product = basket.baskets?[index];
              if (product == null) return const SizedBox.shrink();
              return _ProductTile(product: product);
            },
          ),
        ),

        // bottom spacing for the confirm button
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SummaryCard
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.basket, required this.lg});

  final PreparedBasket basket;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    final deliveryCost = basket.address?.region?.delivery_cost?.toStringAsFixed(2) ?? '—';
    final subtotal = basket.summary();
    final taxes = basket.basket_taxes ?? [];

    // compute grand total
    num total = subtotal;
    final deliveryNum = basket.address?.region?.delivery_cost ?? 0.0;
    total += deliveryNum;
    for (final tax in taxes) {
      total += tax.tax ?? 0.0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── delivery address ───────────────────────────────────────
            if (basket.address != null) ...[
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Col.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.location_on_rounded, color: Col.primary, size: 17),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      basket.address!.info ?? '',
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: const Color(0xFFEEEEEE), height: 1, thickness: 1),
              ),
            ],

            // ── line items ─────────────────────────────────────────────
            _LineItem(
              label: '${lg.productsCount} (${basket.baskets?.length ?? 0})',
              value: '${subtotal.toStringAsFixed(2)} TMT',
            ),
            const SizedBox(height: 10),
            _LineItem(label: lg.deliveryCost, value: '$deliveryCost TMT'),

            // ── taxes ──────────────────────────────────────────────────
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: const Color(0xFFEEEEEE), height: 1, thickness: 1),
            ),

            // ── total ──────────────────────────────────────────────────
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
                  '${total.toStringAsFixed(2)} TMT',
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
// _LineItem  — label / value row inside summary
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
// _AdditionalFields
// ─────────────────────────────────────────────────────────────────────────────

class _AdditionalFields extends StatelessWidget {
  const _AdditionalFields({required this.infoCont, required this.phoneCont, required this.lg});

  final TextEditingController infoCont;
  final TextEditingController phoneCont;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── phone ──────────────────────────────────────────────────
            Text(
              lg.contactNumber,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: phoneCont,
              prefix: '+993 ',
              hint: 'XX XXXXXX',
              keyboardType: TextInputType.phone,
              icon: Icons.phone_outlined,
            ),

            const SizedBox(height: 16),

            // ── notes ──────────────────────────────────────────────────
            Text(
              lg.extraInfo, // make sure this key exists in your l10n
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: infoCont,
              hint: 'e.g. Come after 4 o\'clock',
              maxLines: 3,
              icon: Icons.notes_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StyledTextField
// ─────────────────────────────────────────────────────────────────────────────

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.prefix,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? prefix;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB), size: 18),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Col.primary, width: 1.4),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProductTile
// ─────────────────────────────────────────────────────────────────────────────

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final BasketProduct product;

  @override
  Widget build(BuildContext context) {
    final composition = product.composition;
    final prod = composition?.product;
    final hasDiscount = (prod?.discount != null && (prod!.discount! > 0));

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
          // ── image ────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child:
                  prod?.cover_image != null
                      ? MeninkiNetworkImage(
                        file: prod!.cover_image!,
                        networkImageType: NetworkImageType.medium,
                        fit: BoxFit.cover,
                      )
                      : Container(color: const Color(0xFFF0F0F0)),
            ),
          ),
          const SizedBox(width: 12),

          // ── details ──────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  composition?.title?.trans(context) ?? '',
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

                // qty badge
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

                // price row
                Row(
                  children: [
                    Text(
                      '${prod?.price?.toStringAsFixed(2) ?? '—'} TMT',
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${prod!.discount?.toStringAsFixed(2)} TMT',
                        style: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConfirmButton
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      builder: (context, state) {
        final isLoading = state is OrderCreateLoading;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onTap,
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.black.withOpacity(0.1),
                child: Ink(
                  height: 54,
                  decoration: BoxDecoration(
                    color: isLoading ? Col.primary.withOpacity(0.7) : Col.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              lg.continueProcess,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
