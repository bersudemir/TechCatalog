import 'package:flutter/material.dart';
import 'package:study_box/components/cart_item_card.dart';
import 'package:study_box/models/product.dart';
import 'package:study_box/screens/product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;
  final ValueChanged<Product> onRemove;
  final ValueChanged<Product> onAddToCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color primaryColor = Color(0xFF7089E2);

  void _removeProduct(Product product) {
    widget.onRemove(product);

    setState(() {});
  }

  void _showCheckoutMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ödeme işlemi simülasyon olarak gösterilmektedir.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.cartItems.isEmpty
          ? const _EmptyCart()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final Product product = widget.cartItems[index];

                return CartItemCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                          onAddToCart: () {
                            widget.onAddToCart(product);
                          },
                        ),
                      ),
                    );
                  },
                  onRemove: () {
                    _removeProduct(product);
                  },
                );
              },
            ),
      bottomNavigationBar: widget.cartItems.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sepetindeki ürünleri kontrol ederek ödeme adımına geçebilirsin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _showCheckoutMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Ödemeye Geç',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Sepetiniz boş',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Beğendiğiniz ürünleri sepete ekleyebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
