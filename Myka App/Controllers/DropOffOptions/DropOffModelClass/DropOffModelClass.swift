//
//  DropOffModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 25/04/25.
//

import Foundation

struct DropOffModelClass: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var data: [DropOffModelData]?
    var instruction: String?
    
    enum CodingKeys: String, CodingKey {
            case instruction = "description"
            case code, success, message, data
        }
}

// MARK: - Datum
struct DropOffModelData: Codable {
    var id: Int?
    var name: String?
    var type, status: Int?
}
