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
  final int total;
  final int currentPage;
  final int totalPages;

  const NewsLoaded(
    this.news, {
    this.total = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object?> get props => [news, total, currentPage, totalPages];
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

  Future<void> loadNews({int page = 1, int limit = 20}) async {
    if (isClosed) return;
    emit(const NewsLoading());
    final result = await _repository.getStoredNews(page: page, limit: limit);
    if (isClosed) return;
    if (result is Success) {
      final pageData = result.data!;
      emit(NewsLoaded(
        pageData.items,
        total: pageData.total,
        currentPage: pageData.currentPage,
        totalPages: pageData.totalPages,
      ));
    } else {
      emit(NewsError(result.failure!.message));
    }
  }

  Future<void> syncAndReload() async {
    if (isClosed) return;
    emit(const NewsLoading());
    final syncResult = await _repository.syncCarsNews();
    if (isClosed) return;
    if (syncResult is ResultFailure) {
      emit(NewsError(syncResult.failure!.message));
      return;
    }
    await loadNews();
  }
}
