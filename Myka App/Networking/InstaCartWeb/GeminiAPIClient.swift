//
//  GeminiAPIClient.swift
//  My Kai
//
//  Created by YATIN  KALRA on 07/01/26.
//

import UIKit

final class GeminiAPIClient {

    static let shared = GeminiAPIClient()
    private init() {}

    private let baseURL = "https://generativelanguage.googleapis.com/"
    
    func sendImageWithPrompt(
        apiKey: String,
        image: UIImage,
        prompt: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        guard let base64Image = image.toBase64() else {
            completion(.failure(NSError(domain: "ImageConversionFailed", code: -1)))
            return
        }

        let body: [String: Any] = [
                    "contents": [
                        [
                            "parts": [
                                ["text": prompt],
                                [ "inlineData": [
                                        "mimeType": "image/jpeg",
                                        "data": base64Image
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

         let endpoint =
           "v1beta/models/gemini-2.5-flash:generateContent"
        guard let url = URL(string: baseURL + endpoint + "?key=\(apiKey)") else {
                 return
             }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

               print("➡️ URL:", request.url?.absoluteString ?? "")
               print("➡️ BODY:", String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }

            print("⬅️ Gemini Vision Response")
            print(String(data: data, encoding: .utf8) ?? "")

            do {
                
                switch self.extractDetectedPrices(from: data) {
                  case .success(let prices):
                      print("Detected Prices:", prices)
                     
                  let sum = prices.reduce(0, +)
                    completion(.success("\(sum)"))
                  case .failure(let error):
                      print("Decode Error:", error.localizedDescription)
                  }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                    
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -1)))
                }
            } 

        }.resume()
    }
    
    func extractDetectedPrices(from data: Data) -> Result<[Double], Error> {
        do {
          
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            guard
                let candidates = json?["candidates"] as? [[String: Any]],
                let content = candidates.first?["content"] as? [String: Any],
                let parts = content["parts"] as? [[String: Any]],
                let text = parts.first?["text"] as? String
            else {
                return .failure(NSError(domain: "GeminiParseError", code: -1))
            }

            // Step 2: Convert inner JSON string → Data
            guard let innerData = text.data(using: .utf8) else {
                return .failure(NSError(domain: "InnerJSONError", code: -2))
            }

            // Step 3: Decode inner JSON
            let decoded = try JSONDecoder().decode(PriceDetectionResult.self, from: innerData)

            return .success(decoded.detected_prices)

        } catch {
            return .failure(error)
        }
    }
}
struct PriceDetectionResult: Codable {
    let detected_prices: [Double]
    let final_total: Double?
    let confidence: String
}
