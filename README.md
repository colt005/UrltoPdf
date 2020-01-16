# URL2PDF

## About The Project

A Flutter app that converts the entered URL into Pdf. You can Email the created file to the entered Email address or download the PDF file directly into your phone.

### Built With
* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)

## Getting Started

### Prerequisites
* Flutter SDK
* Android SDK
* Android Studio/VS Code
* Git

### Installation
1. Get a free API Key at [https://html2pdf.app/](https://html2pdf.app/)
2. Clone the repo
```sh
git clone https://github.com/colt005/UrltoPdf.git
```
3. Make a new file apikey.dart in the lib folder
4. Enter your API in `apikey.dart`
```
final apikey = "YOUR-API-KEY";
```
5. Run the app on connected device
```
flutter run
```

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Acknowledgements
### Dart Packages used
* [http](https://pub.dev/packages/http)
* [dio](https://pub.dev/packages/dio)
* [fluttertoast](https://pub.dev/packages/fluttertoast)
* [flutter_android_downloader](https://pub.dev/packages/flutter_android_downloader)
* [downloads_path_provider](https://pub.dev/packages/downloads_path_provider)
* [permission_handler](https://pub.dev/packages/permission_handler)


This project uses the [HTMLTOPDF API](https://html2pdf.app/) to convert URLs to PDFs.






