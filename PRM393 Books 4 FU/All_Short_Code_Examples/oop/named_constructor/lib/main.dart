class ProcessingResult {
  late bool _error;
  late String _errorMessage;
  ProcessingResult.success() {
    _error = false;
    _errorMessage = '';
  }
  ProcessingResult.failure(this._errorMessage) {
    //shortcut
    this._error = true;
  }
  String toString() {
    return 'Error: ' + _error.toString() + ' Message: ' + _errorMessage;
  }
}

void main() {
  print(ProcessingResult.success().toString());
  print(ProcessingResult.failure('it broke').toString());
}
