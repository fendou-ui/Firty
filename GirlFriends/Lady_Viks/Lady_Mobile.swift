
import Foundation
import SocketRocket

enum Lady_SocketEvent {
    case lady_Received(String)
    case lady_Failure(Error)
    case lady_Connected
    case lady_Disconnected
}

class Lady_Mobile: NSObject {
    static let lady = Lady_Mobile()
    private var lady_socket: SRWebSocket?
    private var lady_urlString: URL?
    var lady_Event: ((Lady_SocketEvent) -> Void)?

    func lady_sendChatText(to url: URL) {
        self.lady_urlString = url
        lady_socket = SRWebSocket(url: url)
        lady_socket?.delegate = self
        lady_socket?.open()
    }

    func lady_endSocket() {
        lady_socket?.close()
    }
    
    private func reconnectIfNeeded() {
        guard let url = lady_urlString else { return }
        self.lady_sendChatText(to: url)
    }
    
}

extension Lady_Mobile: SRWebSocketDelegate {
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        lady_Event?(.lady_Connected)
    }
    
    func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any) {
        if let text = message as? String {
            lady_Event?(.lady_Received(text))
        }
    }

    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
        lady_Event?(.lady_Connected)
    }

    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        lady_Event?(.lady_Failure(error))
    }
}
