class SearchResult {
  String artist;
  String title;
  int? id;
  String? songUrl;
  String? artistUrl;
  int? rank;
  String? checksum;

  static List<SearchResult> samples = [
    SearchResult(
        "Genesis", "Supper's Ready", 3046, "fb6986fc60a04cbc7af17210809caa1d"),
    SearchResult("Genesis", "The Musical Box", 20515,
        "a18035de69f903f7d73d2782e3aee942"),
    SearchResult("Queen", "Modern Times Rock 'n' Roll", 13727,
        "9aed8a871590b3da98419243b2c07812"),
    SearchResult("Trans-Siberian Orchestra", "The Music Box", 79974,
        "bff5062ab21bfe837d6ca06c62b99013"),
    SearchResult("Jay-Z", "Threat", 27848, "8f0065a48a12c71c930320c31085bd7a"),
    SearchResult(
        "Genesis", "Supper's Ready", 3046, "fb6986fc60a04cbc7af17210809caa1d"),
    SearchResult("Genesis", "The Musical Box", 20515,
        "a18035de69f903f7d73d2782e3aee942"),
    SearchResult("Queen", "Modern Times Rock 'n' Roll", 13727,
        "9aed8a871590b3da98419243b2c07812"),
    SearchResult("Trans-Siberian Orchestra", "The Music Box", 79974,
        "bff5062ab21bfe837d6ca06c62b99013"),
    SearchResult("Jay-Z", "Threat", 27848, "8f0065a48a12c71c930320c31085bd7a"),
  ];

  SearchResult(this.artist, this.title, this.id, this.checksum);
}
