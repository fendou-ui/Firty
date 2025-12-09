import UIKit

class Lady_MoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lady_containerView: UIView!
    @IBOutlet weak var lady_emojiLabel: UILabel!
    @IBOutlet weak var lady_nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_setupUI()
    }
    
    private func lady_setupUI() {
        lady_containerView.layer.cornerRadius = 15
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_containerView.layer.shadowColor = UIColor.black.cgColor
        lady_containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_containerView.layer.shadowRadius = 4
        lady_containerView.layer.shadowOpacity = 0.1
        
        lady_emojiLabel.font = UIFont.systemFont(ofSize: 32)
        lady_nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        lady_nameLabel.textAlignment = .center
        lady_nameLabel.textColor = UIColor.darkGray
    }
    
    func lady_configureMood(with mood: [String: String]) {
        lady_emojiLabel.text = mood["emoji"]
        lady_nameLabel.text = mood["name"]
        
        if let colorHex = mood["color"], let color = UIColor(hex: colorHex) {
            lady_containerView.backgroundColor = color.withAlphaComponent(0.2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
}
