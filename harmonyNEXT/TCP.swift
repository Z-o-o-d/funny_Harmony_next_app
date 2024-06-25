import UIKit
import Network

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var toggleServerButton: UIButton!

    private var server: TCPServer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 初始化服务器
        server = TCPServer()

        // 更新界面显示
        updateUIForServerState(.stopped)
    }

    @IBAction func toggleServer(_ sender: UIButton) {
        if server?.isRunning ?? false {
            // 停止服务器
            server?.stop()
            updateUIForServerState(.stopped)
        } else {
            // 启动服务器
            server?.start()
            updateUIForServerState(.running)
        }
    }

    private func updateUIForServerState(_ state: ServerState) {
        switch state {
        case .running:
            statusLabel.text = "Server Running"
            toggleServerButton.setTitle("Stop Server", for: .normal)
        case .stopped:
            statusLabel.text = "Server Stopped"
            toggleServerButton.setTitle("Start Server", for: .normal)
        }
    }

    private func appendToLog(_ message: String) {
        DispatchQueue.main.async {
            self.logTextView.text += "\(message)\n"
            let bottom = NSMakeRange(self.logTextView.text.count - 1, 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }
}

// MARK: - TCPServer Definition

enum ServerState {
    case running
    case stopped
}

class TCPServer {

    private var listener: NWListener?
    private var connections: [NWConnection] = []

    init() {
        do {
            listener = try NWListener(using: .tcp, on: NWEndpoint.Port(integerLiteral: 12345))
        } catch {
            print("Failed to create listener:", error)
            return
        }

        listener?.newConnectionHandler = { [weak self] newConnection in
            self?.handleNewConnection(newConnection)
        }
    }

    func start() {
        listener?.start(queue: .global())
        print("Server started on port 12345")
    }

    func stop() {
        listener?.cancel()
        connections.forEach { $0.cancel() }
        connections.removeAll()
        print("Server stopped")
    }

    private func handleNewConnection(_ connection: NWConnection) {
        print("New connection received")
        connections.append(connection)

        connection.start(queue: .global())

        connection.receiveMessage { [weak self] data, context, isComplete, error in
            if let data = data, !data.isEmpty {
                if let message = String(data: data, encoding: .utf8) {
                    print("Received message:", message)
                    self?.appendToLog("Received: \(message)")
                } else {
                    print("Received data is not a valid UTF-8 string")
                    self?.appendToLog("Received data is not valid UTF-8")
                }
            }
            if let error = error {
                print("Error in receiving message:", error)
                self?.appendToLog("Error: \(error.localizedDescription)")
            }
        }
    }

    private func appendToLog(_ message: String) {
        DispatchQueue.main.async {
            // You can handle logging here, e.g., append to a log file or update UI
        }
    }

    var isRunning: Bool {
        return listener?.state == .ready
    }
}
