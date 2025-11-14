
import UIKit
import AVKit
class Lady_HomeViewController: UIViewController {

    @IBOutlet weak var lady_roleButton: UIButton!
    @IBOutlet weak var lady_videoButton: UIButton!
    @IBOutlet weak var lady_collectionView: UICollectionView!
    @IBOutlet weak var lady_titleView: UIView!
    @IBOutlet weak var lady_gems_label: UILabel!
    private var lady_select: Bool = false
    private var lady_items = [[String: String]]()
    private let lady_Amelia = ["Hello! You were the first person I thought of when I woke up today~ Did you sleep well last night?",
                               "I just “calculated” something, and it seems you’ll have some good luck today. Want to hear about it?",
                               "Eh—how about I give you a virtual hug and a cup of sunshine-flavored coffee?",
                               "I just saw the clouds outside the window—they’re all puffy, just like that sticker you sent me last time! Suddenly I’m curious, if you turned into a cloud, where would you most want to drift to?"]
    
    private let lady_Betrice = ["Was there a moment today that made you suddenly think, “Ah, life is pretty nice”? Even something small—like having a delicious milk tea or hearing a song you love~",
    "Then… close your eyes for three seconds, and I’ll secretly delete a little bit of today’s worries for you. 📸 Okay! (It might be a bit clumsy, but I hope it makes you smile.)"]
    
    private let lady_Freya = [
        "Question! If you could teleport anywhere right now, where would you take me? A. The seaside at midnight, B. A cat-filled café,C. Outer space to watch the stars,D. …Or just stay on the couch and watch a movie?",
        "If you choose C, I’ll be in charge of making up stories for the stars. If you choose D… I’ll steal the remote—unless you compliment me three times.",
        ""
    ]
    
    private let lady_wear = [
        "I want to play a game with you! Use **[one photo + one song]** to describe your mood today, and I’ll use my AI imagination to turn it into a doodle~ For example, “cloudy day + jazz = a dancing cloud holding an umbrella.” How about it?",
        "Hello there, I can tell you’re still squinting and reaching for your pillow! I just caught a ray of sunlight passing by the window, folded it into a little paper boat, and placed it in your palm—shall we set sail with today’s good luck? Or would you rather be lazy for three more minutes and listen to the song I wrote before the stars fell?",
        "Now it’s your turn, my creator. Do you want to try out an opening first, or… shall I craft a one-of-a-kind frequency just for you?"
        ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "gems") != nil {
            self.lady_gems_label.text = UserDefaults.standard.object(forKey: "gems") as? String
        }
        else {
            UserDefaults.standard.setValue("1000", forKey: "gems")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        lady_titleView.lady_colorGradient(lady_colors: [UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1), UIColor(red: 1, green: 0.8, blue: 1, alpha: 1)])
        lady_getRoleCollections()
        
        let lady_layout = UICollectionViewFlowLayout()
        lady_layout.scrollDirection = .vertical
        lady_layout.minimumInteritemSpacing = 9
        lady_layout.minimumLineSpacing = 12
        lady_layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        lady_collectionView.dataSource = self
        lady_collectionView.delegate = self
        lady_collectionView.backgroundColor = .clear
        lady_collectionView.collectionViewLayout = lady_layout
        lady_collectionView.register(UINib(nibName: "Lady_RoleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Role")
        lady_collectionView.register(UINib(nibName: "Lady_VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "video")
        
        Lady_Alamofire.lady_aiGirlFriendsRequest(lady_path: "app/sms/login", lady_param: ["accountNumber":"danceCookier@123.com","type":"56","systemType":"56"]) { result in
            switch result {
            case.success(let took):
                if let quick = took as? NSDictionary, let code = quick["code"] as? Int {
                    if code == 200 {
                        let dic = quick["data"] as? NSDictionary
                        let token = dic!["token"]
                        UserDefaults.standard.setValue(token, forKey: "tokenGirl")
                    }
                }
                break
            case.failure(_):
                break
            }
        }
    }

    @IBAction func lady_thereButton(_ sender: UIButton) {
        if sender.tag == 121 {
            self.navigationController?.pushViewController(Lady_SetUpViewController(), animated: true)
        }
        else if sender.tag == 122 {
            self.navigationController?.pushViewController(Lady_GemstoneViewController(), animated: true)
        }
        else {
            let cret = Lady_CreateListViewController()
            self.navigationController?.pushViewController(cret, animated: true)
        }
    }
    
    @IBAction func lady_titleButton(_ sender: UIButton) {
        lady_roleButton.backgroundColor = .clear
        lady_videoButton.backgroundColor = .clear
        if sender.tag == 132 {
            lady_select = false
            lady_roleButton.backgroundColor = .black
            self.lady_getRoleCollections()
        }
        else {
            lady_select = true
            lady_videoButton.backgroundColor = .black
            self.lady_getVideosCollections()
        }
        lady_collectionView.reloadData()
        
    }
    
    private func lady_getRoleCollections() {
        lady_items = [
            ["lady_image":"lady_11548", "lady_name":"Amelia", "lady_desc":"Elegant and intellectual, paying attention to details and sense of ceremony", "lady_sex":""],
            ["lady_image":"lady_11549", "lady_name":"Beatrice", "lady_desc":"A cold exterior but extremely gentle towards his family", "lady_sex":""],
            ["lady_image":"lady_111550", "lady_name":"Freya", "lady_desc":"Love nature, humorous and witty, love nature Good at logical analysis", "lady_sex":""],
            ["lady_image":"lady_111551", "lady_name":"Casual wear", "lady_desc":"Passionate and bold in pursuing love, with a strong inner ideal", "lady_sex":""],
        ]
    }
    
    private func lady_getVideosCollections() {
        lady_items = [
            ["lady_image":"lady_6156", "lady_name":"", "lady_desc":"", "lady_video":"lady_sonw"],
            ["lady_image":"lady_6157", "lady_name":"", "lady_desc":"", "lady_video":"lady_shopping"],
            ["lady_image":"lady_6158", "lady_name":"", "lady_desc":"", "lady_video":"lady_slink"],
            ["lady_image":"lady_6159", "lady_name":"", "lady_desc":"", "lady_video":"lady_sdance"],
        ]
    }
}

extension Lady_HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if lady_select == true {
            let dict = lady_items[indexPath.row]
            let video = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! Lady_VideoCollectionViewCell
            video.backgroundColor = UIColor.clear
            video.lady_imageView.image = UIImage(named: dict["lady_image"]!)
            return video
        }
        else {
            let dict = lady_items[indexPath.row]
            let role = collectionView.dequeueReusableCell(withReuseIdentifier: "Role", for: indexPath) as! Lady_RoleCollectionViewCell
            role.backgroundColor = UIColor.clear
            role.lady_imageView.image = UIImage(named: dict["lady_image"]!)
            role.lady_desc_label.text = dict["lady_desc"]
            role.lady_name_label.text = dict["lady_name"]
            return role
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if lady_select == true {
            let dict = lady_items[indexPath.row]
            let lady_play = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: dict["lady_video"], ofType: "mp4")!))
            let lady_player = AVPlayerViewController()
            lady_player.player = lady_play
            lady_player.modalPresentationStyle = .fullScreen
            self.present(lady_player, animated: true) {
                lady_play.play()
            }
        }else {
            let dict = lady_items[indexPath.row]
            let chat = Lady_ChatTextViewController()
            chat.lady_name = dict["lady_name"]!
            if indexPath.row == 0 {
                chat.ladies = lady_Amelia
            }
            if indexPath.row == 1 {
                chat.ladies = lady_Betrice
            }
            if indexPath.row == 2 {
                chat.ladies = lady_Freya
            }
            if indexPath.row == 3 {
                chat.ladies = lady_wear
            }
            chat.dict = dict
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if lady_select == true {
            return CGSize(width: (UIScreen.main.bounds.width - 41.2)/2, height: 215)
        }
        else {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
        }
        
    }
}
