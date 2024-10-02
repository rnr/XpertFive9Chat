//
//  XpertFive9HTMLWebViewRepresentable.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 19/09/2024.
//

import Foundation
import SwiftUI
import WebKit
import SafariServices

enum WKScriptEvent: String {
    case closeChat
    case openedChat
    case clickedFive9
}

struct XpertFive9HTMLWebViewRepresentable: UIViewRepresentable {
    var html: String?
    var baseURL: URL?
    @Binding var closeChat: Bool
    @Binding var openedChat: Bool
    @Binding var clickedFive9: Bool
    
    init(
        html: String?,
        baseURL: URL?,
        closeChat: Binding<Bool>,
        openedChat: Binding<Bool>,
        clickedFive9: Binding<Bool>
    ) {
        self.html = html
        self.baseURL = baseURL
        self._closeChat = closeChat
        self._openedChat = openedChat
        self._clickedFive9 = clickedFive9
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.backgroundColor = .clear

        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        #endif

        webView.configuration.userContentController.add(
            context.coordinator,
            name: WKScriptEvent.closeChat.rawValue
        )
        webView.configuration.userContentController.add(
            context.coordinator,
            name: WKScriptEvent.openedChat.rawValue
        )
        webView.configuration.userContentController.add(
            context.coordinator,
            name: WKScriptEvent.clickedFive9.rawValue
        )
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let html = html, html != context.coordinator.previousHTML {
            webView.loadHTMLString(html, baseURL: baseURL)
            context.coordinator.previousHTML = html
        }
        if clickedFive9 && UIDevice.current.userInterfaceIdiom == .pad {
            webView.scrollView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator: Coordinator = Coordinator(
            closeChat: $closeChat,
            openedChat: $openedChat,
            clickedFive9: $clickedFive9
        )
        return coordinator
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.configuration.userContentController.removeScriptMessageHandler(
            forName: WKScriptEvent.closeChat.rawValue
        )
        uiView.configuration.userContentController.removeScriptMessageHandler(
            forName: WKScriptEvent.openedChat.rawValue
        )
        uiView.configuration.userContentController.removeScriptMessageHandler(
            forName: WKScriptEvent.clickedFive9.rawValue
        )
    }
}

extension XpertFive9HTMLWebViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        @Binding var closeChat: Bool
        @Binding var openedChat: Bool
        @Binding var clickedFive9: Bool

        public var previousHTML: String?
        
        init(closeChat: Binding<Bool>, openedChat: Binding<Bool>, clickedFive9: Binding<Bool>) {
            self._closeChat = closeChat
            self._openedChat = openedChat
            self._clickedFive9 = clickedFive9
        }
        
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            if message.name == WKScriptEvent.closeChat.rawValue {
                if !closeChat {
                    closeChat = true
                }
            }
            if message.name == WKScriptEvent.openedChat.rawValue {
                if !openedChat {
                    openedChat = true
                }
            }
            if message.name == WKScriptEvent.clickedFive9.rawValue {
                if !clickedFive9 {
                    clickedFive9 = true
                }
            }
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if navigationAction.targetFrame == nil,
                let url = navigationAction.request.url {
                let controller = SFSafariViewController(url: url)
                controller.modalPresentationStyle = .pageSheet
                UIApplication.shared.rootViewController?.present(controller, animated: true)
            }
            print("WebView createWebViewWith")
            return nil
        }
    }
}
