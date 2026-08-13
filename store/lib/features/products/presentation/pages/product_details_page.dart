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
    if (_reviewController.text.isEmpty) return;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.product.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '\$${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
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
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.view_in_ar),
                  label: const Text('View in AR'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            AddToCart(CartItem(product: widget.product, quantity: 1)),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ProductVideoPlayer(videoUrl: 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'),
            const SizedBox(height: 30),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildReviewForm(),
            const SizedBox(height: 20),
            _buildReviewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    return Column(
      children: [
        TextField(
          controller: _reviewController,
          decoration: const InputDecoration(
            hintText: 'Write a review...',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        Row(
          children: [
            const Text('Rating: '),
            DropdownButton<double>(
              value: _rating,
              items: [1.0, 2.0, 3.0, 4.0, 5.0]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                  .toList(),
              onChanged: (val) => setState(() => _rating = val!),
            ),
            const Spacer(),
            ElevatedButton(onPressed: _submitReview, child: const Text('Submit')),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsList() {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return const Text('No reviews yet.');
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.reviews.length,
            itemBuilder: (context, index) {
              final review = state.reviews[index];
              return ListTile(
                title: Text(review.userName),
                subtitle: Text(review.comment),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(review.rating.toString()),
                  ],
                ),
              );
            },
          );
        } else if (state is ReviewError) {
          return Text('Error: ${state.message}');
        }
        return const SizedBox();
      },
    );
  }
}
