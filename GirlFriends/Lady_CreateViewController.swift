
import UIKit
import SVProgressHUD
class Lady_CreateViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lady_imageView: UIImageView!
    @IBOutlet weak var lady_name_filed: UITextField!
    @IBOutlet weak var lady_holder: UILabel!
    @IBOutlet weak var lady_matery_textView: UITextView!
    @IBOutlet weak var lady_place: UILabel!
    @IBOutlet weak var lady_preface_textView: UITextView!
    @IBOutlet weak var lady_gemsView: UIView!
    @IBOutlet weak var lady_bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_imageView.layer.cornerRadius = 59
        lady_matery_textView.delegate = self
        lady_preface_textView.delegate = self
        self.lady_bgView.isHidden = true
    }

    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_bottomViewSelect(_ sender: UIButton) {
        for (index, subview) in lady_gemsView.subviews.enumerated() {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "lady-gems"), for: .normal)
                if button == sender {
                    print(index)
                    button.setImage(UIImage(named: "lady-gems.se"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func lady_createAI(_ sender: UIButton) {
        if sender.tag == 99 {
            self.lady_bgView.isHidden = true
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.81) {
                SVProgressHUD.showSuccess(withStatus: "Created successfully. Awaiting review")
                self.navigationController?.popViewController(animated: true)
            }
            if UserDefaults.standard.object(forKey: "gems") != nil {
                var gems = Int(UserDefaults.standard.object(forKey: "gems") as! String)!
                gems = gems - 100
                UserDefaults.standard.setValue("\(gems)", forKey: "gems")
            }
            return
        }
        if sender.tag == 199 {
            self.lady_bgView.isHidden = true
            return
        }
        if sender.tag == 122 {
            if lady_preface_textView.text.count == 0 {
                SVProgressHUD.showInfo(withStatus: "Please enter the content")
                return
            }
            if lady_matery_textView.text.count == 0 {
                SVProgressHUD.showInfo(withStatus: "Please enter the content")
                return
            }
            if lady_name_filed.text?.count == 0 {
                SVProgressHUD.showInfo(withStatus: "Please enter the content")
                return
            }
            
            self.lady_bgView.isHidden = false
        }
        
    }
    
    @IBAction func lady_choosePhoto(_ sender: Any) {
        let lady_pick = UIImagePickerController()
        lady_pick.delegate = self
        lady_pick.sourceType = .photoLibrary
        lady_pick.allowsEditing = false
        lady_pick.modalPresentationStyle = .fullScreen
        present(lady_pick, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lady_holder.text = ""
        lady_place.text = ""
        if lady_preface_textView.text.count == 0 {
            lady_place.text = "Please enter your personal preface"
        }
        if lady_matery_textView.text.count == 0 {
            lady_holder.text = "Please enter your personal information"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            self.lady_imageView.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
