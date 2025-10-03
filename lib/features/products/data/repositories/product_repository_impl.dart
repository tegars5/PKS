import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/repositories/product_repository.dart';
import '../../../../models/product_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class ProductRepositoryImpl implements ProductRepository {
  final supabase.SupabaseClient _supabaseClient;

  ProductRepositoryImpl(this._supabaseClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      print('=== GET PRODUCTS DEBUG START ===');
      
      final response = await _supabaseClient
          .from('products')
          .select('*, profiles!products_supplier_id_fkey(full_name)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('Products response: $response');
      
      List<ProductModel> products = [];
      for (var item in response) {
        products.add(ProductModel.fromJson(item));
      }
      
      print('Products parsed successfully: ${products.length} items');
      print('=== GET PRODUCTS DEBUG END ===');
      return products;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getProducts: ${e.message}');
      print('=== GET PRODUCTS DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getProducts: $e');
      print('=== GET PRODUCTS DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      print('=== GET PRODUCT BY ID DEBUG START ===');
      print('Getting product with ID: $productId');
      
      final response = await _supabaseClient
          .from('products')
          .select('*, profiles!products_supplier_id_fkey(full_name)')
          .eq('id', productId)
          .single();

      print('Product response: $response');
      
      final product = ProductModel.fromJson(response);
      print('Product parsed successfully: ${product.name}');
      print('=== GET PRODUCT BY ID DEBUG END ===');
      return product;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getProductById: ${e.message}');
      print('=== GET PRODUCT BY ID DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getProductById: $e');
      print('=== GET PRODUCT BY ID DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsBySupplier(String supplierId) async {
    try {
      print('=== GET PRODUCTS BY SUPPLIER DEBUG START ===');
      print('Getting products for supplier: $supplierId');
      
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('supplier_id', supplierId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('Products by supplier response: $response');
      
      List<ProductModel> products = [];
      for (var item in response) {
        products.add(ProductModel.fromJson(item));
      }
      
      print('Products by supplier parsed successfully: ${products.length} items');
      print('=== GET PRODUCTS BY SUPPLIER DEBUG END ===');
      return products;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getProductsBySupplier: ${e.message}');
      print('=== GET PRODUCTS BY SUPPLIER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getProductsBySupplier: $e');
      print('=== GET PRODUCTS BY SUPPLIER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      print('=== CREATE PRODUCT DEBUG START ===');
      print('Creating product: ${product.name}');
      
      final response = await _supabaseClient
          .from('products')
          .insert(product.toJson())
          .select()
          .single();

      print('Create product response: $response');
      
      final newProduct = ProductModel.fromJson(response);
      print('Product created successfully: ${newProduct.id}');
      print('=== CREATE PRODUCT DEBUG END ===');
      return newProduct;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in createProduct: ${e.message}');
      print('=== CREATE PRODUCT DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in createProduct: $e');
      print('=== CREATE PRODUCT DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      print('=== UPDATE PRODUCT DEBUG START ===');
      print('Updating product: ${product.id}');
      
      final response = await _supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('id', product.id)
          .select()
          .single();

      print('Update product response: $response');
      
      final updatedProduct = ProductModel.fromJson(response);
      print('Product updated successfully: ${updatedProduct.name}');
      print('=== UPDATE PRODUCT DEBUG END ===');
      return updatedProduct;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in updateProduct: ${e.message}');
      print('=== UPDATE PRODUCT DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in updateProduct: $e');
      print('=== UPDATE PRODUCT DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      print('=== DELETE PRODUCT DEBUG START ===');
      print('Deleting product: $productId');
      
      await _supabaseClient
          .from('products')
          .update({'is_active': false})
          .eq('id', productId);
      
      print('Product deleted successfully');
      print('=== DELETE PRODUCT DEBUG END ===');
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in deleteProduct: ${e.message}');
      print('=== DELETE PRODUCT DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in deleteProduct: $e');
      print('=== DELETE PRODUCT DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}