//
//  XpertFive9ChatViewModel.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 19/09/2024.
//

import Foundation

public class XpertFive9ChatViewModel: ObservableObject {
    private var xpertConfiguration: XpertChatConfiguration
    
    init(xpertConfig: XpertChatConfiguration) {
        self.xpertConfiguration = xpertConfig
    }
        
    // swiftlint:disable line_length
    // MARK: Xpert
    public var xpertHTML: String {
        """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, \
                viewport-fit=cover">
                <link rel="stylesheet" href="https://chatbot-frontend.prod.ai.2u.com/@latest/index.min.css" />
                <style type="text/css">
                    .intercom-lightweight-app-launcher {
                        display: none !important;
                    }
                </style>
                <style id="fit-graphics">
                    iframe {
                        width: 100% !important;
                        height: 100% !important;
                    }
                </style>
            </head>
            <body>
                <script>
                    window.XpertChatbotFrontend = {
                        xpertKey: '###XPERT_KEY###',
                        configurations: {
                            ###USE_CASE###
                            conversationScreen: {
                                liveChat: {
                                    enabled: \(xpertConfiguration.five9Enabled ? "true" : "false"),
                                    options: {
                                        allowPopout: false
                                    },
                                },
                            },
                        },
                    };
                </script>
                <script type="module" src="https://chatbot-frontend.prod.ai.2u.com/@latest/index.min.js"></script>
                <script type="text/javascript" async="" src="https://cdn.segment.com/analytics.js/v1/###SEGMENTKEY###/analytics.min.js"></script>
                <script>
                    var five9OpenButtonListenerAdded = false;
                    var xpertCloseButtonListenerAdded = false;
                    function f9CallbackFunc(event) {
                        try {
                            switch (event.type) {
                            case 'endChatConfirmed':
                                window.webkit.messageHandlers.###closeChat###.postMessage("###closeChat###");
                                break;
                            default:
                                break;
                        }
                        } catch (exception) {}
                    }
                    function checkFive9WidgetVisisbility() {
                        var widget = document.getElementById("five9LiveChatWidget");
                        var five9Button = document.getElementById("five9OpenChatButton"); 
                        if (widget != undefined && five9Button != undefined) {
                            if (widget.style["display"] == 'none') {
                                five9Button.click();
                            }
                        }
                    }
                    document.addEventListener(
                        "DOMSubtreeModified",
                        function(e) {
                            var container = document.getElementById("xpert-chatbot-container");
                            if (container != undefined) {
                                var button = container.getElementsByTagName("button")[0];
                                if (button != undefined && button.isClicked == undefined) {
                                    setTimeout(() => {
                                        window.webkit.messageHandlers.###openedChat###.postMessage("###openedChat###");
                                        button.click();
                                    }, 500);
                                    button.isClicked = true;
                                }
                            }
                            var xpertCloseButton = document.getElementsByClassName("xpert-chatbot-popup__header--btn-outline")[0];
                            if (xpertCloseButton != undefined && !xpertCloseButtonListenerAdded) {
                                xpertCloseButtonListenerAdded = true;
                                xpertCloseButton.addEventListener(
                                    "click",
                                    function(e) {
                                        window.webkit.messageHandlers.###closeChat###.postMessage("###closeChat###");
                                    },
                                    false
                                );
                            }
                            var floatingButton = document.getElementById("xpert_chatbot__floating-action-btn");
                            if (floatingButton != undefined) {
                                floatingButton.style["display"] = 'none';
                            }
                            var launchMessage = document.getElementsByClassName("xpert_chatbot__launch-button-message")[0];
                            if (launchMessage != undefined) {
                                launchMessage.style["display"] = 'none';
                            }
                            if (typeof Five9ChatSetOption === "function") { 
                                Five9ChatSetOption("callback", f9CallbackFunc);
                            }
                            var five9OpenButton = document.getElementsByClassName("xpert-chatbot-popup__live-chat--btn-outline")[0];
                            if (five9OpenButton != undefined && !five9OpenButtonListenerAdded) {
                                five9OpenButtonListenerAdded = true;
                                five9OpenButton.addEventListener(
                                    "click",
                                    function(e) {
                                        window.webkit.messageHandlers.###clickedFive9###.postMessage("###clickedFive9###");
                                        setTimeout(() => {
                                            checkFive9WidgetVisisbility();
                                        }, 1000);
                                    },
                                    false
                                );
                            }
                        },
                        false
                    );
                </script>
            </body>
        </html>
        """
            .replacingOccurrences(of: "###XPERT_KEY###", with: xpertConfiguration.xpertKey)
            .replacingOccurrences(of: "###USE_CASE###", with: xpertConfiguration.useCaseString)
            .replacingOccurrences(of: "###SEGMENTKEY###", with: xpertConfiguration.segmentKey)
            .replacingOccurrences(of: "###closeChat###", with: WKScriptEvent.closeChat.rawValue)
            .replacingOccurrences(of: "###openedChat###", with: WKScriptEvent.openedChat.rawValue)
            .replacingOccurrences(of: "###clickedFive9###", with: WKScriptEvent.clickedFive9.rawValue)
    }
    // swiftlint:enable line_length
    
}
