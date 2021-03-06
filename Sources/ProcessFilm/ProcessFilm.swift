import ArgumentParser
import Foundation

public struct ProcessFilm: ParsableCommand {
    @Argument(help: "Path to a file or a directory to convert.")
    var path: String

    @Option(help: "Output format. Possible options: \(OutputFormat.allOptions).")
    var format: OutputFormat = .square

    @Flag(name: .shortAndLong, help: "Search for images recursively.")
    var recursive = false

    @Argument(help: "Output directory.")
    var outputDirectory = "updated"

    public init() { }

    public func run() throws {
        let logic = ProcessFilmLogic(
            path: path,
            outputFormat: format,
            recursive: recursive,
            outputDirectory: outputDirectory
        )
        try logic.run()
    }
}

enum OutputFormat: String, ExpressibleByArgument, CaseIterable {
    case square
    case story

    static var allOptions: String {
        return Self.allCases.map { $0.rawValue }.joined(separator: ", ")
    }
}

struct ProcessFilmLogic {
    private let path: String
    private let recursive: Bool
    private var outputDirectory: String

    private let disk: Disk
    private let imageProcessor: ImageProcessor

    init(path: String,
         outputFormat: OutputFormat,
         recursive: Bool,
         outputDirectory: String,
         disk: Disk = DefaultDisk(),
         imageProcessorFactory: ImageProcessorFactory = DefaultImageProcessorFactory()) {
        self.path = path
        self.recursive = recursive
        self.outputDirectory = outputDirectory
        self.disk = disk
        self.imageProcessor = imageProcessorFactory.makeImageProcessor(for: outputFormat)
    }

    func run() throws {
        let url = URL(fileURLWithPath: path)
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        let isDirectory = resourceValues.isDirectory ?? false

        if isDirectory {
            try processDirectory(at: url)
        } else {
            print("Processing \(url.lastPathComponent)")
            try processFile(at: url)
        }
    }

    private func processDirectory(at url: URL) throws {
        let imageURLs = try disk
            .allURLs(inDirectory: url, recursive: recursive)
            .filter { $0.isImage }
        print("Found \(imageURLs.count) image(s)")

        for (index, imageURL) in imageURLs.enumerated() {
            let relativePath = imageURL.path.dropFirst(path.count + 1)
            print("[\(index + 1)/\(imageURLs.count)] Processing \(relativePath)")
            try processFile(at: imageURL)
        }

        print("Finished processing!")
    }

    private func processFile(at url: URL) throws {
        do {
            try imageProcessor.processImage(at: url, outputDirectory: outputDirectory)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
