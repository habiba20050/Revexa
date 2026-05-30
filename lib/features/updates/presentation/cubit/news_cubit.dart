import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/updates/data/models/news_item_model.dart';
import 'package:revexa/features/updates/data/repositories/news_repository.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsLoaded extends NewsState {
  final List<NewsItem> news;
  const NewsLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;

  NewsCubit(this._repository) : super(const NewsInitial());

  Future<void> loadNews() async {
    if (isClosed) return;
    emit(const NewsLoading());
    final result = await _repository.getLatestNews();
    if (isClosed) return;
    if (result is Success) {
      emit(NewsLoaded(result.data!));
    } else {
      emit(NewsError(result.failure!.message));
    }
  }
}
