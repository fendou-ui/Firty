import UIKit

class Lady_FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lady_containerView: UIView!
    @IBOutlet weak var lady_characterImageView: UIImageView!
    @IBOutlet weak var lady_characterLabel: UILabel!
    @IBOutlet weak var lady_messageLabel: UILabel!
    @IBOutlet weak var lady_timeLabel: UILabel!
    @IBOutlet weak var lady_favoriteButton: UIButton!
    
    private var lady_favoriteItem: [String: String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_setupUI()
    }
    
    private func lady_setupUI() {
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_containerView.layer.cornerRadius = 12
        lady_containerView.layer.shadowColor = UIColor.black.cgColor
        lady_containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_containerView.layer.shadowRadius = 4
        lady_containerView.layer.shadowOpacity = 0.1
        
        lady_characterImageView.layer.cornerRadius = 25
        lady_characterImageView.clipsToBounds = true
        
        lady_messageLabel.numberOfLines = 3
        lady_messageLabel.textColor = UIColor.darkGray
        
        lady_characterLabel.font = UIFont.boldSystemFont(ofSize: 16)
        lady_characterLabel.textColor = UIColor.black
        
        lady_timeLabel.font = UIFont.systemFont(ofSize: 12)
        lady_timeLabel.textColor = UIColor.lightGray
        
        lady_favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        lady_favoriteButton.tintColor = UIColor.red
    }
    
    func lady_configureCell(with item: [String: String]) {
        lady_favoriteItem = item
        
        lady_characterLabel.text = item["lady_character"] ?? "Unknown"
        lady_messageLabel.text = item["lady_message"] ?? ""
        lady_timeLabel.text = item["lady_time"] ?? ""
        
        if let imageName = item["lady_image"] {
            lady_characterImageView.image = UIImage(named: imageName)
        } else {
            lady_characterImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    @IBAction func lady_favoriteButtonTapped(_ sender: UIButton) {
        // 从收藏中移除的动画效果
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
                self.alpha = 1.0
            }
        }
        
        // 通知父视图控制器移除此项
        if let favoriteVC = self.lady_findViewController() as? Lady_FavoritesViewController {
            // 这里可以添加移除逻辑
        }
    }
}

extension UIView {
    func lady_findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.lady_findViewController()
        } else {
            return nil
        }
    }
}
