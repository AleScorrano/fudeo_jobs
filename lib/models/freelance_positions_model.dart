import 'package:annunci_lavoro_flutter/models/ads_description.dart';
import 'package:annunci_lavoro_flutter/models/ads_model.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class FreeLancePosition extends AdsModel {
  final RichTextDescription jobRequest;
  final RichTextDescription budget;
  final NDA nda;
  final RichTextDescription workTiming;
  final RichTextDescription paymentTimes;
  final Relationship realtionship;

  FreeLancePosition({
    required super.metaData,
    required super.adsTitle,
    required super.applyLink,
    required super.postedDate,
    required super.adsUrl,
    required super.isFavourite,
    required super.adsDescription,
    required this.jobRequest,
    required this.budget,
    required this.nda,
    required this.workTiming,
    required this.paymentTimes,
    required this.realtionship,
  });
  @override
  List<Object?> get props => [
        ...super.props,
        jobRequest,
        budget,
        nda,
        workTiming,
        paymentTimes,
        realtionship,
      ];

  String mapRelationshipString() {
    if (realtionship == Relationship.onlyCommissioner) {
      return 'Solo con chi commissiona il lavoro';
    } else {
      return 'Con altri professionisti';
    }
  }

  static NDA mapNdaEnum(String nda) {
    if (nda == 'Si') {
      return NDA.yes;
    } else {
      return NDA.no;
    }
  }

  static Relationship mapRelationshipEnum(String relationship) {
    if (relationship == 'Solo con chi commissiona il lavoro') {
      return Relationship.onlyCommissioner;
    } else {
      return Relationship.otherProfessionals;
    }
  }

  Color getRelationshipColor(Relationship relationship, bool mode) {
    if (relationship == Relationship.onlyCommissioner) {
      return mode ? Colors.red.shade700 : Colors.red.shade100;
    } else {
      return mode ? Colors.blue.shade700 : Colors.blue.shade100;
    }
  }
}

enum NDA {
  yes,
  no,
}

enum Relationship {
  onlyCommissioner,
  otherProfessionals,
}
