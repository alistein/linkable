class AddressResponse {
  final String town;
  final String postcode;
  final List<Thoroughfare> thoroughfares;

  AddressResponse({
    required this.town,
    required this.postcode,
    required this.thoroughfares,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      town: json["town"] ?? "",
      postcode: json["postcode"] ?? "",
      thoroughfares: (json["thoroughfares"] as List<dynamic>?)
              ?.map((e) => Thoroughfare.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Thoroughfare {
  final String thoroughfareName;
  final List<DeliveryPoint> deliveryPoints;

  Thoroughfare({
    required this.thoroughfareName,
    required this.deliveryPoints,
  });

  factory Thoroughfare.fromJson(Map<String, dynamic> json) {
    return Thoroughfare(
      thoroughfareName: json["thoroughfare_name"] ?? "",
      deliveryPoints: (json["delivery_points"] as List<dynamic>?)
              ?.map((e) => DeliveryPoint.fromJson(e))
              .toList() ??
          [],
    );
  }
}


class DeliveryPoint {
  final String organisationName;
  final String buildingNumber;
  final String buildingName;
  final String subBuildingName;
  final String udprn;

  DeliveryPoint({
    required this.organisationName,
    required this.buildingNumber,
    required this.buildingName,
    required this.subBuildingName,
    required this.udprn,
  });

  factory DeliveryPoint.fromJson(Map<String, dynamic> json) {
    return DeliveryPoint(
      organisationName: json["organisation_name"] ?? "",
      buildingNumber: json["building_number"] ?? "",
      buildingName: json["building_name"] ?? "",
      subBuildingName: json["sub_building_name"] ?? "",
      udprn: json["udprn"]?.toString() ?? "", // Ensure it's always a string
    );
  }
}
