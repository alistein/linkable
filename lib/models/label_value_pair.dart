class LabelValuePair<T> {
  final String label;
  final T value;

  LabelValuePair({required this.label, required this.value});

  factory LabelValuePair.fromJson(Map<String, dynamic> json) =>
      LabelValuePair(label: json['label'], value: json['value']);
}