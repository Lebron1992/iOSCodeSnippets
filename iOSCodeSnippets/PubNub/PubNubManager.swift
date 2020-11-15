import Foundation
import PubNub

final class PubNubManager {
    typealias MessageHandler = (_ message: PubNubMessage) -> Void

    static let shared = PubNubManager()

    private let pubnub: PubNub = {
        // TODO: update isStaging and subscribeKey
        let isStaging = true
        let subscribeKey = isStaging ? "" : ""
        let pubnubConfig = PubNubConfiguration(
            publishKey: nil,
            subscribeKey: subscribeKey
        )
        return PubNub(configuration: pubnubConfig)
    }()
    private let pubnubListener = SubscriptionListener(queue: .main)
    private let permanentPubNubChannels = [PubNubMessageChannel.eventUpdate.channelName]
    private var messageHandlers: [NSObject: MessageHandler] = [:]

    private var sessionEndedObserver: Any?
    private var sessionStartedObserver: Any?

    // MARK: - Initializers

    init() {}

    func initialize() {
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]

        pubnub.subscribe(to: permanentPubNubChannels)
        subscribeToUserRelatedChannel()

        pubnubListener.didReceiveSubscription = { [weak self] event in
            switch event {
            case let .messageReceived(message):
                self?.handlePubNubMessage(message)
            case let .subscribeError(error):
                print("Subscription Error \(error.underlying?.localizedDescription ?? "")")
            default:
                break
            }
        }
        pubnub.add(pubnubListener)

        sessionStartedObserver = NotificationCenter.default
            .addObserver(forName: .sessionStarted, object: nil, queue: nil) { [weak self] _ in
                self?.userSessionStarted()
        }
        sessionEndedObserver = NotificationCenter.default
            .addObserver(forName: .sessionEnded, object: nil, queue: nil) { [weak self] _ in
                self?.userSessionEnded()
        }
    }

    deinit {
        sessionStartedObserver.doIfSome(NotificationCenter.default.removeObserver(_:))
        sessionEndedObserver.doIfSome(NotificationCenter.default.removeObserver(_:))
    }
}

// MARK: - Private

extension PubNubManager {
    func addSubscriber(_ subscriber: NSObject, using block: @escaping MessageHandler) {
        messageHandlers[subscriber] = block
    }

    func removeSubscriber(_ subscriber: NSObject) {
        messageHandlers.removeValue(forKey: subscriber)
    }

    private func handlePubNubMessage(_ message: PubNubMessage) {
        print(
            """
            Message received:
            User '\(message.publisher ?? "Unknown")' sent
            '\(message.payload.jsonStringify ?? "")' message
            on '\(message.channel)'
            """
        )
        messageHandlers.forEach { _, handler in
            handler(message)
        }
    }

    private func userSessionStarted() {
        subscribeToUserRelatedChannel()
    }

    private func userSessionEnded() {
        unsubscribeFromUserRelatedChannel()
    }
    
    private func unsubscribeFromUserRelatedChannel() {
        // TODO: unsubscribe from user-related channels
        pubnub.unsubscribe(from: [])
    }
    
    private func subscribeToUserRelatedChannel() {
        // TODO: subscribe to user-related channels
        pubnub.subscribe(to: [])
    }
}
