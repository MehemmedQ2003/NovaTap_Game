import '../models/word_model.dart';

class WordRepository {
  Future<List<WordModel>> getWords() async {
    return [
      WordModel(
        id: '1',
        word: "NAMAZ",
        hint: "Dinin direği",
        difficulty: Difficulty.easy,
      ),
      WordModel(
        id: '2',
        word: "ORUÇ",
        hint: "Ramazan ayı ibadeti",
        difficulty: Difficulty.easy,
      ),
      WordModel(
        id: '3',
        word: "MEKKE",
        hint: "Kabe'nin bulunduğu şehir",
        difficulty: Difficulty.easy,
      ),

      WordModel(
        id: '4',
        word: "TEYEMMÜM",
        hint: "Su yoksa toprakla abdest",
        difficulty: Difficulty.medium,
      ),
      WordModel(
        id: '5',
        word: "ZEKAT",
        hint: "Malın temizlenmesi için verilen miktar",
        difficulty: Difficulty.medium,
      ),
      WordModel(
        id: '6',
        word: "HİCRET",
        hint: "Mekke'den Medine'ye göç",
        difficulty: Difficulty.medium,
      ),

      WordModel(
        id: '7',
        word: "MUKABELE",
        hint: "Karşılıklı Kuran okuma",
        difficulty: Difficulty.hard,
      ),
      WordModel(
        id: '8',
        word: "TEVEKKÜL",
        hint: "Allah'a güvenip dayanma",
        difficulty: Difficulty.hard,
      ),
      WordModel(
        id: '9',
        word: "MÜTEVAZI",
        hint: "Alçak gönüllü olma durumu",
        difficulty: Difficulty.hard,
      ),
    ];
  }
}
