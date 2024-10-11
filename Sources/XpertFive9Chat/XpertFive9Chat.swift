//
//  XpertFive9Chat.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 19/09/2024.
//

import SwiftUI

public class XpertFive9Chat {
    @MainActor
    public class func show(
        xpertConfig: XpertChatConfiguration,
        five9Config: Five9FormConfiguration? = nil,
        animated: Bool
    ) {
        if let topController = UIApplication.shared.rootViewController {
            let chatView = XpertFive9ChatView(xpertConfig: xpertConfig, five9Config: five9Config)
            let controller = UIHostingController(rootView: chatView)
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .automatic
            topController.present(controller, animated: animated)
        }
    }
}
