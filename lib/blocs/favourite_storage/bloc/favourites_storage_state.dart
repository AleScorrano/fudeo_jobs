import 'package:annunci_lavoro_flutter/blocs/favourite_storage/bloc/favourites_storage_bloc.dart';
import 'package:annunci_lavoro_flutter/models/favourites_store_model.dart';
import 'package:equatable/equatable.dart';
/*
class FavouritesStorageState extends Equatable {
  final Set<String> favorites;

  const FavouritesStorageState({
    this.favorites = const {},
  });

  @override
  List<Object> get props => [favorites];

  FavouritesStorageState copyWith({
    Set<String>? favorites,
  }) {
    return FavouritesStorageState(
      favorites: favorites ?? this.favorites,
    );
  }

  factory FavouritesStorageState.fromJson(Map<String, dynamic> json) {
    return FavouritesStorageState(
      favorites: Set<String>.from(json['favorites']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': List<String>.from(favorites),
    };
  }
} */

class FavouritesStorageState extends Equatable {
  final Set<FavouriteStoreModel> favorites;

  const FavouritesStorageState({
    this.favorites = const {},
  });

  @override
  List<Object> get props => [favorites];

  FavouritesStorageState copyWith({
    Set<FavouriteStoreModel>? favorites,
  }) {
    return FavouritesStorageState(
      favorites: favorites ?? this.favorites,
    );
  }

  factory FavouritesStorageState.fromJson(Map<String, dynamic> json) {
    final favoritesList = json['favorites'] as List<dynamic>;
    final favoritesSet = favoritesList
        .map((e) => FavouriteStoreModel.fromJson(e as Map<String, dynamic>))
        .toSet();
    return FavouritesStorageState(
      favorites: favoritesSet,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': List<Map<String, dynamic>>.from(
        favorites.map((e) => e.toJson()),
      ),
    };
  }
}
