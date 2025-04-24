import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/unsplash_photo_model.dart';
import '../../data/repositories/photo_repository.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final PhotoRepository repository;
  int _page = 1;
  bool _isFetching = false;
  String? _currentQuery;

  PhotoCubit(this.repository) : super(PhotoInitial());

  void fetchPhotos({bool isRefresh = false, String? query}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isRefresh || query != _currentQuery) {
      _page = 1;
      _currentQuery = query;
      emit(PhotoLoading());
    }

    try {
      final photos = await repository.fetchPhotos(page: _page, query: _currentQuery);
      if (state is PhotoLoaded && !isRefresh) {
        final currentPhotos = (state as PhotoLoaded).photos;
        emit(PhotoLoaded([...currentPhotos, ...photos], hasMore: photos.isNotEmpty));
      } else {
        emit(PhotoLoaded(photos, hasMore: photos.isNotEmpty));
      }
      if (photos.isNotEmpty) _page++;
    } catch (e) {
      emit(PhotoError(e.toString()));
    }

    _isFetching = false;
  }

  void refreshPhotos([String? query]) => fetchPhotos(isRefresh: true, query: query);
}