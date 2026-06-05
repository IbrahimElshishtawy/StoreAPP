import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:store/features/reviews/presentation/bloc/review_event.dart';
import 'package:store/features/reviews/presentation/bloc/review_state.dart';
import 'package:store/features/reviews/domain/entities/review.dart';
import 'package:store/presentation/widgets/product_video_player.dart';
import 'package:store/presentation/pages/product_virtual_view.dart';
import 'package:store/presentation/models/dummy_product.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5.0;

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(GetProductReviewsRequested(widget.product.id));
  }

  void _submitReview() {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review'), backgroundColor: Colors.orange),
      );
      return;
    }

    final review = Review(
      id: '',
      productId: widget.product.id,
      userName: 'Current User', // Should get from AuthBloc
      comment: _reviewController.text,
      rating: _rating,
      date: DateTime.now(),
    );

    context.read<ReviewBloc>().add(AddReviewRequested(review));
    _reviewController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title, style: const TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${widget.product.id}',
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    widget.product.image,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.category.toUpperCase(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${widget.product.rating} (${widget.product.ratingCount} reviews)',
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductVirtualView(
                            product: DummyProduct(
                              id: widget.product.id,
                              title: widget.product.title,
                              description: widget.product.description,
                              price: widget.product.price,
                              image: widget.product.image,
                              category: widget.product.category,
                              arModelUrl: 'assets/models/product.glb',
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text('View in AR'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            AddToCart(CartItem(product: widget.product, quantity: 1)),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Added to cart'), backgroundColor: Colors.teal),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Product Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: const ProductVideoPlayer(videoUrl: 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReviewForm(),
            const SizedBox(height: 24),
            _buildReviewsList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Write a Review', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about the product...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Rating: '),
              const SizedBox(width: 8),
              DropdownButton<double>(
                value: _rating,
                underline: const SizedBox(),
                items: [1.0, 2.0, 3.0, 4.0, 5.0]
                    .map((e) => DropdownMenuItem(value: e, child: Row(
                      children: [
                        Text(e.toString()),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    )))
                    .toList(),
                onChanged: (val) => setState(() => _rating = val!),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Post Review'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const LoadingIndicator(message: 'Loading reviews...');
        } else if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No reviews yet. Be the first to review!', style: TextStyle(color: Colors.grey)),
            ));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.reviews.length,
            separatorBuilder: (context, index) => const Divider(height: 32),
            itemBuilder: (context, index) {
              final review = state.reviews[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.teal[100],
                        child: Text(review.userName[0], style: const TextStyle(color: Colors.teal, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        children: List.generate(5, (i) => Icon(
                          Icons.star,
                          color: i < review.rating ? Colors.amber : Colors.grey[300],
                          size: 14,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(review.comment, style: TextStyle(color: Colors.grey[700])),
                ],
              );
            },
          );
        } else if (state is ReviewError) {
          return ErrorState(
            message: state.message,
            onRetry: () => context.read<ReviewBloc>().add(GetProductReviewsRequested(widget.product.id)),
          );
        }
        return const SizedBox();
      },
    );
  }
}
