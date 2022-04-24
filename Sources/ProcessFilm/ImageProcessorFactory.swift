import Foundation

protocol ImageProcessorFactory {
    func makeImageProcessor(for outputFormat: OutputFormat) -> ImageProcessor
}

final class DefaultImageProcessorFactory: ImageProcessorFactory {
    private let disk: Disk
    private let imageMagick: ImageMagick

    init(disk: Disk = DefaultDisk(), imageMagick: ImageMagick = DefaultImageMagick()) {
        self.disk = disk
        self.imageMagick = imageMagick
    }

    func makeImageProcessor(for outputFormat: OutputFormat) -> ImageProcessor {
        let resizingStrategy: ImageResizingStrategy
        switch outputFormat {
        case .square:
            resizingStrategy = SquareImageResizingStrategy()
        case .story:
            resizingStrategy = StoryImageResizingStrategy()
        }

        return DefaultImageProcessor(
            resizingStrategy: resizingStrategy,
            disk: disk, imageMagick: imageMagick
        )
    }
}
