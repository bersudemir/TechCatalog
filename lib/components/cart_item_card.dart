import 'package:flutter/material.dart';
import 'package:study_box/models/product.dart';

class CartItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const CartItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'product_${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFF6F7FB),
                  padding: const EdgeInsets.all(6),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7089E2),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Sepetten kaldır',
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
