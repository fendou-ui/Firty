
import UIKit
import SVProgressHUD
class Lady_ChatTextViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lady_title: UILabel!
    @IBOutlet weak var lady_text: UITextField!
    @IBOutlet weak var lady_tableView: UITableView!
    var lady_items = [[String: String]]()
    var dict = [String: String]()
    var ladies = [String]()
    var lady_str: String = ""
    var lady_name: String = ""
    var lady_avatar: String = ""
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if lady_items.count > 0 {
            UserDefaults.standard.setValue(lady_items, forKey: lady_name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_title.text = lady_name
        if UserDefaults.standard.object(forKey: lady_name) != nil {
            lady_items = UserDefaults.standard .object(forKey: lady_name) as! [[String: String]]
        }
        lady_tableView.dataSource = self
        lady_tableView.delegate = self
        lady_tableView.register(UINib(nibName: "Lady_ChatBotTableViewCell", bundle: nil), forCellReuseIdentifier: "bot")
        lady_tableView.register(UINib(nibName: "Lady_ChatUserTableViewCell", bundle: nil), forCellReuseIdentifier: "user")
        
    }
    
    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_chatMoviesCalls(_ sender: Any) {
        let chat = Lady_ChatVoiceViewController()
        chat.dict = dict
        chat.ladies = ladies
        chat.modalPresentationStyle = .fullScreen
        self.present(chat, animated: true, completion: nil)
    }
    
    @IBAction func lady_favoriteButton(_ sender: UIButton) {
        // 显示收藏列表供用户选择要收藏的对话
        lady_showFavoriteSelectionAlert()
//        sender.isSelected = !sender.isSelected
    }
    
    private func lady_showFavoriteSelectionAlert() {
        // 筛选出 bot 的消息
        let botMessages = lady_items.filter { $0["id"] == "bot" && !($0["message"]?.isEmpty ?? true) }
        
        guard !botMessages.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "No messages to favorite yet")
            return
        }
        
        // 创建一个自定义的选择视图控制器
        let selectionVC = Lady_FavoriteSelectionViewController()
        selectionVC.messages = Array(botMessages.suffix(10).reversed()) // 显示最近10条
        selectionVC.onMessageSelected = { [weak self] message in
            self?.lady_addToFavorites(message: message)
        }
        
        let navController = UINavigationController(rootViewController: selectionVC)
        navController.modalPresentationStyle = .pageSheet
        
        // 设置半屏显示
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
    }
    
    private func lady_addToFavorites(message: String) {
        let favoriteItem: [String: String] = [
            "lady_message": message,
            "lady_character": lady_name,
            "lady_image": dict["lady_image"] ?? "",
            "lady_time": lady_getCurrentTimeString(),
            "lady_date": lady_getCurrentDateString()
        ]
        
        var favorites = UserDefaults.standard.object(forKey: "lady_favorites") as? [[String: String]] ?? []
        
        // 检查是否已经收藏过相同内容
        let isDuplicate = favorites.contains { favorite in
            return favorite["lady_message"] == favoriteItem["lady_message"] && 
                   favorite["lady_character"] == favoriteItem["lady_character"]
        }
        
        if isDuplicate {
            SVProgressHUD.showInfo(withStatus: "Already in favorites")
            return
        }
        
        // 插入到最前面
        favorites.insert(favoriteItem, at: 0)
        
        // 限制收藏数量为100条
        if favorites.count > 100 {
            favorites = Array(favorites.prefix(100))
        }
        
        UserDefaults.standard.setValue(favorites, forKey: "lady_favorites")
        
        // 显示成功提示
        SVProgressHUD.showSuccess(withStatus: "Added to favorites! ❤️")
    }
    
    private func lady_getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    private func lady_getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    @IBAction func lady_sendChat(_ sender: Any) {
        if lady_text.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "")
            return
        }
        let lady_obj = ["message":lady_text.text!, "id":"user"]
        lady_items.append(lady_obj)
        let lady_dict = ["message":"", "id":"bot"]
        lady_items.append(lady_dict)
        lady_text.resignFirstResponder()
        lady_tableView.reloadData()
        
        let lwet = dream_getTimerRandomStr()
        lady_openBotChatMessages(lady_id: lwet, message: lady_text.text!)
        Lady_Mobile.lady.lady_Event = { [weak self] status in
            switch status {
            case .lady_Connected:
                break
            case .lady_Received(let msg):
                print("Message: \(msg)")
                if msg.elementsEqual("DONE") {
                    SVProgressHUD.dismiss()
                    Lady_Mobile.lady.lady_endSocket()
                    return
                }
                self?.dream_textUpdateString(text: msg)
                
            case .lady_Failure(let err):
                print("Error: \(err)")
            case .lady_Disconnected:
                print("Disconnected")
            }
        }
        
        if let url = URL(string: "wss://longaougydijamntvuybiu.tcqyhxy.top/websocket/\(lwet)") {
            Lady_Mobile.lady.lady_sendChatText(to: url)
            lady_text.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lady_model = lady_items[indexPath.row]
        if lady_model["id"] == "user" {
            let user = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! Lady_ChatUserTableViewCell
            user.selectionStyle = .none
            user.backgroundColor = .clear
            user.lady_message.text = lady_model["message"]
            return user
        }
        else {
            let bot = tableView.dequeueReusableCell(withIdentifier: "bot", for: indexPath) as! Lady_ChatBotTableViewCell
            bot.selectionStyle = .none
            bot.backgroundColor = .clear
            bot.lady_message.text = lady_model["message"]
            bot.lady_characterName = lady_name
            bot.lady_characterImage = dict["lady_image"] ?? ""
            return bot
        }
        return UITableViewCell()
    }
    
    private func dream_textUpdateString(text: String) {
        var dict: [String: String] = NSDictionary() as! [String: String]
        lady_str = lady_str + text
        dict = ["message":lady_str, "id":"bot"]
        if lady_str.elementsEqual(text) && text.count == 0 {
            return
        }
        lady_items[lady_items.count-1] = dict
        lady_tableView.reloadData()
    }
    
    
    func dream_getTimerRandomStr(length: Int = 18) -> String {
        let str = Array("jklmno0123sdfdsb4567vwxyz89abcdefghiopqrstu")
        var random = ""
        for _ in 0..<length {
            if let randomChar = str.randomElement() {
                random.append(randomChar)
            }
        }
        return random
    }
}
