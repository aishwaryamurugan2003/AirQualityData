# Air Quality Monitoring App

A simple Flutter app that displays real-time air quality data (PM2.5, PM10, CO, and NO2) for select Indian cities using the OpenAQ API.

## Features

- Fetches latest air quality data for:
  - Chennai
  - Delhi
  - Mumbai
  - Kolkata
- Displays PM2.5, PM10, CO, and NO2 concentrations.
- City-wise sensor locations (like Alandur Bus Depot, Technological University, etc.).
- Stylish and colorful card UI with city-specific data.
- Auto-updates data when the app initializes.

## Dependencies

- [`dio`](https://pub.dev/packages/dio): For API requests.
- [`flutter/material.dart`](https://api.flutter.dev/flutter/material/material-library.html): Core Flutter UI framework.

## Project Structure


## How It Works

1. The app initializes an `AirQualityController` which:
   - Sets up Dio for network calls.
   - Calls the OpenAQ `/locations/{id}/latest` endpoint for each city.
   - Maps sensor IDs to parameters using `/sensors/{id}`.
   - Updates UI with data using `ChangeNotifier`.

2. The UI (`HomePage`) listens to the controller using `AnimatedBuilder` and builds custom cards for each city.

3. Each card displays:
   - City name and location.
   - PM2.5, PM10, CO, NO2 values.
   - Last updated status.

## Sample API Flow

- `GET /v3/locations/{locationId}/latest`: Gets the latest air quality readings for a city.
- `GET /v3/sensors/{sensorId}`: Maps sensor to a parameter like PM2.5.

## API Key

You must have an OpenAQ API Key.

Replace this value in `airquality_controller.dart`:

```dart
final String apiKey = 'YOUR_API_KEY_HERE';
git clone https://github.com/yourusername/air_quality_app.git
cd air_quality_app
flutter pub get
flutter run
```
## License
This project is licensed under the MIT License.
