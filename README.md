# Paramedix

Healthcare App

## Description

This is a frontend project of PARAMEDIX.

**Technology:** Flutter

## Prerequisites

To run this project you need to have

- Android Studio or Visual Studio Code
  - **Android Studio:** Android SDK Platform 33 & Android SDK Build-Tools 30.0.3
  - **Visual Studio Code:** Install Dart & Flutter extensions
- Install Flutter: <https://docs.flutter.dev/get-started/install>

## Getting Started

To install this project on your local machine, follow these steps:

1. Clone this repository to your desired location

   ```bash
   git clone git@github.com:A2A-Digital/medicApp.git
   cd medicApp
   git checkout main
   ```

2. Adding a package dependency to the app

   ```bash
   flutter pub get
   ```

## Run locally

### Frontend

Add your own baseUrl in the api_endpoints.dart file:

```bash
static const String baseUrl = "http://[IPv4 Address]:8000/api";
```

### Backend

Run the server to start backend project:

```bash
python manage.py runserver 0.0.0.0:8000
```

## Build

Create a new Gradle build:

```bash
gradle init
```
