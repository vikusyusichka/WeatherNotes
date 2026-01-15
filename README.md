# WeatherNotes

WeatherNotes is a small SwiftUI iOS app where a user can create notes, and each note stores a snapshot of the **current weather** at the moment it was created (OpenWeather API).

This project was implemented as an iOS Developer test assignment.

---

## Features

- Create notes with text input
- Fetch **current weather** on save (Kyiv coordinates)
- Notes list shows:
  - note text
  - creation date/time
  - temperature and weather icon
- Note details show:
  - note text
  - date/time
  - temperature
  - weather description
  - weather icon
  - location name
- Local persistence using UserDefaults (Codable)
- Error handling (no internet, bad response, decoding issues)
- Dark Mode support

---

## Tech Stack

- Swift / SwiftUI
- MVVM
- Async/Await
- URLSession networking
- OpenWeather API
- UserDefaults persistence (Codable)

---

## Project Structure

- **Models**
  - `Note`
  - `WeatherSnapshot`
  - `OpenWeatherResponseDTO`
- **ViewModels**
  - `NotesListViewModel`
  - `AddNoteViewModel`
- **Views**
  - `ContentView` (notes list + details)
  - `AddNoteView`
- **Services**
  - `WeatherService`
  - `NetworkClient`
  - `WeatherError`
- **Storage**
  - `NotesStorage`

---

## Setup

### OpenWeather API Key

Create `Secrets.plist` in the app bundle and add:

- Key: `OPEN_WEATHER_API_KEY`
- Value: your OpenWeather API key

The app reads it via `Secrets.openWeatherAPIKey`.

---

## Notes about Implementation

- Weather is fetched using Kyiv coordinates (`lat: 50.4501`, `lon: 30.5234`).
- A note stores a `WeatherSnapshot` (temperature in °C, description, icon code, location name).
- Weather icons are mapped to SF Symbols via `WeatherIconManager`.

---

## Possible Improvements

- Use CoreLocation to fetch user coordinates instead of hardcoded Kyiv values
- Replace UserDefaults with CoreData for more advanced persistence
- Add unit tests for ViewModels and Services
- Add support for multi-day/hourly forecast (if required)
