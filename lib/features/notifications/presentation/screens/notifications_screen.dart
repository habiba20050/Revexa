import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:revexa/l10n/app_localizations.dart';

/// شاشة الإشعارات (Notifications Screen).
/// تعرض قائمة بالإشعارات مقسمة إلى "جديد" و"السابق" مع إمكانية تحديد الكل كمقروء أو قراءة إشعار فردي.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationsCubit = context.watch<NotificationsCubit>();
    final notifs = notificationsCubit.state.notifications;
    final unread = notificationsCubit.unreadCount;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.notificationsTitle,
            style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () => context.read<NotificationsCubit>().markAllAsRead(),
              child: Text(l10n.notificationsMarkAllRead,
                  style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? _buildEmpty(l10n)
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (unread > 0) ...[
                  _SectionLabel(label: '${l10n.notificationsNew} • $unread'),
                  ...notifs
                      .where((n) => !n.isRead)
                      .map((n) => _NotifTile(
                            notif: n,
                            onTap: () => context.read<NotificationsCubit>().markAsRead(n.id),
                          )),
                  const SizedBox(height: 8),
                ],
                _SectionLabel(label: l10n.notificationsEarlier),
                ...notifs
                    .where((n) => n.isRead)
                    .map((n) => _NotifTile(
                          notif: n,
                          onTap: () {},
                        )),
              ],
            ),
    );
  }

  /// واجهة تعرض عندما تكون قائمة الإشعارات فارغة تماماً.
  Widget _buildEmpty(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle),
            child: Icon(Icons.notifications_none_rounded,
                color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text(l10n.notificationsAllCaughtUp,
              style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Text(l10n.notificationsEmpty,
              style: GoogleFonts.urbanist(
                  fontSize: 14, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// ويدجت تسمية القسم (مثل: جديد / السابقة) داخل القائمة.
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(label,
          style: GoogleFonts.urbanist(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5)),
    );
  }
}

/// بطاقة عرض إشعار واحد داخل القائمة.
class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.isRead ? AppColors.outline : AppColors.primary.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: notif.bgColor.withValues(alpha: AppColors.isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(notif.icon, color: notif.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(notif.title,
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Text(notif.time,
                          style: GoogleFonts.urbanist(
                              fontSize: 10,
                              color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body,
                      style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: AppColors.secondary,
                          height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (!notif.isRead) ...[
              const SizedBox(width: 8),
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle)),
            ],
          ],
        ),
      ),
    );
  }
}
