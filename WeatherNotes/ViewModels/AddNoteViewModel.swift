import Foundation
import Combine

@MainActor
final class AddNoteViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?
    @Published var weatherPreview: WeatherSnapshot?

    private let weatherService: WeatherServiceProtocol
    private let storage: NotesStorageProtocol

    private let kyivLat = 50.4501
    private let kyivLon = 30.5234

    init(weatherService: WeatherServiceProtocol, storage: NotesStorageProtocol) {
        self.weatherService = weatherService
        self.storage = storage
    }

    func saveNote() async -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Note text cannot be empty."
            return false
        }

        isSaving = true
        errorMessage = nil

        do {
            let snapshot = try await weatherService.fetchCurrentWeather(lat: kyivLat, lon: kyivLon)
            weatherPreview = snapshot

            let note = Note(
                id: UUID(),
                text: trimmed,
                createdAt: Date(),
                weather: snapshot
            )

            try storage.append(note)

            text = ""
            isSaving = false
            return true
        } catch let err as WeatherError {
            errorMessage = err.localizedDescription
            isSaving = false
            return false
        } catch {
            errorMessage = error.localizedDescription
            isSaving = false
            return false
        }
    }
}
