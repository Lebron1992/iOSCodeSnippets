import Foundation

enum PubNubMessageChannel {
    case eventUpdate

    var channelName: String {
        switch self {
        case .eventUpdate:
            return "event_update"
        }
    }
}
