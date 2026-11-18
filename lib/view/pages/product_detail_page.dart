import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/cart_controller.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';

class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();
  final ProductService _service = ProductService();
  final RxInt _qty = 1.obs;

  void _addToCart(Product product) {
    final jumlah = _qty.value;
    cartController.addToCart(authController.username, product, jumlah);
    Get.back();
    Get.snackbar(
      '',
      '$jumlah item masuk keranjang!',
      titleText: const SizedBox.shrink(),
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = Get.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Detail Produk'),
      ),
      body: FutureBuilder<Product>(
        future: _service.fetchProductDetail(selected.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat detail produk'));
          }
          final product = snapshot.data!;
          return _buildBody(context, product);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Product product) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) => progress ==
                              null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Rating: ${product.rating} (${product.ratingCount} review)'),
                ],
              ),
              Text('Kategori: ${product.category}'),
              const SizedBox(height: 10),
              Text(product.description, textAlign: TextAlign.justify),
              const Divider(height: 32),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.teal,
                      onPressed: _qty.value > 1 ? () => _qty.value-- : null,
                    ),
                    Text('${_qty.value}', style: const TextStyle(fontSize: 20)),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      color: Colors.teal,
                      onPressed:
                          _qty.value < product.stock ? () => _qty.value++ : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Tambah ke Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: product.stock < 1 ? null : () => _addToCart(product),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
