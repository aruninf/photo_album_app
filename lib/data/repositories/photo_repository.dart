import '../../core/services/api_service.dart';
import '../models/unsplash_photo_model.dart';

class PhotoRepository {
  final ApiService apiService;

  PhotoRepository(this.apiService);

  Future<List<UnsplashPhoto>> fetchPhotos({int page = 1, int perPage = 20, String? query}) async {
    final response = await apiService.get(
      query != null ? 'search/photos' : 'photos',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (query != null) 'query': query,
      },
    );

    final data = query != null ? response.data['results'] : response.data;
    return List<UnsplashPhoto>.from(data.map((json) => UnsplashPhoto.fromJson(json)));
  }
}
