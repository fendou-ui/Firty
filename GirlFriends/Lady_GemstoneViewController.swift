
import UIKit
import SwiftyStoreKit
import SVProgressHUD
class Lady_GemstoneViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var lady_collectionView: UICollectionView!
    @IBOutlet weak var lady_labels: UILabel!
    private var lady_select: Int = 0
    private var lady_stones = [[String: String]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let lady_layout = UICollectionViewFlowLayout()
        lady_layout.scrollDirection = .vertical
        lady_layout.minimumInteritemSpacing = 10
        lady_layout.minimumLineSpacing = 10
        lady_layout.itemSize = CGSizeMake((UIScreen.main.bounds.width - 52.1)/3, 154)
        lady_layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        lady_collectionView.dataSource = self
        lady_collectionView.delegate = self
        lady_collectionView.backgroundColor = .clear
        lady_collectionView.collectionViewLayout = lady_layout
        lady_collectionView.register(UINib(nibName: "Lady_GemstoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gems")
        lady_stones = [
            ["lady_amount":"100", "lady_sale":"$0.99", "lady_id":"jtixlyrxqppvkwwx"],
            ["lady_amount":"200", "lady_sale":"$1.99", "lady_id":"sebkcglsfohvheyh"],
            ["lady_amount":"800", "lady_sale":"$4.99", "lady_id":"pmyxlpfenpqsuzvj"],
            ["lady_amount":"1800", "lady_sale":"$9.99", "lady_id":"aggdroodxmpbnvuk"],
            ["lady_amount":"4000", "lady_sale":"$19.99", "lady_id":"npoqmlbsmqhwplov"],
            ["lady_amount":"12000", "lady_sale":"$49.99", "lady_id":"rixchyvhnbsqeakj"],
            ["lady_amount":"28880", "lady_sale":"$99.99", "lady_id":"aijxlzvltnvssppx"],
        ]
    }

    @IBAction func lady_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    private func lady_paymentSuccess() {
        let dict = lady_stones[lady_select]
        let amount = Int(dict["lady_amount"] ?? "")
        let vaule = Int(self.lady_labels.text!)
        self.lady_labels.text = "\(amount! + vaule!)"
        UserDefaults.standard.setValue(self.lady_labels.text!, forKey: "gems")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "gems") != nil {
            self.lady_labels.text = UserDefaults.standard.object(forKey: "gems") as? String
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lady_stones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = lady_stones[indexPath.row]
        let gems = collectionView.dequeueReusableCell(withReuseIdentifier: "gems", for: indexPath) as! Lady_GemstoneCollectionViewCell
        gems.backgroundColor = .clear
        gems.lady_price.backgroundColor = .black
        if lady_select == indexPath.row {
            gems.lady_price.backgroundColor = UIColor(red: 129/255, green: 116/255, blue: 248/255, alpha: 1.0)
        }
        gems.lady_gems.text = obj["lady_amount"]
        gems.lady_price.text = obj["lady_sale"]
        return gems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lady_select = indexPath.row
        let obj = lady_stones[indexPath.row]
        lady_collectionView.reloadData()
        self.lady_swiftyStoreKitPayment(iosId: obj["lady_id"]!)
    }
    
    func lady_swiftyStoreKitPayment(iosId: String) {
        SVProgressHUD.show()
        SwiftyStoreKit.purchaseProduct(iosId, quantity: 1, atomically: false) { result in
            
            switch result {
            case .success(let purchase):
            
                self.lady_swiftSuccessComplete(iosId: purchase.productId, transaction: purchase.transaction)
                
            case .error(let error):
                SVProgressHUD.dismiss()
                switch error.code {
                case .unknown:
                    SVProgressHUD.showInfo(withStatus: "Unknown error")
                case .clientInvalid:
                    SVProgressHUD.showInfo(withStatus: "Users are not allowed to make payments")
                case .paymentCancelled:
                    SVProgressHUD.showInfo(withStatus: "The user cancels the payment")
                case .paymentInvalid:
                    SVProgressHUD.showInfo(withStatus: "The product was not found")
                default:
                    break
                }
            }
        }
    }

    func lady_swiftSuccessComplete(iosId: String, transaction: PaymentTransaction) {
           
        SVProgressHUD.showInfo(withStatus: "Purchase in progress. Please do not exit")
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                
                if receiptString.count > 0 {
                    SVProgressHUD.dismiss()
                    SwiftyStoreKit.finishTransaction(transaction)
                    self.lady_paymentSuccess()
                }
                else {
                    SVProgressHUD.showInfo(withStatus: "Failed")
                }
            }
            catch {
                SVProgressHUD.showInfo(withStatus: "Failed to retrieve transaction")
            }
        }
    }


    
}
