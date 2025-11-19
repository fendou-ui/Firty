
import UIKit

class Lady_CreateListViewController: UIViewController {

    @IBOutlet weak var lady_gems_label: UILabel!
    @IBOutlet weak var lady_tableView: UITableView!
    @IBOutlet weak var lady_image: UIImageView!
    var lady_lists = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        lady_tableView.delegate = self
        lady_tableView.dataSource = self
        lady_tableView.register(UINib(nibName: "Lady_CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "role")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "gems") != nil {
            self.lady_gems_label.text = UserDefaults.standard.object(forKey: "gems") as? String
        }
        
        if UserDefaults.standard.object(forKey: "create") != nil {
            self.lady_image.isHidden = true
            self.lady_lists = UserDefaults.standard.object(forKey: "create") as! [[String: String]]
        }
        lady_tableView.reloadData()
    }
    
    @IBAction func lady_createButtons(_ sender: UIButton) {
        if sender.tag == 123 {
            let ceart = Lady_CreateViewController()
            ceart.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ceart, animated: true)
            return
        }
        let gems = Lady_GemstoneViewController()
        gems.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gems, animated: true)
    }
    
}

extension Lady_CreateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = lady_lists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "role", for: indexPath) as! Lady_CreateTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.lady_imageView.image = UIImage(named: dict["lady_image"]!)
        cell.lady_desc_label.text = dict["lady_desc"]
        cell.lady_name_label.text = dict["lady_name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = lady_lists[indexPath.row]
        let chat = Lady_ChatTextViewController()
        chat.lady_name = dict["lady_name"]!
//        if indexPath.row == 0 {
//            chat.ladies = lady_Amelia
//        }
//        if indexPath.row == 1 {
//            chat.ladies = lady_Betrice
//        }
//        if indexPath.row == 2 {
//            chat.ladies = lady_Freya
//        }
//        if indexPath.row == 3 {
//            chat.ladies = lady_wear
//        }
        chat.dict = dict
        chat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
