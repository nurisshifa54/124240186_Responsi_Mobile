import 'dart:convert';
import '../model/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = "https://fakestoreapi.com/products";

  // Daftar semua produk
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat produk');
    }
    final List<dynamic> result = jsonDecode(response.body);
    return result.map((product) => Product.fromJson(product)).toList();
  }

  // Detail produk berdasarkan id
  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail produk');
    }
    return Product.fromJson(jsonDecode(response.body));
  }
}
