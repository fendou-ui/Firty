import UIKit

class Lady_MoodHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lady_containerView: UIView!
    @IBOutlet weak var lady_emojiLabel: UILabel!
    @IBOutlet weak var lady_nameLabel: UILabel!
    @IBOutlet weak var lady_dateLabel: UILabel!
    @IBOutlet weak var lady_timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_setupUI()
    }
    
    private func lady_setupUI() {
        lady_containerView.layer.cornerRadius = 12
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_containerView.layer.shadowColor = UIColor.black.cgColor
        lady_containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        lady_containerView.layer.shadowRadius = 3
        lady_containerView.layer.shadowOpacity = 0.1
        
        lady_emojiLabel.font = UIFont.systemFont(ofSize: 28)
        lady_nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        lady_nameLabel.textColor = UIColor.black
        
        lady_dateLabel.font = UIFont.systemFont(ofSize: 14)
        lady_dateLabel.textColor = UIColor.darkGray
        
        lady_timeLabel.font = UIFont.systemFont(ofSize: 12)
        lady_timeLabel.textColor = UIColor.lightGray
    }
    
    func lady_configureMoodHistory(with mood: [String: String]) {
        lady_emojiLabel.text = mood["emoji"]
        lady_nameLabel.text = mood["name"]
        lady_dateLabel.text = lady_formatDate(mood["date"] ?? "")
        lady_timeLabel.text = mood["time"] ?? ""
        
        if let colorHex = mood["color"], let color = UIColor(hex: colorHex) {
            lady_containerView.backgroundColor = color.withAlphaComponent(0.15)
        }
    }
    
    private func lady_formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM dd"
            return formatter.string(from: date)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lady_containerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
}
