import 'package:flutter/material.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/features/services/data/models/service_model.dart';

/// Opens the booking screen with a service context so Confirm stays enabled.
void openServiceBooking(
  BuildContext context, {
  required String id,
  required String title,
  required double price,
  String description = '',
  String category = 'general',
}) {
  Navigator.pushNamed(
    context,
    AppRoutes.createOrder,
    arguments: Service(
      id: id,
      name: title,
      description: description,
      price: price,
      category: category,
    ),
  );
}
