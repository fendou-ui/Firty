
import UIKit

class Lady_AboutViewController: UIViewController {

    @IBOutlet weak var lady_icon: UIImageView!
    @IBOutlet weak var lady_appName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_icon.layer.cornerRadius = 12
        
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            lady_appName.text = appName
        }
    }

    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
