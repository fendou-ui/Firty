
import UIKit
import SafariServices

class Lady_SetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
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
        else if sender.tag == 107 {
            let gems = Lady_GemstoneViewController()
            gems.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gems, animated: true)
        }
        else {
            let about = Lady_AboutViewController()
            about.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(about, animated: true)
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
