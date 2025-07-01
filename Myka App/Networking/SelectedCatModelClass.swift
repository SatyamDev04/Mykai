//
//  SelectedCatModelClass.swift
//  Roam
//
//  Created by YES IT Labs on 03/11/23.
//

import Foundation

class SelectedCatModelClass: NSObject {
 
    var addonsID : Int?
    var addons_price : String = ""
 
     class func getSelectedAddonsDetails(responseArray : [[String : Any]])-> [SelectedCatModelClass]{
         
         var SelectedAddonsDetails = [SelectedCatModelClass]()
         
         
         for tempDict in responseArray{
             
             let tempobj = SelectedCatModelClass()
             
             tempobj.addonsID = tempDict.validatedValue("addons", expected: Int() as AnyObject) as? Int
             tempobj.addons_price = tempDict.validatedValue("addons_price", expected: "" as AnyObject) as? String ?? ""
             
             
             SelectedAddonsDetails.append(tempobj)
             
         }
         
         return SelectedAddonsDetails
     }
}
