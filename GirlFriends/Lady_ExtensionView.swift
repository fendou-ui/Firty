
import Foundation
import UIKit

extension UIView {
    
    func lady_colorGradient(
            lady_colors: [UIColor],
            lady_begin: CGPoint = CGPoint(x: 0, y: 0),
            lady_end: CGPoint = CGPoint(x: 1, y: 1),
            cornerRadius: CGFloat = 12
        ) {
            layer.sublayers?.removeAll(where: { $0.name == "GradientLayer" })
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = "GradientLayer"
            gradientLayer.colors = lady_colors.map { $0.cgColor }
            gradientLayer.startPoint = lady_begin
            gradientLayer.endPoint = lady_end
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            gradientLayer.masksToBounds = true
            
            layer.insertSublayer(gradientLayer, at: 0)
        }
    
}
