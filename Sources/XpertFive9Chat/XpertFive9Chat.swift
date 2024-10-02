// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public class XpertFive9Chat {
    @MainActor
    public class func show(
        xpertConfig: XpertChatConfiguration,
        animated: Bool
    ) {
        if let topController = UIApplication.shared.rootViewController {
            let chatView = XpertFive9ChatView(xpertConfig: xpertConfig)
            let controller = UIHostingController(rootView: chatView)
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .automatic
            if UIDevice.current.userInterfaceIdiom == .pad {
                controller.view.backgroundColor = .clear
            }
            topController.present(controller, animated: animated)
        }
    }
}
