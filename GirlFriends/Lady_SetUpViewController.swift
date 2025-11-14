
import UIKit
import SafariServices

class Lady_SetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_SetUpbuttons(_ sender: UIButton) {
        if sender.tag == 108 {
            self.lady_showSwioftUIPolicy(lady_url: "https://app.2i71agjk.link")
        }
        else if sender.tag == 109 {
            self.lady_showSwioftUIPolicy(lady_url: "https://app.2i71agjk.link/Firty-privacy")
        }
        else {
            self.navigationController?.pushViewController(Lady_AboutViewController(), animated: true)
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
