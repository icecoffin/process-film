import Foundation
import UniformTypeIdentifiers

extension URL {
    private var typeIdentifier: String? {
        return try? resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
    }

    var isImage: Bool {
        guard let typeIdentifier = typeIdentifier else { return false }

        let type = UTType(typeIdentifier)
        return type?.conforms(to: .image) ?? false
    }
}
