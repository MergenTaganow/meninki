import 'package:flutter/material.dart';

import '../../basket/models/basket_product.dart';
import '../../global/widgets/meninki_network_image.dart';

class _StatusTheme {
  const _StatusTheme({
    required this.label,
    required this.icon,
    required this.cardGradient,
    required this.border,
    required this.stripColor,
    required this.badgeBg,
    required this.badgeFg,
    required this.codeBg,
    required this.codeFg,
    required this.quantityBg,
    required this.quantityFg,
    required this.titleColor,
    required this.priceColor,
    required this.isFaded,
  });

  final String label;
  final IconData icon;
  final List<Color> cardGradient;
  final Color border;
  final Color stripColor;
  final Color badgeBg;
  final Color badgeFg;
  final Color codeBg;
  final Color codeFg;
  final Color quantityBg;
  final Color quantityFg;
  final Color titleColor;
  final Color priceColor;
  final bool isFaded;

  static _StatusTheme of(String? status) => switch (status) {
    'pending' => _StatusTheme(
      label: 'Pending', icon: Icons.hourglass_top_rounded,
      cardGradient: [const Color(0xFFFFFDF5), const Color(0xFFFFF8E1)],
      border: const Color(0xFFFFD54F), stripColor: const Color(0xFFF59E0B),
      badgeBg: const Color(0xFFFFF3CD), badgeFg: const Color(0xFFB45309),
      codeBg: const Color(0x33FFD54F), codeFg: const Color(0xFF92400E),
      quantityBg: const Color(0x26FBBF24), quantityFg: const Color(0xFFB45309),
      titleColor: const Color(0xFF1A1A1A), priceColor: const Color(0xFF1A1A1A),
      isFaded: false,
    ),
    'on_delivery' => _StatusTheme(
      label: 'On Delivery', icon: Icons.local_shipping_rounded,
      cardGradient: [const Color(0xFFF5F9FF), const Color(0xFFEBF4FF)],
      border: const Color(0xFF60A5FA), stripColor: const Color(0xFF3B82F6),
      badgeBg: const Color(0xFFDBEAFE), badgeFg: const Color(0xFF1D4ED8),
      codeBg: const Color(0x2660A5FA), codeFg: const Color(0xFF1E40AF),
      quantityBg: const Color(0x1F3B82F6), quantityFg: const Color(0xFF1D4ED8),
      titleColor: const Color(0xFF1A1A1A), priceColor: const Color(0xFF1A1A1A),
      isFaded: false,
    ),
    'client_received' => _StatusTheme(
      label: 'Received', icon: Icons.check_circle_rounded,
      cardGradient: [const Color(0xFFF4FDF6), const Color(0xFFECFDF0)],
      border: const Color(0xFF6EE7B7), stripColor: const Color(0xFF10B981),
      badgeBg: const Color(0xFFD1FAE5), badgeFg: const Color(0xFF065F46),
      codeBg: const Color(0x336EE7B7), codeFg: const Color(0xFF064E3B),
      quantityBg: const Color(0x1F10B981), quantityFg: const Color(0xFF065F46),
      titleColor: const Color(0xFF1A1A1A), priceColor: const Color(0xFF1A1A1A),
      isFaded: false,
    ),
    'cancelled' => _StatusTheme(
      label: 'Cancelled', icon: Icons.cancel_rounded,
      cardGradient: [const Color(0xFFFFF7F7), const Color(0xFFFEF2F2)],
      border: const Color(0xFFFCA5A5), stripColor: const Color(0xFFEF4444),
      badgeBg: const Color(0xFFFEE2E2), badgeFg: const Color(0xFF991B1B),
      codeBg: const Color(0x33FCA5A5), codeFg: const Color(0xFF7F1D1D),
      quantityBg: const Color(0x1AEF4444), quantityFg: const Color(0xFF991B1B),
      titleColor: const Color(0xFF9CA3AF), priceColor: const Color(0xFF9CA3AF),
      isFaded: true,
    ),
    'rejected' => _StatusTheme(
      label: 'Rejected', icon: Icons.block_rounded,
      cardGradient: [const Color(0xFFFAF5FF), const Color(0xFFF5F0FF)],
      border: const Color(0xFFC084FC), stripColor: const Color(0xFFA855F7),
      badgeBg: const Color(0xFFEDE9FE), badgeFg: const Color(0xFF5B21B6),
      codeBg: const Color(0x26C084FC), codeFg: const Color(0xFF4C1D95),
      quantityBg: const Color(0x1AA855F7), quantityFg: const Color(0xFF5B21B6),
      titleColor: const Color(0xFF9CA3AF), priceColor: const Color(0xFF9CA3AF),
      isFaded: true,
    ),
    _ => _StatusTheme(
      label: status ?? '—', icon: Icons.help_outline_rounded,
      cardGradient: [Colors.white, const Color(0xFFF9F9F9)],
      border: const Color(0xFFEEEEEE), stripColor: const Color(0xFFD1D5DB),
      badgeBg: const Color(0xFFF3F4F6), badgeFg: const Color(0xFF6B7280),
      codeBg: const Color(0xFFF3F4F6), codeFg: const Color(0xFF6B7280),
      quantityBg: const Color(0xFFF3F4F6), quantityFg: const Color(0xFF6B7280),
      titleColor: const Color(0xFF1A1A1A), priceColor: const Color(0xFF1A1A1A),
      isFaded: false,
    ),
  };
}

class MarketOrderProductTile extends StatelessWidget {
  const MarketOrderProductTile({
    required this.product,
    required this.context,
  });

  final OrderProduct product;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    final t = _StatusTheme.of(product.status);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: t.cardGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: t.stripColor.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── left accent strip ─────────────────────────────────
              Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [t.stripColor, t.stripColor.withOpacity(0.4)],
                  ),
                ),
              ),

              // ── content ───────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // top row: order code + status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // order code
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: t.codeBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '# ${product.order?.code ?? '—'}',
                              style: TextStyle(
                                color: t.codeFg,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),

                          // status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: t.badgeBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(t.icon, size: 12, color: t.badgeFg),
                                const SizedBox(width: 4),
                                Text(
                                  t.label,
                                  style: TextStyle(
                                    color: t.badgeFg,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // product row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image
                          if (product.file != null)
                            Opacity(
                              opacity: t.isFaded ? 0.45 : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: t.border, width: 1.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: MeninkiNetworkImage(
                                      borderRadius: 13,
                                      file: product.file!,
                                      networkImageType: NetworkImageType.small,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),

                          // details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title?.trans(context) ?? '',
                                  style: TextStyle(
                                    color: t.titleColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                    decoration: t.isFaded ? TextDecoration.lineThrough : null,
                                    decorationColor: const Color(0xFF9CA3AF).withOpacity(0.5),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),

                                // quantity badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: t.quantityBg,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    '× ${product.quantity}',
                                    style: TextStyle(
                                      color: t.quantityFg,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // price
                                Text(
                                  '${product.price?.toStringAsFixed(2) ?? '—'} TMT',
                                  style: TextStyle(
                                    color: t.priceColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    decoration: t.isFaded ? TextDecoration.lineThrough : null,
                                    decorationColor: const Color(0xFF9CA3AF).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}