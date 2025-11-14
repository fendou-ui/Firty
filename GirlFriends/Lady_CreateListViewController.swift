
import UIKit

class Lady_CreateListViewController: UIViewController {

    @IBOutlet weak var lady_gems_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "gems") != nil {
            self.lady_gems_label.text = UserDefaults.standard.object(forKey: "gems") as? String
        }
    }

    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_createButtons(_ sender: UIButton) {
        if sender.tag == 123 {
            let ceart = Lady_CreateViewController()
            self.navigationController?.pushViewController(ceart, animated: true)
            return
        }
        self.navigationController?.pushViewController(Lady_GemstoneViewController(), animated: true)
    }
    
}
