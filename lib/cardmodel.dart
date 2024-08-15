class CardModel {
  final int id;
  final String value;
  bool isFlipped;

  CardModel({required this.id, required this.value, this.isFlipped = false});
}