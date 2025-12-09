
import UIKit
import AVFoundation
class Lady_SeeVideoViewController: UIViewController {

    @IBOutlet weak var ladyView: UIView!
    private var lady_player: AVPlayer?
    private var lady_layer: AVPlayerLayer?
    var video_adress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    @IBAction func lady_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func lady_appInitConfigerVideo() {
        if let path = Bundle.main.url(forResource: self.video_adress, withExtension: "mp4") {
            
//            let url = URL(fileURLWithPath: path)

            lady_layer?.removeFromSuperlayer()
            lady_player?.pause()
            
            let player = AVPlayer(url: path)
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.bounds
            self.ladyView.layer.addSublayer(layer)
            
            self.lady_player = player
            self.lady_layer = layer
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(lady_loopVideo),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem
            )
            
            DispatchQueue.main.async {
                player.play()
            }
        }
    }
    
    @objc private func lady_loopVideo() {
        lady_player?.seek(to: .zero)
        lady_player?.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lady_layer?.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func lady_playStop() {
        lady_player?.pause()
        lady_player = nil
        lady_layer?.removeFromSuperlayer()
        lady_layer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lady_playStop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lady_appInitConfigerVideo()
    }

}
