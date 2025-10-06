import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  String selectedCategory = 'Semua';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    // Mock data - replace with actual API call
    products = [
      Product(
        id: '1',
        name: 'Cangkang Sawit Grade A',
        description: 'Cangkang sawit berkualitas tinggi untuk biomassa',
        price: 150000,
        imageUrl: 'assets/images/cangkang1.jpg',
        category: 'Biomassa',
        rating: 4.5,
        stock: 100,
        sellerId: 'seller1',
        sellerName: 'CV. Sawit Jaya',
      ),
      // Add more mock products...
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produk'), backgroundColor: Colors.green),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => filterProducts(value),
            ),
          ),
          // Category Filter
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['Semua', 'Biomassa', 'Pupuk', 'Pakan Ternak']
                  .map(
                    (category) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: products[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void filterProducts(String query) {
    // Implement search logic
  }
}
