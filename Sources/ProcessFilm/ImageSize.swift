import Foundation

struct ImageSize {
    let width: Double
    let height: Double

    var ratio: Double {
        return max(width, height) / min(width, height)
    }

    var biggerSide: Double {
        return max(width, height)
    }
}
