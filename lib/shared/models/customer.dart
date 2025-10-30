class Customer {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final CustomerType type;

  const Customer({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.type = CustomerType.regular,
  });
}

enum CustomerType {
  regular(0.0),
  loyal(5.0),
  wholesale(10.0);

  final double discountPercentage;
  const CustomerType(this.discountPercentage);
}
