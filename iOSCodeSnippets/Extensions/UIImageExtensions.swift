import UIKit

extension UIImage {

    /// Crop image
    /// - Parameters:
    ///   - rect: A rectangle specifying the portion of the image to keep, based on the UIImageView's coodinate
    ///   - imageViewWidth: UIImageView's with
    ///   - imageViewHeight: UIImageView's height
    /// - Returns: cropped image
    func crop(
        toRect rect: CGRect,
        imageViewWidth: CGFloat,
        imageViewHeight: CGFloat
    ) -> UIImage {
        guard let cgimage = cgImage else { return self }

        let contextImage = UIImage(cgImage: cgimage)
        let contextSize = contextImage.size

        let xRatio = rect.origin.x / imageViewWidth
        let yRatio = rect.origin.y / imageViewHeight
        let widthRatio = rect.width / imageViewWidth
        let heightRatio = rect.height / imageViewHeight

        let finalRect = CGRect(
            x: contextSize.width * xRatio,
            y: contextSize.height * yRatio,
            width: contextSize.width * widthRatio,
            height: contextSize.height * heightRatio
        )

        guard let newCgImage = contextImage.cgImage,
              let croppedCgImage = newCgImage.cropping(to: finalRect) else {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }

        let cropped = UIImage(cgImage: croppedCgImage, scale: scale, orientation: imageOrientation)
        cropped.draw(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))

        let resized = UIGraphicsGetImageFromCurrentImageContext()
        return resized ?? self
    }
}

// MARK: - Rotate
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .size

        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }

        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)

        // Rotate around middle
        context.rotate(by: CGFloat(radians))

        // Draw the image at its center
        draw(in: .init(
            x: -size.width/2,
            y: -size.height/2,
            width: size.width,
            height: size.height
        ))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}
