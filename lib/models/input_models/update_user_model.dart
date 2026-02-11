class UpdateUserModel {
  String name;
  String email;
  String country;
  String state;
  String city;
  String neighborhood;
  String street;
  String number;

  UpdateUserModel({
    required this.name,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.number,
  });
  
  Map<String, String> toJson() {
    return {
      "name": name,
      "email": email,
      "country": country,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "street": street,
      "number": number,
    };
  }
} 
