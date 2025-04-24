import 'package:equatable/equatable.dart';
import '../../data/models/unsplash_photo_model.dart';

abstract class PhotoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<UnsplashPhoto> photos;
  final bool hasMore;

  PhotoLoaded(this.photos, {this.hasMore = true});

  @override
  List<Object?> get props => [photos, hasMore];
}

class PhotoError extends PhotoState {
  final String message;

  PhotoError(this.message);

  @override
  List<Object?> get props => [message];
}
