import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// نموذج بيانات الإشعار.
class AppNotification {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  /// إنشاء نسخة جديدة مع تعديل الحقول المحددة فقط.
  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      icon: icon,
      iconColor: iconColor,
      bgColor: bgColor,
      title: title,
      body: body,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// حالة الـ NotificationsCubit.
class NotificationsState {
  final List<AppNotification> notifications;
  NotificationsState(this.notifications);
}

/// Cubit إدارة حالة الإشعارات في التطبيق.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState([
    AppNotification(
      id: '1',
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF22C55E),
      bgColor: const Color(0xFF22C55E),
      title: 'Booking Confirmed',
      body: 'Your Mobile Wash appointment for Oct 31 at 2:30 PM has been confirmed.',
      time: 'Just now',
      isRead: false,
    ),
    AppNotification(
      id: '2',
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFF59E0B),
      title: 'Low Tire Pressure',
      body: 'Porsche 911 rear-left tire pressure detected at 28 PSI. Recommended: 34 PSI.',
      time: '1h ago',
      isRead: false,
    ),
    AppNotification(
      id: '3',
      icon: Icons.local_offer_outlined,
      iconColor: const Color(0xFF1D3C87),
      bgColor: const Color(0xFF1D3C87),
      title: 'Summer Shine Package',
      body: 'Get 20% off full detailing this weekend only. Book before Sunday!',
      time: '3h ago',
      isRead: true,
    ),
    AppNotification(
      id: '4',
      icon: Icons.schedule,
      iconColor: const Color(0xFF8B5CF6),
      bgColor: const Color(0xFF8B5CF6),
      title: 'Service Reminder',
      body: 'BMW M5 oil change due in 200 miles. Schedule now to avoid penalties.',
      time: 'Yesterday',
      isRead: true,
    ),
    AppNotification(
      id: '5',
      icon: Icons.star_outline,
      iconColor: const Color(0xFFF59E0B),
      bgColor: const Color(0xFFF59E0B),
      title: 'Rate Your Experience',
      body: 'How was your Ceramic Coating service? Share your feedback.',
      time: '2 days ago',
      isRead: true,
    ),
    AppNotification(
      id: '6',
      icon: Icons.info_outline,
      iconColor: const Color(0xFF06B6D4),
      bgColor: const Color(0xFF06B6D4),
      title: 'New Services Available',
      body: 'Premium interior detailing packages are now available in your area.',
      time: '3 days ago',
      isRead: true,
    ),
  ]));

  /// تحديد إشعار معين كمقروء عن طريق الـ [id].
  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    emit(NotificationsState(updated));
  }

  /// تحديد جميع الإشعارات كمقروءة.
  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(NotificationsState(updated));
  }

  /// عدد الإشعارات غير المقروءة.
  int get unreadCount => state.notifications.where((n) => !n.isRead).length;
}
