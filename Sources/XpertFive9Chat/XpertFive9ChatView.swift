//
//  XpertFive9ChatView.swift
//  XpertFive9Chat
//
//  Created by Anton Yarmolenka on 19/09/2024.
//

import SwiftUI

public struct XpertFive9ChatView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var model: XpertFive9ChatViewModel
    @State var closeChat: Bool = false
    @State var chatIsOpened: Bool = false
    @State var clickedFive9: Bool = false
    
    public init(xpertConfig: XpertChatConfiguration) {
        self._model = .init(wrappedValue: XpertFive9ChatViewModel(xpertConfig: xpertConfig))
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                Spacer()
            }
            .frame(height: 30)
            .padding(0)
            ZStack {
                XpertFive9HTMLWebViewRepresentable(
                    html: model.xpertHTML,
                    baseURL: nil,
                    closeChat: $closeChat,
                    openedChat: $chatIsOpened,
                    clickedFive9: $clickedFive9
                )
                .ignoresSafeArea(.keyboard)
                ProgressView()
                    .opacity(clickedFive9 || chatIsOpened ? 0 : 1)
                    .tint(.gray)
            }
        }
        .onChange(of: closeChat) { newValue in
            if newValue {
                dismiss()
                closeChat = false
            }
        }
    }
}

#if DEBUG
struct XpertFive9ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let xpertConfig = XpertChatConfiguration(xpertKey: "", useCase: "", segmentKey: "")
        XpertFive9ChatView(xpertConfig: xpertConfig)
    }
}
#endif
