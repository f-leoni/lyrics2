library; //lyrics_library;

class LyricException implements Exception {
  int code;
  String message;

  LyricException(this.code, this.message);
}
