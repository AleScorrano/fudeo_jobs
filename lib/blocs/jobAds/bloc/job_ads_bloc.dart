import 'dart:async';
import 'package:annunci_lavoro_flutter/errors/repository_error.dart';
import 'package:annunci_lavoro_flutter/misc/job_ads_controller.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:annunci_lavoro_flutter/repositories/ads_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'job_ads_event.dart';
part 'job_ads_state.dart';

class JobAdsBloc extends Bloc<JobAdsEvent, JobAdsState> {
  final AdsRepository adsRepository;
  final JobAdsController jobAdsController = JobAdsController([]);

  JobAdsBloc({required this.adsRepository}) : super(JobAdsInitial()) {
    on<FetchInitialJobAdsEvent>(_fetchInitialData);
    on<FetchMoreJobAdsEvent>(_moreAds);
  }

  FutureOr<void> _fetchInitialData(
      FetchInitialJobAdsEvent event, Emitter<JobAdsState> emit) async {
    emit(InitJobAdsState());
    try {
      final jobAds = await adsRepository.jobPositions();
      addItems(jobAds);
      emit(FetchedJobAdsState());
    } on RepositoryError catch (error) {
      emit(ErrorJobAdsState(error.errorMessage));
    } catch (error) {
      emit(const ErrorJobAdsState());
    }
  }

  FutureOr<void> _moreAds(
      FetchMoreJobAdsEvent event, Emitter<JobAdsState> emit) async {
    try {
      if (adsRepository.hasMoreJobAds == false) {
        emit(NoMoreJobAdsState());
        return;
      }
      emit(FetchingMoreJobAdsState());
      final jobAds = await adsRepository.jobPositions();
      addItems(jobAds);
      emit(InitJobAdsState());
    } on RepositoryError catch (error) {
      emit(ErrorJobAdsState(error.errorMessage));
    } catch (error) {
      emit(const ErrorJobAdsState());
    }
  }

  void addItems(List<JobPosition> items) {
    jobAdsController.addItems(items);
  }

  void fetchAds() => add(FetchInitialJobAdsEvent());
  void moreAds() => add(FetchMoreJobAdsEvent());
}
