
import UIKit
import SVProgressHUD

class Lady_ChatBotTableViewCell: UITableViewCell {

    @IBOutlet weak var lady_message: UILabel!
    @IBOutlet weak var lady_favoriteButton: UIButton!
    
    var lady_characterName: String = ""
    var lady_characterImage: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_setupFavoriteButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func lady_setupFavoriteButton() {
        lady_favoriteButton?.setImage(UIImage(systemName: "heart"), for: .normal)
        lady_favoriteButton?.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        lady_favoriteButton?.tintColor = UIColor.red
    }
    
    @IBAction func lady_favoriteButtonTapped(_ sender: UIButton) {
        guard !lady_message.text!.isEmpty else { return }
        
        let favoriteItem: [String: String] = [
            "lady_message": lady_message.text ?? "",
            "lady_character": lady_characterName,
            "lady_image": lady_characterImage,
            "lady_time": lady_getCurrentTimeString(),
            "lady_date": lady_getCurrentDateString()
        ]
        
        lady_addToFavorites(favoriteItem)
        
        // 添加动画效果
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        SVProgressHUD.showSuccess(withStatus: "Added to favorites! ❤️")
    }
    
    private func lady_addToFavorites(_ item: [String: String]) {
        var favorites = UserDefaults.standard.object(forKey: "lady_favorites") as? [[String: String]] ?? []
        
        // 检查是否已经收藏过相同内容
        let isDuplicate = favorites.contains { favorite in
            return favorite["lady_message"] == item["lady_message"] && 
                   favorite["lady_character"] == item["lady_character"]
        }
        
        if !isDuplicate {
            favorites.insert(item, at: 0) // 插入到最前面
            
            // 限制收藏数量为100条
            if favorites.count > 100 {
                favorites = Array(favorites.prefix(100))
            }
            
            UserDefaults.standard.setValue(favorites, forKey: "lady_favorites")
        }
    }
    
    private func lady_getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    private func lady_getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
