extension StringExtension on String? {
  bool isNullOrEmpty() {
    if(this != null && this!.isNotEmpty){
      return false;
    }
    return true;
  }
}
