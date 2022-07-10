class AddressModel
{
  String? addressID;
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? latitude;
  double? longitude;

  AddressModel({
    this.addressID,
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.fullAddress,
    this.latitude,
    this.longitude,
  });

  AddressModel.fromMap(Map<String, dynamic> json)
  {
    addressID = json['addressID'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    fullAddress = json['fullAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['addressID'] = addressID;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['flatNumber'] = flatNumber;
    data['city'] = city;
    data['state'] = state;
    data['fullAddress'] = fullAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    return data;
  }
}