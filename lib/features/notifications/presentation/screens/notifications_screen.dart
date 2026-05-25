import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notif> _notifs = [
    _Notif(
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF22C55E),
      bgColor: const Color(0xFFDCFCE7),
      title: 'Booking Confirmed',
      body: 'Your Mobile Wash appointment for Oct 31 at 2:30 PM has been confirmed.',
      time: 'Just now',
      isRead: false,
    ),
    _Notif(
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFFEF3C7),
      title: 'Low Tire Pressure',
      body: 'Porsche 911 rear-left tire pressure detected at 28 PSI. Recommended: 34 PSI.',
      time: '1h ago',
      isRead: false,
    ),
    _Notif(
      icon: Icons.local_offer_outlined,
      iconColor: AppColors.primary,
      bgColor: const Color(0xFFEEF2FF),
      title: 'Summer Shine Package',
      body: 'Get 20% off full detailing this weekend only. Book before Sunday!',
      time: '3h ago',
      isRead: true,
    ),
    _Notif(
      icon: Icons.schedule,
      iconColor: const Color(0xFF8B5CF6),
      bgColor: const Color(0xFFF5F3FF),
      title: 'Service Reminder',
      body: 'BMW M5 oil change due in 200 miles. Schedule now to avoid penalties.',
      time: 'Yesterday',
      isRead: true,
    ),
    _Notif(
      icon: Icons.star_outline,
      iconColor: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFFEF3C7),
      title: 'Rate Your Experience',
      body: 'How was your Ceramic Coating service? Share your feedback.',
      time: '2 days ago',
      isRead: true,
    ),
    _Notif(
      icon: Icons.info_outline,
      iconColor: const Color(0xFF06B6D4),
      bgColor: const Color(0xFFECFEFF),
      title: 'New Services Available',
      body: 'Premium interior detailing packages are now available in your area.',
      time: '3 days ago',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifs.where((n) => !n.isRead).length;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.notificationsTitle,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () => setState(() {
                for (final n in _notifs) {
                  n.isRead = true;
                }
              }),
              child: Text(l10n.notificationsMarkAllRead,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
        ],
      ),
      body: _notifs.isEmpty
          ? _buildEmpty(l10n)
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (unread > 0) ...[
                  _SectionLabel(label: '${l10n.notificationsNew} • $unread'),
                  ..._notifs
                      .where((n) => !n.isRead)
                      .map((n) => _NotifTile(notif: n, onTap: () => _markRead(n))),
                  const SizedBox(height: 8),
                ],
                _SectionLabel(label: l10n.notificationsEarlier),
                ..._notifs
                    .where((n) => n.isRead)
                    .map((n) => _NotifTile(notif: n, onTap: () {})),
              ],
            ),
    );
  }

  void _markRead(_Notif n) => setState(() => n.isRead = true);

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
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Text(l10n.notificationsEmpty,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5)),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String body;
  final String time;
  bool isRead;

  _Notif({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
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
                  color: notif.bgColor,
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
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Text(notif.time,
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body,
                      style: GoogleFonts.inter(
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
