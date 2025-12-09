
import UIKit

class Lady_CreateTableViewCell: UITableViewCell {

    @IBOutlet weak var lady_view: UIView!
    @IBOutlet weak var lady_imageView: UIImageView!
    @IBOutlet weak var lady_desc_label: UILabel!
    @IBOutlet weak var lady_name_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_imageView.layer.cornerRadius = 12
        lady_imageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.lady_view.lady_colorGradient(lady_colors: [UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1), UIColor(red: 0.84, green: 0.72, blue: 0.91, alpha: 1), UIColor(red: 0.72, green: 0.64, blue: 0.92, alpha: 1)])
        }
        
    }
    
}
