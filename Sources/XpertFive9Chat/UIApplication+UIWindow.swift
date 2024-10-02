//
//  File.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 24/09/2024.
//

import Foundation
import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .first { $0.isKeyWindow }
    }

    var rootViewController: UIViewController? {
        currentKeyWindow?.mostTopViewController
    }
}

extension UIWindow {
    /// Get most top view controller
    var mostTopViewController: UIViewController? {
        UIWindow.getMostTopViewController(controller: self.rootViewController)
    }

    static func getMostTopViewController(controller: UIViewController?) -> UIViewController? {
        if let presentedController = controller?.presentedViewController {
            return UIWindow.getMostTopViewController(controller: presentedController)
        } else {
            return controller
        }
    }
}
