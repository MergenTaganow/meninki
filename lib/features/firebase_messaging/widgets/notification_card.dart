// ─────────────────────────────────────────────────────────────────────────────
// NotificationCard — Light theme, consistent with previous pages
// ─────────────────────────────────────────────────────────────────────────────

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/api.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../models/notification_meninki.dart';
import '../notif_helper.dart';
// ─────────────────────────────────────────────────────────────────────────────
// NotificationCard — Light theme, consistent with previous pages
// ─────────────────────────────────────────────────────────────────────────────

class NotificationCard extends StatefulWidget {
  final NotificationMeninki notif;
  const NotificationCard(this.notif, {super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _expanded = false;

  // ── icon per notification type ───────────────────────────────────────────
  IconData _typeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.receipt_long_outlined;
      case 'promo':
      case 'adds':
        return Icons.local_offer_outlined;
      case 'reel':
        return Icons.play_circle_outline_rounded;
      case 'profile':
        return Icons.person_outline_rounded;
      case 'market':
        return Icons.storefront_outlined;
      case 'appeal':
        return Icons.flag_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notif = widget.notif;
    final bool isRead = notif.is_read ?? true;
    final bool hasImage = notif.image_url != null;
    final String description =
    (notif.description ?? '').trim().replaceAll('  ', ' ');
    final bool hasDescription = description.isNotEmpty;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => NotifHelper.onTap(context: context, notif: notif),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? const Color(0xFFEEEEEE)
                  : Col.primary.withOpacity(0.35),
              width: isRead ? 1 : 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isRead ? 0.03 : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── left: type icon or image ─────────────────────────────
              _LeadingWidget(
                notif: notif,
                isRead: isRead,
                typeIcon: _typeIcon(notif.type),
                hasImage: hasImage,
              ),

              const SizedBox(width: 12),

              // ── right: content ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title row + unread dot
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            notif.title ?? '',
                            style: TextStyle(
                              color: const Color(0xFF1A1A1A),
                              fontSize: 14,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Col.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // description (collapsible — tap "..." to expand)
                    if (hasDescription) ...[
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: Text(
                            description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          secondChild: Text(
                            description,
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    // timestamp
                    if (notif.createdAt != null)
                      Text(
                        _formatDate(notif.createdAt!),
                        style: const TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── date formatter ───────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LeadingWidget — icon badge OR network image thumbnail
// ─────────────────────────────────────────────────────────────────────────────

class _LeadingWidget extends StatelessWidget {
  const _LeadingWidget({
    required this.notif,
    required this.isRead,
    required this.typeIcon,
    required this.hasImage,
  });

  final NotificationMeninki notif;
  final bool isRead;
  final IconData typeIcon;
  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: '$baseUrl/public/${notif.image_url}',
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: 52,
            height: 52,
            color: const Color(0xFFF0F0F0),
          ),
          errorWidget: (_, __, ___) => _IconBadge(
            icon: typeIcon,
            isRead: isRead,
          ),
        ),
      );
    }

    return _IconBadge(icon: typeIcon, isRead: isRead);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _IconBadge — tinted square icon, read vs unread variant
// ─────────────────────────────────────────────────────────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.isRead});

  final IconData icon;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isRead
            ? const Color(0xFFF3F3F3)
            : Col.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isRead ? const Color(0xFFAAAAAA) : Col.primary,
      ),
    );
  }
}