
import UIKit

class Lady_PartnerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }

    @IBAction func lady_rootViewController(_ sender: Any) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController: Lady_HomeViewController())
        }
    }
    
}
