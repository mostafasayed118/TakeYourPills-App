extension StringX on String {
  bool get isNullOrEmpty => this.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}'; 
  }
}
