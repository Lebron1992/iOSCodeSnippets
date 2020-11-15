import UIKit
import PKHUD
import SwiftEntryKit

extension UIViewController {

    // MARK: - Type Name

    static var typeName: String {
        return String(describing: self)
    }

    // MARK: - Hide Keyboard

    func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewDidTapped)
        )
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    @objc func viewDidTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Dismiss View Controller

    func dismissViewWhenTappedAround(cancelTouches: Bool = false) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(closeButtonItemTapped)
        )
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    // MARK: - Navigation Bar

    enum UIBarButtonItemTag: Int {
        case backButtonItem = 100
        case closeButtonItem = 101
    }

    var backButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backButtonItemTapped)
        )
        item.tag = UIBarButtonItemTag.backButtonItem.rawValue
        return item
    }

    var whiteBackButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(named: "back-white")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backButtonItemTapped)
        )
        return item
    }

    @objc private func backButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }

    var closeButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(named: "close")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(closeButtonItemTapped)
        )
        item.tag = UIBarButtonItemTag.closeButtonItem.rawValue
        return item
    }

    @objc func closeButtonItemTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - HUD

    @objc func hideHUD() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }

    func showProgress(title: String?, subtitle: String? = nil) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: title, subtitle: subtitle))
        }
    }

    func showLoading() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }

    func showHUD(withText text: String) {
        DispatchQueue.main.async {
            HUD.show(.label(text))
        }
        perform(#selector(hideHUD), with: nil, afterDelay: 3)
    }

    // MARK: - Handle Error

    func handleError(_ error: Error?) {
        guard let error = error else {
            return
        }
        customPresent(
            UIAlertController.alert(
                title: "",
                message: error.localizedDescription,
                handler: nil
            ),
            animated: true
        )
    }

    // MARK: - Alert

    func alertUser(
        title: String = "",
        message: String = "",
        confirm: String = "Close",
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController.alert(
            title: title,
            message: message,
            confirm: confirm,
            handler: handler
        )
        customPresent(alert, animated: true)
    }
}

extension UIViewController {
    func customPresent(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            if let presented = self.presentedViewController {
                presented.customPresent(
                    viewControllerToPresent,
                    animated: flag,
                    completion: completion
                )
            } else {
                self.present(viewControllerToPresent, animated: flag, completion: completion)
            }
        }
    }
}

// MARK: - Image Picking

import MobileCoreServices

extension UIViewController {
    @objc func didPickEditedImage(_ image: UIImage) { }
    @objc func didPickOriginalImage(_ image: UIImage) { }
    @objc func didPickVideo(_ video: URL) { }
}

extension UIViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    private func presentImagePickerController(
        with sourceType: UIImagePickerController.SourceType,
        allowsEditing: Bool = false
    ) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true, completion: nil)
    }

    func openMediaOptions(withTitle title: String?, allowsEditing: Bool = false) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let optionMenu = UIAlertController(
                title: title,
                message: "",
                preferredStyle: .actionSheet
            )
            optionMenu.popoverPresentationController?.sourceView = view
            optionMenu.popoverPresentationController?.sourceRect = CGRect(
                x: view.bounds.midX,
                y: view.bounds.midY,
                width: 0,
                height: 0
            )
            optionMenu.popoverPresentationController?.permittedArrowDirections = []

            let libraryAction = UIAlertAction(
                title: "Choose from photo library",
                style: .default,
                handler: { (_) in
                    self.presentImagePickerController(with: .photoLibrary, allowsEditing: allowsEditing)
                }
            )
            let cameraAction = UIAlertAction(
                title: "Take a new photo",
                style: .default,
                handler: { (_) in
                    self.presentImagePickerController(with: .camera, allowsEditing: allowsEditing)
                }
            )
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.addAction(libraryAction)
            optionMenu.addAction(cameraAction)
            optionMenu.addAction(cancelAction)
            present(optionMenu, animated: true, completion: nil)
        } else {
            presentImagePickerController(with: .photoLibrary, allowsEditing: allowsEditing)
        }
    }

    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let type = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }

        if type == kUTTypeImage as String {

            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                didPickOriginalImage(originalImage)
            }
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                didPickEditedImage(editedImage)
            }

        } else if type == kUTTypeMovie as String ||
                    type == kUTTypeVideo as String,
                  let pickedVideoPath = info[UIImagePickerController.InfoKey.mediaURL] as? URL {

            didPickVideo(pickedVideoPath)
        }
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwiftEntryKit
extension UIViewController {
    func alertViewController(_ viewController: UIViewController, attributes: EKAttributes = .alert) {
        SwiftEntryKit.display(entry: viewController, using: attributes)
    }
}

extension EKColor {
    static let appBackground: EKColor = .init(
        light: .white,
        dark: .black
    )

    static let dimmedLightBackground: EKColor = .init(
        light: UIColor.black.withAlphaComponent(0.5),
        dark: UIColor.black.withAlphaComponent(0.5)
    )
}

extension EKAttributes {
    static var alert: EKAttributes {
        var attributes: EKAttributes
        attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = .warning
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .appBackground)
        attributes.screenBackground = .color(color: .dimmedLightBackground)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0,
                to: 1,
                duration: 0.5,
                spring: .init(damping: 0.7, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            scale: .init(from: 1, to: 0.01, duration: 0.25),
            fade: .init(from: 1, to: 0, duration: 0.26)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .offset(value: 30),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        return attributes
    }
}
