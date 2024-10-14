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

// Five9
public struct Five9FormData {
    var fields: [Five9FormFieldType]?
    var firstName: String?
    var lastName: String?
    var name: String?
    var email: String?
    var emailLabel: String?
    var questionLabel: String?
    var statictextLabel: String?
    var dropDownOptions: [String]?
    var dropDownLabel: String?
    
    public init(
        fields: [Five9FormFieldType]? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        name: String? = nil,
        email: String? = nil,
        emailLabel: String? = nil,
        questionLabel: String? = nil,
        statictextLabel: String? = nil,
        dropDownOptions: [String]? = nil,
        dropDownLabel: String? = nil
    ) {
        self.fields = fields
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.emailLabel = emailLabel
        if name == nil {
            if let firstName, let lastName {
                self.name = "\(firstName) \(lastName)"
            }
        } else {
            self.name = name
        }
        self.questionLabel = questionLabel
        self.statictextLabel = statictextLabel
        self.dropDownOptions = dropDownOptions
        self.dropDownLabel = dropDownLabel
    }
}

public enum Five9FormFieldType: String, Codable {
    case contactName = "contact.name"
    case contactEmail = "contact.email"
    case contactFirstName = "contact.firstname"
    case contactLastName = "contact.lastname"
    case question
    case staticText = "static text"
    case dropDown = "drop down"
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try Five9FormFieldType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
    
}

public struct Five9FormConfiguration {
    var formData: Five9FormData?
    
    public init(formData: Five9FormData? = nil) {
        self.formData = formData
    }
    
    public var formDataString: String {
        guard let fields = formData?.fields, fields.count > 0 else { return "" }
        var returnString: String = ""
        returnString += "formData: ["
        for field in fields {
            returnString += stringForFieldType(field)
        }
        returnString += "]"
        return returnString
            .replacingOccurrences(of: "###NAME###", with: formData?.name ?? "")
            .replacingOccurrences(of: "###EMAIL###", with: formData?.email ?? "")
            .replacingOccurrences(of: "###FIRSTNAME###", with: formData?.firstName ?? "")
            .replacingOccurrences(of: "###LASTNAME###", with: formData?.lastName ?? "")
    }
}

extension Five9FormConfiguration {
    private func stringForFieldType(_ fieldType: Five9FormFieldType) -> String {
        var returnString: String = ""
        if fieldType != .unknown {
            returnString += """
            {
                "type": "hidden",
                "formType": "both",
                "required": false
            },
            """
        }
        switch fieldType {
        case .contactName:
            returnString += """
            {
                "label": "Name",
                "cav": "contact.name",
                "formType": "both",
                "type": "text",
                "required": true,
                "readOnly": false,
                "value": "###NAME###"
            },
            """
        case .contactEmail:
            returnString += """
            {
                "label": "\(formData?.emailLabel ?? "Email")",
                "cav": "contact.email",
                "formType": "both",
                "type": "email",
                "required": true,
                "value": "###EMAIL###"
            },
            """
        case .contactFirstName:
            returnString +=  """
            {
                "label": "First Name",
                "cav": "contact.firstName",
                "formType": "both",
                "type": "text",
                "required": true,
                "readOnly": false,
                "value": "###FIRSTNAME###"
            },
            """
        case .contactLastName:
            returnString +=  """
            {
                "label": "Last Name",
                "cav": "contact.lastName",
                "formType": "both",
                "type": "text",
                "required": true,
                "readOnly": false,
                "value": "###LASTNAME###"
            },
            """
        case .question:
            returnString +=  """
            {
                "label": "\(formData?.questionLabel ?? "Question")",
                "cav": "Question",
                "formType": "both",
                "type": "textarea",
                "required": true,
                "readOnly": false
            },
            """
        case .staticText:
            returnString +=  """
            {
                "type": "static text",
                "formType": "both",
                "required": false,
                "label": '\(formData?.statictextLabel ?? "")'
            },
            """
        case .dropDown:
            returnString += """
            {
                "type": "select",
                "formType": "both",
                "required": true,
                "label": "\(formData?.dropDownLabel ?? "Subject")",
                "cav": "Drop Down",
                "options": [
            """
            for option in formData?.dropDownOptions ?? [] {
                returnString += """
                {
                    "label": "\(option)",
                    "value": ""
                },
                """
            }
            returnString += """
                ]
            },
            """
        case .unknown:
            break
        }
        return returnString
    }
}
