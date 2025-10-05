import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../services/mock_data_service.dart';

class NotificationsState {
  final List<Notification> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<Notification>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final MockDataService _mockDataService;

  NotificationsNotifier(this._mockDataService) : super(NotificationsState());

  Future<void> loadNotifications({String? userId}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (userId == null) throw Exception('User not authenticated');

      final notifications = await _mockDataService.getNotifications(
        userId: userId,
      );

      final unreadCount = notifications.where((n) => !n.read).length;

      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications',
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(read: true);
        }
        return notification;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.read).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark notification as read',
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final updatedNotifications = state.notifications
          .map((notification) => notification.copyWith(read: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark all notifications as read',
      );
    }
  }

  void clearNotifications() {
    state = NotificationsState();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(MockDataService());
});
