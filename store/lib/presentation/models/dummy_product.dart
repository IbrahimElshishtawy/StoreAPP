class DummyProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final bool hasVr;
  final String? dealTag;

  const DummyProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.hasVr = false,
    this.dealTag,
  });
}

final List<DummyProduct> dummyProducts = [
  DummyProduct(
    id: '1',
    name: 'Minimalist Ceramic Vase',
    description: 'A beautiful white ceramic vase for premium boutique styling.',
    price: 49.99,
    originalPrice: 65.00,
    imageUrl: 'https://images.unsplash.com/photo-1581783342308-f792db84ee4a?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    dealTag: 'Best Value',
  ),
  DummyProduct(
    id: '2',
    name: 'Clinic Pure Air Purifier',
    description: 'High-end air purifier with sleek aesthetics.',
    price: 299.99,
    imageUrl: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&q=80&w=600',
    hasVr: false,
  ),
  DummyProduct(
    id: '3',
    name: 'Ergonomic Desk Chair',
    description: 'Premium ergonomic chair designed for extreme comfort.',
    price: 199.99,
    originalPrice: 250.00,
    imageUrl: 'https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
    dealTag: 'Price Drop',
  ),
  DummyProduct(
    id: '4',
    name: 'Smart Ambient Lamp',
    description: 'Adjustable light settings for a calming atmosphere.',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
  ),
  DummyProduct(
    id: '5',
    name: 'Aesthetic Table Clock',
    description: 'Minimalist clock that fits any boutique space.',
    price: 35.00,
    originalPrice: 50.00,
    imageUrl: 'https://images.unsplash.com/photo-1584286595398-a59f21d313f5?auto=format&fit=crop&q=80&w=600',
    hasVr: false,
    dealTag: 'Limited',
  ),
  DummyProduct(
    id: '6',
    name: 'Boutique Organizer Set',
    description: 'Organize your space with this premium multi-piece set.',
    price: 120.00,
    imageUrl: 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?auto=format&fit=crop&q=80&w=600',
    hasVr: true,
  ),
];
