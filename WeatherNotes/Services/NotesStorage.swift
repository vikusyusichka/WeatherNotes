import Foundation

protocol NotesStorageProtocol {
    func load() throws -> [Note]
    func save(_ notes: [Note]) throws
    func append(_ note: Note) throws
}

final class NotesStorage: NotesStorageProtocol {
    private let defaults: UserDefaults
    private let key = "weather_notes"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() throws -> [Note] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return try JSONDecoder().decode([Note].self, from: data)
    }

    func save(_ notes: [Note]) throws {
        let data = try JSONEncoder().encode(notes)
        defaults.set(data, forKey: key)
    }

    func append(_ note: Note) throws {
        var current = try load()
        current.insert(note, at: 0)
        try save(current)
    }
}

