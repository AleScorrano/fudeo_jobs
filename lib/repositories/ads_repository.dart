import 'package:annunci_lavoro_flutter/blocs/favourite_storage/bloc/favourites_storage_bloc.dart';
import 'package:annunci_lavoro_flutter/errors/network_error.dart';
import 'package:annunci_lavoro_flutter/errors/repository_error.dart';
import 'package:annunci_lavoro_flutter/mappers/freelance_positions_ads_mapper.dart';
import 'package:annunci_lavoro_flutter/mappers/job_positions_ads_mapper.dart';
import 'package:annunci_lavoro_flutter/models/favourites_store_model.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:annunci_lavoro_flutter/services/network/jobAdsService.dart';

class AdsRepository {
  final JobPositionsAdsMapper jobPositionsAdsMapper;
  final FreeLancePositionsAdsMapper freeLancePositionsAdsMapper;
  final AdsService jobAdsService;
  final FavouritesStorageBloc favouritesStorageBloc;
  String? jobAdsNextCursor;
  String? freeLanceAdsNextCursor;
  bool hasMoreJobAds = false;
  bool hasMoreFreelanceAds = false;
  AdsRepository({
    required this.jobPositionsAdsMapper,
    required this.freeLancePositionsAdsMapper,
    required this.jobAdsService,
    required this.favouritesStorageBloc,
  });

  Future<List<JobPosition>> jobPositions() async {
    try {
      final response = await jobAdsService.getJobPositionsAds(jobAdsNextCursor);
      jobAdsNextCursor = response.pagination.nextCursor;
      hasMoreJobAds = response.pagination.hasMore;
      return response.results
          .map(jobPositionsAdsMapper.toModel)
          .toList(growable: false);
    } on NetworkError catch (e) {
      throw RepositoryError(e.reasonPhrase);
    } catch (error) {
      throw RepositoryError();
    }
  }

  Future<List<FreeLancePosition>> freeLancePositions() async {
    try {
      final response =
          await jobAdsService.getfreelanceAds(freeLanceAdsNextCursor);
      hasMoreFreelanceAds = response.pagination.hasMore;
      return response.results
          .map(freeLancePositionsAdsMapper.toModel)
          .toList(growable: false);
    } on NetworkError catch (e) {
      throw RepositoryError(e.reasonPhrase);
    } catch (error) {
      throw RepositoryError();
    }
  }

  Future<List<JobPosition>> favouritesJobPositionsAds(
      List<JobPosition> currentList) async {
    try {
      List<JobPosition> favList = [];
      List<FavouriteStoreModel> favourites =
          favouritesStorageBloc.getFavourites();
//* inizializzo la lista da ritornare con gli annunci già presenti in memoria

      favList.addAll(currentList.where((element) => element.isFavourite));

//* rimuovo dalla lista dei favoriti da scaricare gli annunci che ho gia presenti in memoria
      favourites.removeWhere(
          (element) => favList.any((fav) => fav.metaData.id == element.id));

//* scarico eventuali annunci che non sono già stati scaricati.
      await Future.wait(
        favourites.map(
          (favAds) async {
            if (favAds.adsType == 'job_position') {
              final favDTO =
                  await jobAdsService.getJobPositionsFavourite(favAds.id);
              if (favDTO != null) {
                favList.add(jobPositionsAdsMapper.toModel(favDTO));
              }
            }
          },
        ),
      );
      return favList;
    } on NetworkError catch (e) {
      throw RepositoryError(e.reasonPhrase);
    } catch (error) {
      throw RepositoryError();
    }
  }

  Future<List<FreeLancePosition>> favouritesFreelanceAds(
      List<FreeLancePosition> currentList) async {
    try {
      List<FreeLancePosition> favList = [];
      List<FavouriteStoreModel> favourites =
          favouritesStorageBloc.getFavourites();

//* inizializzo la lista da ritornare con gli annunci già presenti in memoria

      favList.addAll(currentList.where((element) => element.isFavourite));

//* rimuovo dalla lista dei favoriti da scaricare gli annunci che ho gia presenti in memoria
      favourites.removeWhere(
          (element) => favList.any((fav) => fav.metaData.id == element.id));

//* scarico eventuali annunci che non sono già stati scaricati.

      await Future.wait(favourites.map((favAds) async {
        if (favAds.adsType == 'freelance') {
          final favDTO = await jobAdsService.getFreelanceFavourite(favAds.id);
          if (favDTO != null) {
            favList.add(freeLancePositionsAdsMapper.toModel(favDTO));
          }
        }
      }));
      return favList;
    } on NetworkError catch (e) {
      throw RepositoryError(e.reasonPhrase);
    } catch (error) {
      throw RepositoryError();
    }
  }
}
