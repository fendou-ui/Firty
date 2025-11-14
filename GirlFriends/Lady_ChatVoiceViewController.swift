
import UIKit
import AVFoundation

class Lady_ChatVoiceViewController: UIViewController {

    @IBOutlet weak var lady_imageView: UIImageView!
    @IBOutlet weak var lady_nameLabel: UILabel!
    @IBOutlet weak var lady_time: UILabel!
    var dict = [String: String]()
    var ladies = [String]()
    private var lady_timer: Timer?
    var lady_text: String = ""
    private var lady_task: LadyTask?
    private var lady_totalSeconds: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        lady_nameLabel.text = dict["lady_name"]
        lady_imageView.image = UIImage(named: dict["lady_image"]!)
        lady_imageView.layer.cornerRadius = 105
        lady_imageView.layer.masksToBounds = true
        
        Voice_Speak.shared.voice_endSpeak(false)
        self.lady_task = LadyTask(isDetectionEnabled: true)
        
        self.lady_task?.decibelScaleHandler = { [weak self] scale in
            guard let self = self else { return }
            print("speak……\(scale)")

        }

        self.lady_task?.resultHandler = { [weak self] text in
            guard let self = self else { return }
            if text.count == 0 {
                self.lady_endSpeakError()
            }else {
                self.lady_socketChat(speak_text: text)
                self.lady_voiceGuoduload()
                print(text)
            }
        }
        
        lady_voiceRecord()
        lady_beginTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lady_headerAnimation()
    }

    private func lady_headerAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.lady_imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.lady_imageView.alpha = 0.92
        }
    }

    @IBAction func lady_end(_ sender: Any) {
        lady_pause()
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        Voice_Speak.shared.voice_endSpeak(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func lady_callIncomingFeedback() {
    
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lightGenerator = UIImpactFeedbackGenerator(style: .light)
            lightGenerator.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            mediumGenerator.impactOccurred()
        }
    }
    
    func lady_beginTimer() {
        lady_timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.lady_totalSeconds += 1
            self.lady_time.text = self.formatTime(self.lady_totalSeconds)
        }
        RunLoop.current.add(lady_timer!, forMode: .common)
    }
    
    func lady_pause() {
        lady_timer?.invalidate()
        lady_timer = nil
    }
    
    func currentTimeString() -> String {
        return formatTime(lady_totalSeconds)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    func lady_endSpeakError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            UIView.animate(withDuration: 0.58, animations: { [weak self] in
                guard let self = self else { return }

                self.lady_nameLabel.text = ""
            })
        }
            
        self.lady_task?.lady_closeRecording()
        Voice_Speak.shared.voice_endSpeak(false)
    }
    
    private func lady_voiceRecord() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.31) {[weak self] in
            guard let self = self else { return }
            self.lady_task?.lady_beginRecording()
            UIView.animate(withDuration: 0.58, animations: {[weak self] in
                guard let self = self else { return }
                self.lady_nameLabel.text = "Please speak"
            })
        }
    }
    
    func lady_voiceGuoduload() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            UIView.animate(withDuration: 0.58, animations: { [weak self] in
                guard let self = self else { return }
                self.lady_nameLabel.text = "Thinking"
                
            })
        }
    }
    
    func lady_answeMyQuestion() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            UIView.animate(withDuration: 0.57, animations: { [weak self] in
                guard let self = self else { return }
                self.lady_nameLabel.text = "Answering"
            })
        }
    }
    
    func lady_socketChat(speak_text: String) {

        let timeStr = String(Int(Date().timeIntervalSince1970 * 1000))
        lady_openBotChatMessages(lady_id: timeStr, message: speak_text)
        Lady_Mobile.lady.lady_Event = { [weak self] status in
            switch status {
            case .lady_Connected:
                break
            case .lady_Received(let msg):
                print("Message: \(msg)")
                if msg.elementsEqual("DONE") {
                    
                    Lady_Mobile.lady.lady_endSocket()
                    Voice_Speak.shared.lady_voiceTextStr(text: self?.lady_text) { AudioPlayStatus in
                        DispatchQueue.main.async { [self] in
                            switch AudioPlayStatus {
                            case .playing:
                                self?.lady_answeMyQuestion()
                                case .stopped:
                                self?.lady_voiceRecord()
                            }
                        }
                    }
                    return
                }
                self?.lady_text = self!.lady_text + msg
            case .lady_Failure(let err):
                print("Error: \(err)")
            case .lady_Disconnected:
                print("Disconnected")
            }
        }
        
        if let url = URL(string: "wss://longaougydijamntvuybiu.tcqyhxy.top/websocket/\(timeStr)") {
            Lady_Mobile.lady.lady_sendChatText(to: url)
        }
    }
}

