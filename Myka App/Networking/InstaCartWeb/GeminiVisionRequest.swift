//
//  GeminiVisionRequest.swift
//  My Kai
//
//  Created by YATIN  KALRA on 07/01/26.
//


import Foundation
import UIKit

// MARK: - Request Models

struct GeminiVisionRequest: Codable {
    let contents: [GeminiContent]
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

enum GeminiPart: Codable {
    case text(String)
    case inlineData(GeminiInlineData)

    enum CodingKeys: String, CodingKey {
        case text
        case inlineData
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .text(let text):
            try container.encode(text, forKey: .text)

        case .inlineData(let data):
            try container.encode(data, forKey: .inlineData)
        }
    }
}

struct GeminiInlineData: Codable {
    let mimeType: String
    let data: String
}

struct GeminiVisionResponse: Codable {
    let candidates: [GeminiCandidate]
}

struct GeminiCandidate: Codable {
    let content: GeminiContent
}


extension UIImage {
    func toBase64(compression: CGFloat = 0.7) -> String? {
        guard let data = self.jpegData(compressionQuality: compression) else {
            return nil
        }
        return data.base64EncodedString()
    }
}
