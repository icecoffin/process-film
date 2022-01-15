import Foundation

enum ImageProcessorError: Error, LocalizedError {
    case incorrectSize(path: String, expectedRatio: Double, actualRatio: Double)

    var errorDescription: String? {
        switch self {
        case .incorrectSize(let path, let expectedRatio, let actualRatio):
            return "Image \(path) is not correctly sized. Expected ratio: \(expectedRatio), actual ratio: \(actualRatio)"
        }
    }
}

protocol ImageProcessor {
    func processImage(at url: URL, outputDirectory: String) throws
}

final class DefaultImageProcessor: ImageProcessor {
    private struct Constants {
        static let expectedRatio = 1.5
        static let ratioTolerance = 0.01
    }

    private let disk: Disk
    private let imageMagick: ImageMagick

    init(disk: Disk = DefaultDisk(),
         imageMagick: ImageMagick = DefaultImageMagick()) {
        self.disk = disk
        self.imageMagick = imageMagick
    }

    private func isImageSizedCorrectly(imageSize: ImageSize) -> Bool {
        let ratio = imageSize.ratio
        return ratio > Constants.expectedRatio - Constants.ratioTolerance && ratio < Constants.expectedRatio + Constants.ratioTolerance
    }

    private func updatedImageURL(for url: URL, outputDirectory: String) throws -> URL {
        let lastPathComponent = url.lastPathComponent
        let updatedImagesDirectory = url
            .deletingLastPathComponent()
            .appendingPathComponent(outputDirectory)

        try disk.createDirectoryIfNeeded(at: updatedImagesDirectory)

        return updatedImagesDirectory.appendingPathComponent(lastPathComponent)
    }

    func processImage(at url: URL, outputDirectory: String) throws {
        let imageMagick = DefaultImageMagick()

        let imageSize: ImageSize
        do {
            imageSize = try imageMagick.imageSize(at: url)
        }
        catch {
            print("Skipping path \(url.path) as identify didn't return a proper size")
            print(error.localizedDescription)
            return
        }

        guard isImageSizedCorrectly(imageSize: imageSize) else {
            throw ImageProcessorError.incorrectSize(
                path: url.path,
                expectedRatio: Constants.expectedRatio,
                actualRatio: imageSize.ratio
            )
        }

        imageMagick.resizeImage(
            at: url,
            squareSide: imageSize.biggerSide,
            to: try updatedImageURL(for: url, outputDirectory: outputDirectory)
        )
    }
}
