class FirebaseExploreModel {
  final List<PhonesModel> phoneModel;
  final List<ShoesModel> shoesModel;
  final List<WatchesModel> watchesModel;
  final List<ReviewsModel> reviewsModel;
  FirebaseExploreModel({
    required this.phoneModel,
    required this.watchesModel,
    required this.shoesModel,
    required this.reviewsModel,
  });

  factory FirebaseExploreModel.fromJson(Map<String, dynamic> json) {
    return FirebaseExploreModel(
      phoneModel: (json['phones'] as List)
          .map((phone) => PhonesModel.fromJson(phone))
          .toList(),
      watchesModel: (json['watches'] as List)
          .map((watch) => WatchesModel.fromJson(watch))
          .toList(),
      shoesModel: (json['shoes'] as List)
          .map((shoe) => ShoesModel.fromJson(shoe))
          .toList(),
      reviewsModel: (json['reviews'] as List)
          .map((reviews) => ReviewsModel.fromMap(reviews))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FirebaseExploreModel(phoneModel: $phoneModel, shoesModel: $shoesModel, watchesModel: $watchesModel)';
  }
}

class ProductModel {
  final String name;
  final String description;
  final String image;
  final int price;
  final String releaseYear;
  final String brand;
  final int count;
  final int quantity;
  final String size;
  final List<String> color;
  final String type;

  ProductModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.price,
      required this.releaseYear,
      required this.brand,
      required this.color,
      required this.count,
      required this.size,
      required this.type,
      required this.quantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      size: json['size'] ?? "",
      releaseYear: json['release_year'] ?? "",
      brand: json['brand'] ?? '',
      count: json['count'] ?? 0,
      color: (json['color'] is String)
          ? [json['color']]
          : List<String>.from(json['color'] ?? []),
      quantity: json['quantity'] ?? 1,
      type: json['type'] ?? "",
    );
  }

  @override
  String toString() {
    return "$runtimeType(name: $name, description: $description, image: $image, price: $price, release_year: $releaseYear, brand: $brand, count: $count)";
  }
}

class PhonesModel extends ProductModel {
  final String operatingSystem;
  PhonesModel({
    required this.operatingSystem,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.releaseYear,
    required super.brand,
    required super.count,
    required super.quantity,
    required super.color,
    required super.size,
    required super.type,
  });

  factory PhonesModel.fromJson(Map<String, dynamic> json) {
    return PhonesModel(
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      releaseYear: json['release_year'] ?? "",
      brand: json['brand'] ?? '',
      count: json['count'] ?? 0,
      quantity: json['quantity'] ?? 1,
      color: (json['color'] is String)
          ? [json['color']]
          : List<String>.from(json['color'] ?? []),
      size: json['size'] ?? "",
      type: json['type'] ?? "",
      operatingSystem: json['operatingSystem'] ?? "",
    );
  }
}

class ShoesModel extends ProductModel {
  final int heelHeight;
  ShoesModel({
    required this.heelHeight,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.releaseYear,
    required super.brand,
    required super.color,
    required super.size,
    required super.count,
    required super.quantity,
    required super.type,
  });

  factory ShoesModel.fromJson(Map<String, dynamic> json) {
    return ShoesModel(
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      releaseYear: json['release_year'] ?? "",
      size: json['size'] ?? "",
      color: (json['color'] is String)
          ? [json['color']]
          : List<String>.from(json['color'] ?? []),
      brand: json['brand'] ?? '',
      count: json['count'] ?? 0,
      quantity: json['quantity'] ?? 1,
      type: json['type'] ?? "",
      heelHeight: json['heelHeight'] ?? 0,
    );
  }

  @override
  String toString() {
    return "${super.toString()},";
  }
}

class WatchesModel extends ProductModel {
  final String movementType;
  WatchesModel({
    required this.movementType,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.releaseYear,
    required super.brand,
    required super.color,
    required super.count,
    required super.quantity,
    required super.size,
    required super.type,
  });

  factory WatchesModel.fromJson(Map<String, dynamic> json) {
    return WatchesModel(
      name: json['name'] ?? "",
      size: json['size'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      releaseYear: json['release_year'] ?? "",
      color: (json['color'] is String)
          ? [json['color']]
          : List<String>.from(json['color'] ?? []),
      brand: json['brand'] ?? '',
      count: json['count'] ?? 0,
      quantity: json['quantity'] ?? 1,
      type: json['type'] ?? "",
      movementType: json['movementType'] ?? "",
    );
  }

  @override
  String toString() {
    return "${super.toString()} + ";
  }
}

class ReviewsModel {
  final String userName;
  final String userReview;
  final double userRating;
  final String timestamp;
  final String date;
  final String userImage;

  ReviewsModel(
      {required this.userName,
      required this.userReview,
      required this.userRating,
      required this.timestamp,
      required this.date,
      required this.userImage});

  factory ReviewsModel.fromMap(Map<String, dynamic> json) {
    return ReviewsModel(
      userName: json['user_name'] ?? '',
      userReview: json['user_review'] ?? "",
      userRating: (json['user_rating'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] ?? '',
      date: json['date'] ?? '',
      userImage: json["user_image"] ?? "",
    );
  }
}
