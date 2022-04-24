import Foundation

struct ImageMagickError: Error, LocalizedError {
    let message: String

    var errorDescription: String? {
        return message
    }
}

protocol ImageMagick {
    func imageSize(at url: URL) throws -> ImageSize
    func resizeImage(at url: URL, squareSide: Double, to newURL: URL)
    func resizeImage(at url: URL, finalSize: ImageSize, contentPercentage: Double, to newURL: URL)
}

final class DefaultImageMagick: ImageMagick {
    private let shell: Shell

    init(shell: Shell = DefaultShell()) {
        self.shell = shell
    }

    func imageSize(at url: URL) throws -> ImageSize {
        let output = shell.run("identify -format \"%w %h\" \"\(url.path)\"")
        let size = output.split(separator: " ")

        guard size.count == 2,
              let width = Double(size[0]),
              let height = Double(size[1]) else {
                  throw ImageMagickError(message: "Unexpected output: \(output)")
              }

        return ImageSize(width: width, height: height)
    }

    func resizeImage(at url: URL, squareSide: Double, to newURL: URL) {
        let newSize = "\(squareSide)x\(squareSide)"
        _ = shell.run("convert \"\(url.path)\" -resize \(newSize) -background white -colorspace srgb -gravity center -extent \(newSize) \"\(newURL.path)\"")
    }

    func resizeImage(at url: URL, finalSize: ImageSize, contentPercentage: Double, to newURL: URL) {
        let newSize = "\(finalSize.width)x\(finalSize.height)"
        let contentSize = "\(round(finalSize.width * contentPercentage))x\(round(finalSize.height * contentPercentage))"
        _ = shell.run("convert \"\(url.path)\" -resize \(contentSize) -background white -colorspace srgb -gravity center -extent \(newSize) \"\(newURL.path)\"")
    }
}
