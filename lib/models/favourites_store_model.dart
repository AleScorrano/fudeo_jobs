import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavouriteStoreModel {
  final String id;
  final String dataBaseId;
  late String adsType;

  FavouriteStoreModel({
    required this.id,
    required this.dataBaseId,
  }) {
    adsType =
        dataBaseId.replaceAll("-", "") == dotenv.env['JOB_POSITIONS_DATABASE']
            ? "job_position"
            : dataBaseId.replaceAll("-", "") ==
                    dotenv.env['FREELANCE_POSITIONS_DATABASE']
                ? 'freelance'
                : "";
  }

  factory FavouriteStoreModel.fromJson(Map<String, dynamic> json) =>
      FavouriteStoreModel(
        id: json['id'] as String,
        dataBaseId: json['dataBaseId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'dataBaseId': dataBaseId,
      };
}
