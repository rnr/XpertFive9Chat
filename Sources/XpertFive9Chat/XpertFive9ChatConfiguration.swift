//
//  XpertFive9ChatConfiguration.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 19/09/2024.
//

import Foundation

// Xpert
public struct XpertChatConfiguration {
    var xpertKey: String
    var useCase: String
    var segmentKey: String
    var baseURL: URL?
    var five9Enabled: Bool
    
    public init(xpertKey: String, useCase: String, segmentKey: String, baseURL: URL?, five9Enabled: Bool = true) {
        self.xpertKey = xpertKey
        self.useCase = useCase
        self.segmentKey = segmentKey
        self.baseURL = baseURL
        self.five9Enabled = five9Enabled
    }
    
    var useCaseString: String {
        if useCase.isEmpty {
            return ""
        } else {
            var returnString = """
            chatApi: {
                payloadParams: {
                    use_case: 
            """
            if useCase.starts(with: "[") {
                returnString.append(useCase)
            } else {
                returnString.append("'\(useCase)'")
            }
            returnString.append("""
                },
            },
            """
            )
            return returnString
        }
    }
}
