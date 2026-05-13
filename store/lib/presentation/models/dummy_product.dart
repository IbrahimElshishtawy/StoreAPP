import 'package:store/features/products/domain/entities/product_entity.dart';

class DummyProduct extends ProductEntity {
  final bool hasVr;
  final String? dealTag;
  final double? originalPrice;

  DummyProduct({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.image,
    required super.category,
    this.hasVr = false,
    this.dealTag,
    this.originalPrice,
  });

  @override
  String get imageUrl => image;
}

final List<DummyProduct> dummyProducts = [
  DummyProduct(
    id: '1',
    title: 'Minimalist Ceramic Vase',
    description: 'A beautiful white ceramic vase for premium boutique styling.',
    price: 49.99,
    originalPrice: 65.00,
    image: 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    dealTag: 'Best Value',
    category: 'Home Decor',
  ),
  DummyProduct(
    id: '2',
    title: 'Clinic Pure Air Purifier',
    description: 'High-end air purifier with sleek aesthetics.',
    price: 299.99,
    image: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&q=80&w=600',
    hasVr: false,
    category: 'Electronics',
  ),
  DummyProduct(
    id: '3',
    title: 'Ergonomic Desk Chair',
    description: 'Premium ergonomic chair designed for extreme comfort.',
    price: 199.99,
    originalPrice: 250.00,
    image: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    dealTag: 'Price Drop',
    category: 'Furniture',
  ),
  DummyProduct(
    id: '4',
    title: 'Smart Ambient Lamp',
    description: 'Adjustable light settings for a calming atmosphere.',
    price: 89.99,
    image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    category: 'Lighting',
  ),
  DummyProduct(
    id: '5',
    title: 'Aesthetic Table Clock',
    description: 'Minimalist clock that fits any boutique space.',
    price: 35.00,
    originalPrice: 50.00,
    image: 'https://images.unsplash.com/photo-1584286595398-a59f21d313f5?auto=format&fit=crop&q=80&w=600',
    hasVr: false,
    dealTag: 'Limited',
    category: 'Home Decor',
  ),
  DummyProduct(
    id: '6',
    title: 'Boutique Organizer Set',
    description: 'Organize your space with this premium multi-piece set.',
    price: 120.00,
    image: 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    category: 'Home Decor',
  ),
];
