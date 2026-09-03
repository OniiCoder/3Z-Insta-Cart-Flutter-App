import 'package:equatable/equatable.dart';

class CustomerProfile extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String defaultAddress;
  final String defaultCity;
  final String defaultZipCode;

  const CustomerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.defaultAddress,
    required this.defaultCity,
    required this.defaultZipCode,
  });

  static const CustomerProfile demo = CustomerProfile(
    id: 1,
    name: 'Alice Johnson',
    email: 'alice@example.com',
    phone: '+1 (555) 234-5678',
    defaultAddress: '742 Evergreen Terrace, Apt 4B',
    defaultCity: 'Springfield',
    defaultZipCode: '97477',
  );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        defaultAddress,
        defaultCity,
        defaultZipCode,
      ];
}
