class FirebaseAccountHomeModel {
  String uid;
  String firstName;
  String lastName;
  String email;
  String image;
  AddressModel? addressModel;
  List<CreditCardsModel> creditCards;

  FirebaseAccountHomeModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    this.addressModel,
    required this.creditCards,
  });

  factory FirebaseAccountHomeModel.fromMap(Map<String, dynamic> json) {
    return FirebaseAccountHomeModel(
      uid: json['uid'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      image: json['image'] ?? '',
      addressModel: AddressModel.fromMap(json['address'] ?? {}),
      creditCards: (json['creditCards'] as List?)
              ?.map((i) => CreditCardsModel.fromMap(i))
              .toList() ??
          [],
    );
  }
  @override
  String toString() {
    return 'FirebaseAccountModel(uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, image: $image)';
  }
}

class AddressModel {
  String country;
  String street;
  String postalCode;
  String locality;

  AddressModel({
    required this.country,
    required this.street,
    required this.postalCode,
    required this.locality,
  });

  factory AddressModel.fromMap(Map<String, dynamic> json) {
    return AddressModel(
      country: json['country'] ?? "",
      street: json['street'] ?? "",
      postalCode: json['postalCode'] ?? "",
      locality: json['locality'] ?? "",
    );
  }
  @override
  String toString() {
    return "AddressModel: (Country: $country, street: $street, postalCode: $postalCode, locality: $locality )";
  }
}

class CreditCardsModel {
  String cvvCode;
  String cardHolderName;
  String cardNumber;
  String expiryDate;

  CreditCardsModel({
    required this.cvvCode,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
  });

  factory CreditCardsModel.fromMap(Map<String, dynamic> json) {
    return CreditCardsModel(
      cvvCode: json['cvv_code'] ?? "",
      cardHolderName: json['card_holder_name'] ?? "",
      cardNumber: json['card_number'] ?? "",
      expiryDate: json['expiry_date'] ?? "",
    );
  }
  @override
  String toString() {
    return "CreditCardsModel: (cvvCode: $cvvCode, cardHolderName: $cardHolderName, cardNumber: $cardNumber, expiryDate: $expiryDate )";
  }
}
