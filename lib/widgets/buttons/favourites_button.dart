import 'package:annunci_lavoro_flutter/blocs/favourite_storage/bloc/favourites_storage_bloc.dart';
import 'package:annunci_lavoro_flutter/blocs/freelanceAds/bloc/freelance_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/blocs/jobAds/bloc/job_ads_bloc.dart';
import 'package:annunci_lavoro_flutter/models/favourites_store_model.dart';
import 'package:annunci_lavoro_flutter/models/ads_model.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:annunci_lavoro_flutter/models/job_positions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final AdsModel ads;

  const FavoriteButton({
    super.key,
    required this.ads,
  });

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _sizeAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _sizeAnimation.value,
          child: child,
        );
      },
      child: widget.ads.isFavourite
          ? IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                _removeFromFavourite();
                _controller.reset();
                _controller.reverse();
                setState(() {
                  widget.ads.isFavourite = false;
                });
              },
              icon: const Icon(
                Icons.favorite,
                size: 30,
              ),
              color: Colors.red,
            )
          : IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                _addToFavourite();
                _controller.reset();
                _controller.forward();
                setState(() {
                  widget.ads.isFavourite = true;
                });
              },
              icon: const Icon(
                Icons.favorite_border,
                size: 30,
              ),
              color: Colors.red,
            ),
    );
  }

  void _addToFavourite() {
    setState(() {});
    if (widget.ads.runtimeType == JobPosition) {
      BlocProvider.of<JobAdsBloc>(context)
          .jobAdsController
          .addToFavorite(widget.ads.metaData.id);
    } else if (widget.ads.runtimeType == FreeLancePosition) {
      BlocProvider.of<FreelanceAdsBloc>(context)
          .freeLanceAdsController
          .addToFavorite(widget.ads.metaData.id);
    }
    BlocProvider.of<FavouritesStorageBloc>(context).addToFavourite(
        FavouriteStoreModel(
            dataBaseId: widget.ads.metaData.dataBaseId,
            id: widget.ads.metaData.id));
  }

  void _removeFromFavourite() {
    setState(() {});
    if (widget.ads.runtimeType == JobPosition) {
      BlocProvider.of<JobAdsBloc>(context)
          .jobAdsController
          .removeFromFavorite(widget.ads.metaData.id);
    } else if (widget.ads.runtimeType == FreeLancePosition) {
      BlocProvider.of<FreelanceAdsBloc>(context)
          .freeLanceAdsController
          .removeFromFavorite(widget.ads.metaData.id);
    }

    BlocProvider.of<FavouritesStorageBloc>(context).removeFromFavourite(
        FavouriteStoreModel(
            dataBaseId: widget.ads.metaData.dataBaseId,
            id: widget.ads.metaData.id));
  }
}
