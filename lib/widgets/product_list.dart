import 'package:flutter/material.dart';
import "package:lacelab/widgets/product_card.dart";
import "package:lacelab/global_variables.dart";
import "package:lacelab/pages/product_details_page.dart";

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'All',
    "Nike",
    "Adidas",
    "Rick Owens",
    "New Balance",
  ];

  late String selectedFilter;
  late TextEditingController searchController;
  List<dynamic> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    searchController = TextEditingController();
    filteredProducts = products;
    searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredProducts =
          products.where((product) {
            final title = (product['title'] as String).toLowerCase();
            final company = (product['company'] as String);

            final matchesSearch = title.contains(query);
            final matchesCompany =
                selectedFilter == 'All' || company == selectedFilter;

            return matchesSearch && matchesCompany;
          }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Shoes\nCollection",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    focusedBorder: border,
                    enabledBorder: border,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                      _filterProducts(); // Filter when chip is tapped
                    },
                    child: Chip(
                      label: Text(
                        filter,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      labelStyle: const TextStyle(fontSize: 16),
                      backgroundColor:
                          selectedFilter == filter
                              ? Theme.of(context).colorScheme.primary
                              : const Color.fromRGBO(245, 247, 249, 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      elevation: 2,
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsPage(product: product);
                        },
                      ),
                    );
                  },
                  child: ProductCard(
                    title: product['title'] as String,
                    price: product['price'] as double,
                    image: product['imageUrl'] as String,
                    backgroundColor:
                        index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
