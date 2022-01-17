import Foundation

protocol Disk {
    func isDirectory(at path: String) -> Bool
    func createDirectoryIfNeeded(at url: URL) throws
    func allURLs(inDirectory url: URL, recursive: Bool) throws -> [URL]
}

final class DefaultDisk: Disk {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func isDirectory(at path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        let resourceValues = try? url.resourceValues(forKeys: [.isDirectoryKey])
        return resourceValues?.isDirectory ?? false
    }

    func createDirectoryIfNeeded(at url: URL) throws {
        var isDirectory: ObjCBool = true
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: [:])
        }
    }

    func allURLs(inDirectory url: URL, recursive: Bool) throws -> [URL] {
        var options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsHiddenFiles]
        if !recursive {
            options.insert(.skipsSubdirectoryDescendants)
        }

        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: options) else {
            return []
        }

        return enumerator
            .allObjects
            .compactMap { $0 as? URL }
            .sorted(by: { $0.path.localizedCaseInsensitiveCompare($1.path) == .orderedAscending })
    }
}
