import 'package:testing_api/models/order_model.dart';

class PaginatedOrder {
  final String? nextUrlPage;
  final List<OrderModel> orders;
  const PaginatedOrder({
    required this.nextUrlPage,
    required this.orders,
  });
}
