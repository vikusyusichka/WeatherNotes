import Foundation
import Combine

@MainActor
final class NotesListViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var errorMessage: String?

    private let storage: NotesStorageProtocol

    init(storage: NotesStorageProtocol) {
        self.storage = storage
    }

    func load() {
        do {
            notes = try storage.load()
            errorMessage = nil
        } catch {
            notes = []
            errorMessage = error.localizedDescription
        }
    }

    func delete(at offsets: IndexSet) {
        do {
            let idsToDelete = offsets.compactMap { index in
                notes.indices.contains(index) ? notes[index].id : nil
            }

            let updated = notes.enumerated().filter { !idsToDelete.contains($0.element.id) }.map(\.element)

            try storage.save(updated)
            notes = updated
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
