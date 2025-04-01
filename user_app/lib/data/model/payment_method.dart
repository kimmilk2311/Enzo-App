import '../../resource/asset/app_images.dart';

class PaymentMethodType {
  static const String momo = 'MOMO';
  static const String bankTransfer = 'BANK_TRANSFER';
  static const String cod = 'COD';

  static const List<String> all = [momo, bankTransfer, cod];
}

class PaymentMethod {
  final String key;
  final String label;
  final String icon;

  PaymentMethod({
    required this.key,
    required this.label,
    required this.icon,
  });
}
final paymentMethods = [
  PaymentMethod(
    key: PaymentMethodType.momo,
    label: "Ví Momo",
    icon: AppImages.imgMomo,
  ),
  PaymentMethod(
    key: PaymentMethodType.bankTransfer,
    label: "Chuyển khoản",
    icon: AppImages.imgBank,
  ),
  PaymentMethod(
    key: PaymentMethodType.cod,
    label: "COD",
    icon: AppImages.imgCOD,
  ),
];