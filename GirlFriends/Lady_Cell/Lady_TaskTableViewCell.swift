import UIKit

class Lady_TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lady_containerView: UIView!
    @IBOutlet weak var lady_checkboxButton: UIButton!
    @IBOutlet weak var lady_titleLabel: UILabel!
    @IBOutlet weak var lady_descriptionLabel: UILabel!
    @IBOutlet weak var lady_categoryView: UIView!
    @IBOutlet weak var lady_categoryLabel: UILabel!
    
    var lady_taskToggleCallback: ((Int) -> Void)?
    private var lady_taskIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_setupUI()
    }
    
    private func lady_setupUI() {
        lady_containerView.layer.cornerRadius = 12
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_containerView.layer.shadowColor = UIColor.black.cgColor
        lady_containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_containerView.layer.shadowRadius = 4
        lady_containerView.layer.shadowOpacity = 0.1
        
        lady_checkboxButton.layer.cornerRadius = 12
        lady_checkboxButton.layer.borderWidth = 2
        lady_checkboxButton.layer.borderColor = UIColor.lightGray.cgColor
        
        lady_titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        lady_titleLabel.textColor = UIColor.black
        
        lady_descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        lady_descriptionLabel.textColor = UIColor.darkGray
        lady_descriptionLabel.numberOfLines = 2
        
        lady_categoryView.layer.cornerRadius = 8
        lady_categoryLabel.font = UIFont.systemFont(ofSize: 10)
        lady_categoryLabel.textColor = UIColor.white
    }
    
    func lady_configureTask(with task: [String: Any], index: Int) {
        lady_taskIndex = index
        
        lady_titleLabel.text = task["title"] as? String ?? ""
        lady_descriptionLabel.text = task["description"] as? String ?? ""
        
        let isCompleted = task["completed"] as? Bool ?? false
        lady_updateCheckboxState(isCompleted: isCompleted)
        
        let category = task["category"] as? String ?? "default"
        lady_configureCategoryView(category: category)
    }
    
    private func lady_updateCheckboxState(isCompleted: Bool) {
        if isCompleted {
            lady_checkboxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            lady_checkboxButton.tintColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
            lady_checkboxButton.layer.borderColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1).cgColor
            
            lady_titleLabel.textColor = UIColor.lightGray
            lady_descriptionLabel.textColor = UIColor.lightGray
            
            // 添加删除线效果
            let titleText = lady_titleLabel.text ?? ""
            let attributedString = NSAttributedString(string: titleText, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.lightGray
            ])
            lady_titleLabel.attributedText = attributedString
        } else {
            lady_checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            lady_checkboxButton.tintColor = UIColor.lightGray
            lady_checkboxButton.layer.borderColor = UIColor.lightGray.cgColor
            
            lady_titleLabel.textColor = UIColor.black
            lady_descriptionLabel.textColor = UIColor.darkGray
            lady_titleLabel.attributedText = nil
        }
    }
    
    private func lady_configureCategoryView(category: String) {
        lady_categoryLabel.text = category.uppercased()
        
        switch category {
        case "social":
            lady_categoryView.backgroundColor = UIColor.systemBlue
        case "wellness":
            lady_categoryView.backgroundColor = UIColor.systemGreen
        case "entertainment":
            lady_categoryView.backgroundColor = UIColor.systemOrange
        case "custom":
            lady_categoryView.backgroundColor = UIColor.systemPurple
        default:
            lady_categoryView.backgroundColor = UIColor.systemGray
        }
    }
    
    @IBAction func lady_checkboxTapped(_ sender: UIButton) {
        // 添加点击动画
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        lady_taskToggleCallback?(lady_taskIndex)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lady_titleLabel.attributedText = nil
        lady_titleLabel.textColor = UIColor.black
        lady_descriptionLabel.textColor = UIColor.darkGray
    }
}
