import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var scheme

    @StateObject private var viewModel: NotesListViewModel
    @State private var showAddNote = false

    private let storage: NotesStorageProtocol
    private let weatherService: WeatherServiceProtocol

    init(
        storage: NotesStorageProtocol = NotesStorage(),
        weatherService: WeatherServiceProtocol = WeatherService(apiKey: Secrets.openWeatherAPIKey)
    ) {
        _viewModel = StateObject(wrappedValue: NotesListViewModel(storage: storage))
        self.storage = storage
        self.weatherService = weatherService
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    VStack {
                        ThemedCard {
                            VStack(spacing: 10) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary)
                                Text("No notes")
                                    .font(.headline)
                                Text("Tap + to add your first note.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                    }
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            NavigationLink {
                                NoteDetailView(note: note)
                            } label: {
                                NoteRowView(note: note)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("WeatherNotes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.notes.isEmpty { EditButton() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddNote = true } label: { Image(systemName: "plus") }
                }
            }
            .onAppear { viewModel.load() }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(viewModel: AddNoteViewModel(weatherService: weatherService, storage: storage))
                    .onDisappear { viewModel.load() }
            }
            .background(AppTheme.pageBackground(scheme))
        }
    }
}

private struct NoteRowView: View {
    let note: Note

    private static let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        ThemedCard {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.text)
                        .font(.headline)
                        .lineLimit(2)
                    Text(Self.df.string(from: note.createdAt))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 8) {
                    WeatherIconView(iconCode: note.weather.iconCode, size: 24)
                    Text("\(Int(note.weather.temperatureC.rounded()))°C")
                        .font(.headline)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

private struct NoteDetailView: View {
    @Environment(\.colorScheme) private var scheme
    let note: Note

    private static let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        List {
            Section("Note") { Text(note.text) }
            Section("Date") { Text(Self.df.string(from: note.createdAt)) }

            Section("Weather") {
                HStack(spacing: 12) {
                    WeatherIconView(iconCode: note.weather.iconCode, size: 44)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.weather.locationName)
                            .font(.headline)
                        Text(note.weather.description.capitalized)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(Int(note.weather.temperatureC.rounded()))°C")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Details")
        .scrollContentBackground(.hidden)
        .background(AppTheme.pageBackground(scheme))
    }
}


#if DEBUG
private final class NotesStorageInMemory: NotesStorageProtocol {
    private var notes: [Note]
    init(seed: [Note]) { self.notes = seed }
    func load() throws -> [Note] { notes }
    func save(_ notes: [Note]) throws { self.notes = notes }
    func append(_ note: Note) throws { notes.append(note) }
}

#Preview("ContentView") {
    let seed: [Note] = [
        Note(id: UUID(), text: "Morning run", createdAt: Date().addingTimeInterval(-3600),
             weather: WeatherSnapshot(temperatureC: 2.0, description: "clear sky", iconCode: "01d", locationName: "Kyiv")),
        Note(id: UUID(), text: "Commute", createdAt: Date().addingTimeInterval(-7200),
             weather: WeatherSnapshot(temperatureC: -1.0, description: "few clouds", iconCode: "02d", locationName: "Kyiv"))
    ]

    return ContentView(
        storage: NotesStorageInMemory(seed: seed),
        weatherService: WeatherService(apiKey: "preview")
    )
    .preferredColorScheme(.light)
}
#endif
