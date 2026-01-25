import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// DİKKAT: 'flutter_application_1' yerine pubspec.yaml dosyasındaki
// 'name:' kısmında yazan proje adını yazmalısın.
// Eğer proje adın farklıysa aşağıdaki satırı ona göre düzelt.
import 'package:flutter_application_1/main.dart'; 

void main() {
  testWidgets('Oyun giriş ekranı yükleniyor ve Başla butonu görünüyor', (WidgetTester tester) async {
    // 1. Uygulamayı sanal ortamda başlat (KelimeOyunuApp bizim ana sınıfımız)
    await tester.pumpWidget(const KelimeOyunuApp());

    // 2. Animasyonların ve çizimlerin tamamlanmasını bekle
    await tester.pumpAndSettle();

    // 3. Ekranda 'KELİME USTASI' yazısının olduğunu doğrula
    expect(find.text('KELİME USTASI'), findsOneWidget);

    // 4. 'OYUNA BAŞLA' butonunun olduğunu doğrula
    expect(find.text('OYUNA BAŞLA'), findsOneWidget);

    // 5. Butona tıkla
    await tester.tap(find.text('OYUNA BAŞLA'));
    
    // 6. Sayfa geçişini bekle
    await tester.pumpAndSettle();

    // 7. Oyun ekranının açıldığını doğrula (Appbar başlığı veya ipucu)
    expect(find.text('Kelimeyi Bul'), findsOneWidget);
  });
}