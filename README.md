# ParAi

## Mimari Vizyon
ParAi, MVVM (Model-View-ViewModel) mimarisiyle, modüler ve sürdürülebilir bir iOS uygulaması olarak tasarlanmıştır. Temiz kod, test edilebilirlik ve kolay bakım önceliklidir. Paket bağımlılıkları: Charts, RevenueCat, GoogleSignIn, GoogleGenerativeAI.

## Klasör Yapısı
```
ParAi/
├─ App
├─ Models
├─ Views
├─ ViewModels
├─ Services
├─ Resources
│   ├─ Assets.xcassets
│   └─ Colors.xcassets
├─ Extensions
└─ SupportingFiles
```

## Kurulum Adımları
1. Xcode ile projeyi açın.
2. Gerekli Swift paketlerini ekleyin:
   - Charts: https://github.com/danielgindi/Charts.git
   - RevenueCat: https://github.com/RevenueCat/purchases-ios.git
   - GoogleSignIn: https://github.com/google/GoogleSignIn-iOS.git
   - GoogleGenerativeAI: https://github.com/google/generative-ai-swift.git
3. Terminalden bağımlılıkları çözün:
   ```sh
   xcodebuild -resolvePackageDependencies
   ```
4. (Opsiyonel) Fastlane ile otomasyon için:
   ```sh
   bundle install
   fastlane init
   ```
5. SwiftLint ile kod kalitesini kontrol edin:
   ```sh
   brew install swiftlint
   swiftlint
   ```

## Komut Satırı Adımları
- Derleme:
  ```sh
  xcodebuild -scheme ParAi -sdk iphonesimulator
  ```
- Test:
  ```sh
  xcodebuild test -scheme ParAi -sdk iphonesimulator
  ```

## Başarı Ölçütü
- ✅ Derleme hatasız gerçekleşir
- ✅ README'de tüm adımlar listelenir 