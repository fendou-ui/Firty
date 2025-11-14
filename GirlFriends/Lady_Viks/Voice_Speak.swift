
import Foundation
import AdSupport
import Speech
import AVFoundation
import Accelerate
import UIKit

enum AudioPlayStatus {
    case playing
    case stopped
}

class Voice_Speak: NSObject, AVSpeechSynthesizerDelegate {
    private var lady_speechSynthesizer = AVSpeechSynthesizer()
    typealias CompletionHandler = (AudioPlayStatus) -> Void
    var completionHandler: CompletionHandler?
    static let shared: Voice_Speak = {
        let voice = Voice_Speak()
        voice.lady_speechSynthesizer.delegate = voice
        return voice
    }()
    
    func voice_endSpeak(_ isBlock: Bool = true) {
        if isBlock { self.completionHandler?(.stopped) }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        voice_endSpeak()
    }
    
    func lady_voiceTextStr(text: String?, completionHandler: CompletionHandler?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self]  in
            self.completionHandler = completionHandler
            
            let avSpeech = AVSpeechUtterance(string: text!)
            if let femaleVoice = AVSpeechSynthesisVoice(language: "en-US") {
                avSpeech.voice = femaleVoice
            }
            avSpeech.rate = 0.44
            avSpeech.pitchMultiplier = 1.28
            avSpeech.volume = 0.81
            self.completionHandler?(.playing)
            lady_speechSynthesizer.speak(avSpeech)
        }
    }
}

class LadyTask: NSObject {
    
    private let lady_speech = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))!
    private var lady_Request: SFSpeechAudioBufferRecognitionRequest?
    private var lady_task: SFSpeechRecognitionTask?
    private let lady_audio = AVAudioEngine()
    private var lady_status: Bool = false
    private var lady_enabled: Bool
    var lady_timer: DispatchSourceTimer?
    private let lady_hold: TimeInterval = 3.0
    private let lady_feed = UIImpactFeedbackGenerator(style: .light)

    var resultHandler: ((String) -> Void)?
    var decibelScaleHandler: ((Float) -> Void)?

    init(isDetectionEnabled: Bool = false) {
        self.lady_enabled = isDetectionEnabled
        self.lady_feed.prepare()
    }

    
    private func lady_endTimer() {

        lady_timer?.cancel()
        lady_timer = nil
    }

    func lady_closeRecording() {
        
        lady_status = true
        stopRecording()
    }

    
    func lady_beginRecording() {
        
        lady_feed.impactOccurred()
        lady_audio.stop()
        lady_audio.reset()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            
            guard let self = self else { return }
            
            if let recognitionTask = self.lady_task {
                recognitionTask.cancel()
                self.lady_task = nil
            }

            self.lady_status = false
            
            let statues = AVAudioSession.sharedInstance()
            try! statues.setCategory(.record, mode: .measurement, options: .duckOthers)
            try! statues.setActive(true, options: .notifyOthersOnDeactivation)

            self.lady_Request = SFSpeechAudioBufferRecognitionRequest()

            let restore = self.lady_audio.inputNode

            guard let recognitionRequest = self.lady_Request else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }

            recognitionRequest.shouldReportPartialResults = true
            
            self.lady_task = self.lady_speech.recognitionTask(with: recognitionRequest) { result, error in
                var button = false
                
                if let result = result {
                    
                    if self.lady_enabled {
                        self.lady_endTimer()
                        self.lady_openTimer()
                    }
                    print("——————说话中: \(result.bestTranscription.formattedString)")
                    button = result.isFinal
                }

                if error != nil || button {
                    self.lady_audio.stop()
                    restore.removeTap(onBus: 0)

                    self.lady_Request = nil
                    self.lady_task = nil

                    if let result = result {
                        if self.lady_status == false {
                            self.resultHandler?(result.bestTranscription.formattedString)
                        }
                    }
                }
            }

            let chat = restore.outputFormat(forBus: 0)
            restore.installTap(onBus: 0, bufferSize: 1024, format: chat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.lady_Request?.append(buffer)
                
                
                guard let channelData = buffer.floatChannelData else { return }
                
                
                let recordingv = vDSP_Length(buffer.frameLength)
                var userdata: Float = 0
                vDSP_rmsqv(channelData[0], 1, &userdata, recordingv)
                
                
                let query = 20 * log10(userdata)
                
                
                DispatchQueue.main.async {
                    
                    let picker = 1.0 + CGFloat((query + 50) / 50.0)
                    let date = max(1.0, min(picker, 1.5))
                    
                    if date > 1.0 {
                        self.decibelScaleHandler?(Float(date))
                    }
                }
            }
            
            self.lady_audio.prepare()
            try! self.lady_audio.start()
        }
        
    }

    func stopRecording() {
        
        lady_feed.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let weakSelf = self else { return }

            weakSelf.lady_endTimer()
            weakSelf.lady_audio.stop()
            weakSelf.lady_Request?.endAudio()
            let statues = AVAudioSession.sharedInstance()
            try! statues.setCategory(.playback, mode: .default)
            try! statues.setActive(true, options: .notifyOthersOnDeactivation)
        }
        
    }

    private func lady_openTimer() {

        if lady_timer == nil {
            lady_timer?.cancel()
            lady_timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            lady_timer?.schedule(deadline: .now() + lady_hold, repeating: .never)
            lady_timer?.setEventHandler { [weak self] in
                self?.stopRecording()
            }
            lady_timer?.resume()
        }
    }
    
}

