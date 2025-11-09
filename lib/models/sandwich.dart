enum BreadType { white, wheat, wholemeal }

enum SandwichSize { footlong, sixInch }

class Sandwich {
  final String id;
  final String name;
  final String description;
  final bool available;
  final BreadType breadType;
  final SandwichSize size;
  final String image;

  Sandwich({
    required this.id,
    required this.name,
    required this.description,
    required this.available,
    required this.breadType,
    required this.size,
    required this.image,
  });

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    return Sandwich(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      available: json['available'] as bool? ?? true,
      breadType: BreadType.values.firstWhere(
        (e) => e.name == (json['breadType'] as String? ?? 'white'),
        orElse: () => BreadType.white,
      ),
      size: SandwichSize.values.firstWhere(
        (e) => e.name == (json['size'] as String? ?? 'footlong'),
        orElse: () => SandwichSize.footlong,
      ),
      image: json['image'] as String? ?? '',
    );
  }

  bool? get isFootlong => null;
}
