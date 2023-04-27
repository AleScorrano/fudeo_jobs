import 'package:annunci_lavoro_flutter/models/ads_description.dart';
import 'package:annunci_lavoro_flutter/models/matadata.dart';
import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
abstract class AdsModel extends Equatable {
  final AdsMetaData metaData;
  final String adsTitle;
  final RichTextDescription adsDescription;
  final String applyLink;
  final String adsUrl;
  final DateTime postedDate;
  bool isFavourite;

  AdsModel({
    required this.metaData,
    required this.adsTitle,
    required this.adsDescription,
    required this.applyLink,
    required this.postedDate,
    required this.isFavourite,
    required this.adsUrl,
  });

  @override
  List<Object?> get props => [
        adsTitle,
        applyLink,
        adsDescription,
        postedDate,
      ];
}
