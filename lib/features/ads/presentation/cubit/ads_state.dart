import 'package:equatable/equatable.dart';
import 'package:revexa/features/ads/domain/entities/ad_entity.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {
  const AdsInitial();
}

class AdsLoading extends AdsState {
  const AdsLoading();
}

class AdsLoaded extends AdsState {
  final List<AdEntity> ads;
  const AdsLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);

  @override
  List<Object?> get props => [message];
}
