part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProducts extends ProductEvent {}

class GetProductById extends ProductEvent {
  final String productId;

  const GetProductById(this.productId);

  @override
  List<Object> get props => [productId];
}

class GetProductsBySupplier extends ProductEvent {
  final String supplierId;

  const GetProductsBySupplier(this.supplierId);

  @override
  List<Object> get props => [supplierId];
}

class CreateProduct extends ProductEvent {
  final ProductModel product;

  const CreateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final ProductModel product;

  const UpdateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}