//
//  OpenAIService.swift
//  OpenAIAssistent
//
//  Created by Dastan S on 15.04.2024.
//

import Foundation
import Alamofire

class OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    
    func send(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map { OpenAIChatMessage(role: $0.role, content: $0.content) }
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.apiKey)"
        ]
        
        let request = AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: headers)
        
        return try? await request.serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
    let model: String
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}

enum Constants {
    // Put here your private api key from openAI
    static var apiKey = "your private key"
}
