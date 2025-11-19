
import UIKit
import SafariServices
class Lady_LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func lady_loginQuick(_ sender: Any) {
        self.navigationController?.pushViewController(Lady_PartnerViewController(), animated: true)
    }
    
    @IBAction func lady_userbarAndPolicy(_ sender: UIButton) {
        if sender.tag == 108 {
            self.lady_showSwioftUIPolicy(lady_url: "https://app.2i71agjk.link")
        }
        else {
            self.lady_showSwioftUIPolicy(lady_url: "https://app.2i71agjk.link/Firty-privacy")
        }
    }
    
    private func lady_showSwioftUIPolicy(lady_url: String) {
        guard let url = URL(string: lady_url) else {
            return
        }

        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true)
    }
}
