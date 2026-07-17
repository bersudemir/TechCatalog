import 'package:flutter_test/flutter_test.dart';
import 'package:study_box/models/product.dart';

void main() {
  test('JSON verisi Product nesnesine doğru çevrilir', () {
    final Map<String, dynamic> json = {
      'id': 1,
      'name': 'Test Telefonu',
      'tagline': 'Güçlü ve hızlı',
      'description': 'Test ürünü açıklaması',
      'price': '29.999 TL',
      'currency': 'TRY',
      'image': 'https://example.com/telefon.png',
      'specs': {'ram': '8 GB', 'storage': '256 GB'},
    };

    final Product product = Product.fromJson(json);

    expect(product.id, 1);
    expect(product.name, 'Test Telefonu');
    expect(product.price, '29.999 TL');
    expect(product.specs['ram'], '8 GB');
    expect(product.specs['storage'], '256 GB');
  });
}
