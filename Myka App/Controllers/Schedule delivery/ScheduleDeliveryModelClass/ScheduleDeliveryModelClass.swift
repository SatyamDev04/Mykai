//
//  ScheduleDeliveryModelClass.swift
//  My Kai
//
//  Created by YES IT Labs on 02/06/25.
//

import Foundation

struct ScheduleDeliveryModelClass: Codable {
    let code: Int?
    let success: Bool?
    let message: String?
    let data: ScheduleDeliveryModel?
}

// MARK: - DataClass
struct ScheduleDeliveryModel: Codable {
    let the1Hour, the3Hour: [Hour]?

     enum CodingKeys: String, CodingKey {
         case the1Hour = "1hour"
         case the3Hour = "3hour"
     }
 }

 // MARK: - Hour
 struct Hour: Codable {
     let time, offer: String?
     var selected: Bool?
 }
