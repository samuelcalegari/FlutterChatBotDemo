class CustomException implements Exception {

  String _message = '';

  CustomException([String message = '']) {
    this._message = message;
  }

  @override
  String toString() {
    return _message;
  }
}