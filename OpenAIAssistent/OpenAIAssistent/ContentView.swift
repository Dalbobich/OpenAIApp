//
//  ContentView.swift
//  OpenAIAssistent
//
//  Created by Dastan S on 28.03.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.id) { message in
                    messageView(message: message)
                }
            }
            Divider()
            HStack {
                TextField("Enter", text: $viewModel.currentInput)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }
            }
        }
        .padding()
    }
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer() }
            Text(message.content)
                .padding()
                .background(message.role == .user ? .blue : .gray.opacity(0.2))
                .cornerRadius(8.0)
            if message.role == .assistant { Spacer() }
            
        }
    }
}

#Preview {
    ContentView()
}
