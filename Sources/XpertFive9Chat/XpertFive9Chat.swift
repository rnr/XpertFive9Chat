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
