# Proceedix demo app

## Build flavors

This app uses 3 build flavors

* DEV
* QA
* PROD

to run each of the flavors use the following command:

* `flutter run -t lib/main_dev.dart --flavor=dev`

* `flutter run -t lib/main_qa.dart --flavor=qa`

* `flutter run -t lib/main_prod.dart --flavor=prod`

## Android Studio Config

The easiest way to build in Android Studio is to setup run configurations for each flavor.

* dev
    * Dart entrypoint: <path to your project>/lib/main_dev.dart
    * flavor: dev

* qa
    * Dart entrypoint: <path to your project>/lib/main_qa.dart
    * flavor: qa

* prod
    * Dart entrypoint: <path to your project>/lib/main_prod.dart
    * flavor: prod

## Command to incrementally generate classes
Eg. When adding a view model with `@injectable`

`fvm flutter packages pub run build_runner watch --delete-conflicting-outputs`

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
