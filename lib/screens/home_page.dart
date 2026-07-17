import 'package:flutter/material.dart';
import 'package:study_box/models/product.dart';
import 'package:study_box/screens/product_detail_screen.dart';
import 'package:study_box/services/api_service.dart';
import 'package:study_box/services/local_storage_services.dart';
import 'package:study_box/components/product_card.dart';
import 'package:study_box/screens/cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  final ApiService _apiService = ApiService();

  String _name = '';
  String _searchQuery = '';

  List<Product> _products = [];
  final List<Product> _cartItems = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadName();
    _loadProducts();
  }

  Future<void> _loadName() async {
    final String? data = await _localStorageService.getData();

    if (!mounted) return;

    setState(() {
      _name = data ?? '';
    });
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> products = await _apiService.fetchProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _addToCart(Product product) {
    final bool alreadyInCart = _cartItems.any((item) => item.id == product.id);

    if (alreadyInCart) {
      return;
    }

    setState(() {
      _cartItems.add(product);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == product.id);
    });
  }

  List<Product> _getFilteredProducts() {
    final String query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _products;
    }

    return _products.where((product) {
      return product.name.toLowerCase().contains(query);
    }).toList();
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
          'TechCatalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cartItems: _cartItems,
                    onRemove: _removeFromCart,
                    onAddToCart: _addToCart,
                  ),
                ),
              );
              if (!mounted) return;
              setState(() {});
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name.isEmpty ? 'Hoş geldin!' : 'Hoş geldin, $_name!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Teknoloji ürünlerini keşfet.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 12),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ürün ara...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://wantapi.com/assets/banner.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Ürünler',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              Expanded(child: _buildProductArea()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductArea() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF7089E2)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Ürünler yüklenemedi.\n$_errorMessage',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final List<Product> filteredProducts = _getFilteredProducts();

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'Aramanızla eşleşen ürün bulunamadı.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      itemCount: filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final Product product = filteredProducts[index];

        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: product,
                  onAddToCart: () {
                    _addToCart(product);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
