import 'package:equatable/equatable.dart';

class AdEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? actionUrl;
  final bool isActive;

  const AdEntity({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.actionUrl,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        actionUrl,
        isActive,
      ];
}
