import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class RichTextDescription extends Equatable {
  final List<dynamic> data;
  late String descriptionText;
  late List<Map<String, dynamic>> descriptionAnnotations;

  RichTextDescription({required this.data}) {
    descriptionText = getDescriptionText(data);
    descriptionAnnotations = getAnnotations(data);
  }

  getDescriptionText(List<dynamic> data) {
    String description = '';
    data.map((item) => description += item['text']['content']).toString();
    return description;
  }

  List<Map<String, dynamic>> getAnnotations(List<dynamic> data) {
    List<Map<String, dynamic>> annotations = [];
    data.forEach((item) {
      annotations.add(
        {'text': item['text']['content'], 'annotations': item['annotations']},
      );
    });
    return annotations;
  }

  @override
  List<Object?> get props => [
        data,
        descriptionText,
        descriptionAnnotations,
      ];
}
