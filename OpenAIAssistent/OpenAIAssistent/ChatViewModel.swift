//
//  ChatViewModel.swift
//  OpenAIAssistent
//
//  Created by Dastan S on 15.04.2024.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        
        private let service = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await service.send(messages: messages)
                guard let recievedOpenAIMessages = response?.choices.first?.message else {
                    print("!!! error")
                    return
                }
                let recievedMessges = Message(id: UUID(), role: recievedOpenAIMessages.role, content: recievedOpenAIMessages.content, createAt: Date())
                
                await MainActor.run {
                    messages.append(recievedMessges)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
