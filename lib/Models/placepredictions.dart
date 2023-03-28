// ignore_for_file: non_constant_identifier_names

class PlacePredictions
{
  String secondary_text = '';
  String main_text = '';
  String place_id = '';

  PlacePredictions({required this.secondary_text, required this.main_text, required this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json)
  {
    secondary_text = json['structured_formatting']['secondary_text'] ?? '';
    main_text = json['structured_formatting']['main_text'] ?? '';
    place_id = json['place_id'] ?? '';
  }
}