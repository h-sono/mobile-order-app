class MenuItem {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String category;
  final String? imageUrl;
  final bool isAvailable;
  final String currency;
  
  // Localization metadata
  final String localeResolved;
  final bool localeFallback;
  


  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isAvailable,
    this.currency = 'JPY',
    this.localeResolved = 'ja',
    this.localeFallback = false,
  });

  // Get localized name - API provides localized data directly
  String getLocalizedName(String languageCode) {
    return name;
  }

  // Get localized description - API provides localized data directly
  String? getLocalizedDescription(String languageCode) {
    return description;
  }

  // Get localized category - API provides localized data directly
  String getLocalizedCategory(String languageCode) {
    return category;
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: double.parse(json['price'].toString()),
      category: json['category'] as String? ?? 'Other',
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'JPY',
      localeResolved: json['locale_resolved'] as String? ?? 'ja',
      localeFallback: json['locale_fallback'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'currency': currency,
      'locale_resolved': localeResolved,
      'locale_fallback': localeFallback,
    };
  }
}