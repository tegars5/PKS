import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../models/product_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ProductInitial()) {
    on<GetProducts>(_onGetProducts);
    on<GetProductById>(_onGetProductById);
    on<GetProductsBySupplier>(_onGetProductsBySupplier);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onGetProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductsLoaded(products));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetProductById(
    GetProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _productRepository.getProductById(event.productId);
      emit(ProductLoaded(product));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetProductsBySupplier(
    GetProductsBySupplier event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProductsBySupplier(event.supplierId);
      emit(ProductsLoaded(products));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _productRepository.createProduct(event.product);
      emit(const ProductOperationSuccess('Product created successfully'));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _productRepository.updateProduct(event.product);
      emit(const ProductOperationSuccess('Product updated successfully'));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(event.productId);
      emit(const ProductOperationSuccess('Product deleted successfully'));
    } on AppException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('An unexpected error occurred: $e'));
    }
  }
}