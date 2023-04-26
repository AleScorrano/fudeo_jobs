import 'dart:async';

import 'package:annunci_lavoro_flutter/errors/repository_error.dart';
import 'package:annunci_lavoro_flutter/misc/freelance_ads_controller.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/repositories/ads_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'freelance_ads_event.dart';
part 'freelance_ads_state.dart';

class FreelanceAdsBloc extends Bloc<FreelanceAdsEvent, FreelanceAdsState> {
  final AdsRepository adsRepository;
  final FreeLanceAdsController freeLanceAdsController =
      FreeLanceAdsController([]);

  FreelanceAdsBloc({required this.adsRepository})
      : super(FreelanceAdsInitial()) {
    on<FetchInitialFreelanceAdsEvent>(_fetchInitialData);
    on<FetchMoreFreelanceAdsEvent>(_moreAds);
  }

  FutureOr<void> _fetchInitialData(FetchInitialFreelanceAdsEvent event,
      Emitter<FreelanceAdsState> emit) async {
    emit(InitfreelanceAdsState());
    try {
      final freelanceAds = await adsRepository.freeLancePositions();
      addItems(freelanceAds);
      emit(FetchedFreelanceAdsState());
    } on RepositoryError catch (error) {
      emit(ErrorFreelanceAdsState(error.errorMessage));
    } catch (error) {
      emit(const ErrorFreelanceAdsState());
    }
  }

  FutureOr<void> _moreAds(
      FetchMoreFreelanceAdsEvent event, Emitter<FreelanceAdsState> emit) async {
    try {
      if (adsRepository.hasMoreFreelanceAds == false) {
        emit(NoMoreFreelanceAdsState());
        return;
      }
      emit(FetchingMoreFreelanceAdsState());
      final freelanceAds = await adsRepository.freeLancePositions();
      addItems(freelanceAds);
      emit(InitfreelanceAdsState());
    } on RepositoryError catch (error) {
      emit(ErrorFreelanceAdsState(error.errorMessage));
    } catch (error) {
      emit(const ErrorFreelanceAdsState());
    }
  }

  void addItems(List<FreeLancePosition> items) {
    freeLanceAdsController.addItems(items);
  }

  void fetchAds() => add(FetchInitialFreelanceAdsEvent());
  void moreAds() => add(FetchMoreFreelanceAdsEvent());
}
