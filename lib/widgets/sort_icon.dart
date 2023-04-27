import 'package:annunci_lavoro_flutter/blocs/jobAds/bloc/job_ads_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SortIcon extends StatelessWidget {
  const SortIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredList = BlocProvider.of<JobAdsBloc>(context).jobAdsController;
    return ValueListenableBuilder<bool>(
      valueListenable: filteredList.isSortingEmpty,
      builder: (BuildContext context, bool isSortingEmpty, Widget? child) {
        return SizedBox(
          width: 50,
          child: Stack(
            children: [
              Text(
                'Sort',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ), //Icon(FontAwesomeIcons.arrowUpWideShort),
              isSortingEmpty
                  ? const SizedBox()
                  : Positioned(
                      bottom: 0,
                      right: 1,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.orangeAccent.shade700,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
