import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }

    var isSome: Bool {
        isNil == false
    }

    func doIfSome(_ body: (Wrapped) -> Void) {
        switch self {
        case let .some(value):
            body(value)
        default:
            break
        }
    }
}
