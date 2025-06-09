class PhoneModel {
  String prefix;
  String number;
  String combined;
  String country;

  PhoneModel(
      {required this.prefix, required this.number, required this.combined, required this.country});

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      prefix: json['prefix'],
      number: json['number'],
      combined: json['combined'],
      country: json['country']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'number': number,
      'combined': combined,
      'country': country
    };
  }
}
