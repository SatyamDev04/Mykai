//
//  VisionAPIManager.swift
//  My-Kai
//
//  Created by YES IT Labs on 30/01/25.
//

import UIKit
 
// Data models for Vision API request and response
struct Feature: Codable {
    let type: String
    let maxResults: Int
}

struct Image: Codable {
    let content: String
}

struct Request: Codable {
    let image: Image
    let features: [Feature]
}

struct VisionRequest: Codable {
    let requests: [Request]
}

struct WebEntity: Codable {
    let description: String
}

struct WebDetection: Codable {
    let webEntities: [WebEntity]
}

struct VisionResponse: Codable {
    let responses: [Response]
}

struct Response: Codable {
    let webDetection: WebDetection?
}

 
