import 'package:annunci_lavoro_flutter/blocs/favourites/bloc/favourites_bloc.dart';
import 'package:annunci_lavoro_flutter/blocs/freelanceAds/bloc/freelance_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/blocs/jobAds/bloc/job_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/blocs/favourite_storage/bloc/favourites_storage_bloc.dart';
import 'package:annunci_lavoro_flutter/cubits/dark_mode_cubit.dart';

import 'package:annunci_lavoro_flutter/mappers/freelance_positions_ads_mapper.dart';
import 'package:annunci_lavoro_flutter/mappers/job_positions_ads_mapper.dart';
import 'package:annunci_lavoro_flutter/repositories/ads_repository.dart';
import 'package:annunci_lavoro_flutter/services/network/jobAdsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;
  const DependencyInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) => _providers(
        child: _mappers(
          child: _repositories(
            child: _blocs(
              child: child,
            ),
          ),
        ),
      );
  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<AdsService>(
            create: (_) => AdsService(),
          ),
          Provider<FavouritesStorageBloc>(
              create: (_) => FavouritesStorageBloc()),
        ],
        child: child,
      );

  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [
          Provider(
            create: (context) =>
                JobPositionsAdsMapper(favouritesBloc: context.read()),
          ),
          Provider(
            create: (context) =>
                FreeLancePositionsAdsMapper(favouritesBloc: context.read()),
          ),
        ],
        child: child,
      );

  Widget _repositories({required Widget child}) =>
      MultiRepositoryProvider(providers: [
        RepositoryProvider<AdsRepository>(
          create: (context) => AdsRepository(
            jobPositionsAdsMapper: context.read(),
            freeLancePositionsAdsMapper: context.read(),
            jobAdsService: context.read(),
            favouritesStorageBloc: context.read(),
          ),
        ),
      ], child: child);

  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<JobAdsBloc>(
            lazy: false,
            create: (context) => JobAdsBloc(
              adsRepository: context.read(),
            )..fetchAds(),
          ),
          BlocProvider<FreelanceAdsBloc>(
            lazy: false,
            create: (context) => FreelanceAdsBloc(
              adsRepository: context.read(),
            )..fetchAds(),
          ),
          BlocProvider(
            create: (_) => DarkModeCubit(),
          ),
        ],
        child: child,
      );
}
