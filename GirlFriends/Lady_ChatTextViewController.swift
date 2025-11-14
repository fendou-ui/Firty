
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
