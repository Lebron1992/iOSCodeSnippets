import AlamofireImage

extension UIImageView {
    func setImage(
        withURL urlStr: String,
        imageTransition: ImageTransition = .crossDissolve(0.25)
    ) {
        image = nil
        if let url = URL(string: urlStr) {
            af.setImage(withURL: url, imageTransition: imageTransition)
        }
    }

    func setImage(
        withURL url: URL,
        imageTransition: ImageTransition = .crossDissolve(0.25)
    ) {
        image = nil
        af.setImage(withURL: url, imageTransition: imageTransition)
    }
}

extension UIImageView {
    func sizeFitsContainer(_ container: UIView) -> CGSize {
        guard let image = image else { return .zero }
        let imageW = image.size.width
        let imageH = image.size.height
        let containerW = container.bounds.width
        let containerH = container.bounds.height
        let widthRatio = imageW / containerW
        let heightRatio = imageH / containerH

        let finalW: CGFloat
        let finalH: CGFloat
        if widthRatio > heightRatio {
            finalW = containerW
            finalH = finalW * (imageH / imageW)
        } else {
            finalH = containerH
            finalW = finalH * (imageW / imageH)
        }

        return .init(width: finalW, height: finalH)
    }
}
