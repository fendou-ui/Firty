
import UIKit

class Lady_GemstoneCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lady_gems: UILabel!
    @IBOutlet weak var lady_price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lady_price.layer.cornerRadius = 19
        lady_price.layer.masksToBounds = true
    }

}
