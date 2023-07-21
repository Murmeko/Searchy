//
//  UIApplication+Extension.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

public extension UIApplication {
  func firstWindow() -> UIWindow? {
    guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
    return firstScene.windows.first
  }
}
