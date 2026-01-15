import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @StateObject private var viewModel: AddNoteViewModel

    init(viewModel: AddNoteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Note") {
                    TextField("For example: morning run", text: $viewModel.text, axis: .vertical)
                        .lineLimit(3...8)
                }

                if let preview = viewModel.weatherPreview {
                    Section("Weather") {
                        HStack(spacing: 12) {
                            WeatherIconView(iconCode: preview.iconCode, size: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(Int(preview.temperatureC.rounded()))°C • \(preview.description.capitalized)")
                                Text(preview.locationName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(viewModel.isSaving)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            let ok = await viewModel.saveNote()
                            if ok { dismiss() }
                        }
                    } label: {
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(viewModel.isSaving || viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.pageBackground(scheme))
        }
    }
}

#if DEBUG
private final class WeatherServiceMock: WeatherServiceProtocol {
    let result: Result<WeatherSnapshot, Error>

    init(result: Result<WeatherSnapshot, Error>) {
        self.result = result
    }

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot {
        switch result {
        case .success(let snap): return snap
        case .failure(let err): throw err
        }
    }
}

private final class NotesStorageInMemory: NotesStorageProtocol {
    private var notes: [Note] = []

    func load() throws -> [Note] { notes }
    func save(_ notes: [Note]) throws { self.notes = notes }
    func append(_ note: Note) throws { notes.append(note) }
}

#Preview("AddNoteView Light") {
    let vm = AddNoteViewModel(
        weatherService: WeatherServiceMock(
            result: .success(
                WeatherSnapshot(
                    temperatureC: 3.0,
                    description: "clear sky",
                    iconCode: "01d",
                    locationName: "Kyiv"
                )
            )
        ),
        storage: NotesStorageInMemory()
    )

    vm.text = "Test note"
    vm.weatherPreview = WeatherSnapshot(
        temperatureC: 3.0,
        description: "clear sky",
        iconCode: "01d",
        locationName: "Kyiv"
    )

    return AddNoteView(viewModel: vm)
        .preferredColorScheme(.light)
}
#endif
