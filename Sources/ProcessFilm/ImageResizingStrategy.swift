import Foundation

// MARK: - ImageResizingStrategy

protocol ImageResizingStrategy {
    func resizeImage(at url: URL, size: ImageSize, to newURL: URL, using imageMagick: ImageMagick)
}

// MARK: - SquareImageResizingStrategy

final class SquareImageResizingStrategy: ImageResizingStrategy {
    func resizeImage(at url: URL, size: ImageSize, to newURL: URL, using imageMagick: ImageMagick) {
        imageMagick.resizeImage(at: url, squareSide: size.biggerSide, to: newURL)
    }
}

// MARK: - StoryImageResizingStrategy

final class StoryImageResizingStrategy: ImageResizingStrategy {
    private struct Constants {
        static let storySize = ImageSize(width: 1080, height: 1920)
        static let contentPercentage = 0.9
    }

    func resizeImage(at url: URL, size: ImageSize, to newURL: URL, using imageMagick: ImageMagick) {
        imageMagick.resizeImage(
            at: url,
            finalSize: Constants.storySize,
            contentPercentage: Constants.contentPercentage,
            to: newURL
        )
    }
}
