
import UIKit

class Lady_VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lady_imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

}
