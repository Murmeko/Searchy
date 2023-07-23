//
//  UIView+Extension.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import UIKit

extension UIView {
  func startShimmering() {
    let light = UIColor.white.cgColor
    let alpha = UIColor.white.withAlphaComponent(0.7).cgColor

    let gradient = CAGradientLayer()
    gradient.colors = [alpha, light, alpha]
    gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
    gradient.locations = [0.4, 0.5, 0.6]
    self.layer.mask = gradient

    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [0.0, 0.1, 0.2]
    animation.toValue = [0.8, 0.9, 1.0]
    animation.duration = 1.5
    animation.repeatCount = HUGE
    gradient.add(animation, forKey: "shimmer")
  }
}
