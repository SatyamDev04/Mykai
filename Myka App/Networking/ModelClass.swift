//
//  ModelClass.swift
//  Stadio
//
//  Created by YATIN  KALRA on 9/28/22.
//

import Foundation
import SwiftyJSON
import GoogleSignIn

class ModelClass: NSObject {
    
    static let shared = ModelClass()
    private override init() { }
    
    
    //MARK:- Intrest. screen Data:-
    
    
    var id : Int?
    var name : String = ""
    var selected : Bool = false
    
    class func getBodyGoalsDetails(responseArray : [[String : Any]])-> [ModelClass] {
        
        var BodyGoalsDetails = [ModelClass]()
        for tempDict in responseArray{
            let tempobj = ModelClass()
            
            
            tempobj.id = tempDict.validatedValue("id", expected: Int() as AnyObject) as? Int
            tempobj.name = tempDict.validatedValue("name", expected: "" as AnyObject) as? String ?? ""
            tempobj.selected = tempDict.validatedValue("selected", expected: Bool() as AnyObject) as? Bool ?? Bool()
            
            BodyGoalsDetails.append(tempobj)
            
        }
        return BodyGoalsDetails
    }
    
    
    // States Model.
//    var id : Int?
//    var name: String = ""
    var iso2: String = ""
//
 
   class func Get_arr_State_Details(responseArray : [[String : Any]])-> [ModelClass] {
       
       var arr_State_Details = [ModelClass]()
       for tempDict in responseArray{
           let tempobj = ModelClass()
           
           tempobj.id = tempDict.validatedValue("id", expected: Int() as AnyObject) as? Int
         
           tempobj.name = tempDict.validatedValue("name", expected: "" as AnyObject) as! String
           tempobj.iso2 = tempDict.validatedValue("iso2", expected: "" as AnyObject) as! String
           //
           arr_State_Details.append(tempobj)
           
       }
       return arr_State_Details
   }
    //Cities Model.
    //    var id : Int?
    //    var name: String = ""
  
    class func Get_arr_City_Details(responseArray : [[String : Any]])-> [ModelClass] {
        
        var arr_City_Details = [ModelClass]()
        for tempDict in responseArray{
            let tempobj = ModelClass()
            
            tempobj.id = tempDict.validatedValue("id", expected: Int() as AnyObject) as? Int
          
            tempobj.name = tempDict.validatedValue("name", expected: "" as AnyObject) as! String
            //
            arr_City_Details.append(tempobj)
            
        }
        return arr_City_Details
    }
 

    // Get_Saved_Cards
       var brand : String = ""
       var exp_month : Int?
       var exp_year : Int?
       var last4 : String = ""
       var card_id : String = ""
    //   var name : String = ""
       var customer_id : String = ""
       
   
       class func Get_Saved_CardsListtDetails(responseArray : [[String : Any]])-> [ModelClass] {
           
           var Saved_CardsDetails = [ModelClass]()
           for tempDict in responseArray{
               let tempobj = ModelClass()
               
               tempobj.card_id = tempDict.validatedValue("card_id", expected: "" as AnyObject) as! String
               tempobj.brand = tempDict.validatedValue("brand", expected: "" as AnyObject) as! String
               tempobj.exp_month = tempDict.validatedValue("exp_month", expected: Int() as AnyObject) as? Int
               tempobj.exp_year = tempDict.validatedValue("exp_year", expected: Int() as AnyObject) as? Int
               tempobj.last4 = tempDict.validatedValue("last4", expected: "" as AnyObject) as! String
               
               tempobj.name = tempDict.validatedValue("name", expected: "" as AnyObject) as! String
               tempobj.customer_id = tempDict.validatedValue("customer_id", expected: "" as AnyObject) as! String
                
               Saved_CardsDetails.append(tempobj)
               
           }
           return Saved_CardsDetails
       }
 
//    // Get_Saved_Bank
    
       var ids : String = ""
       var account: String = ""
       var account_holder_name : String = ""
       var bank_name : String = ""
    //   var last4 : String = ""
       var routing_number : String = ""
       var currency : String = ""
       var verification_status : Bool = false
    
       class func Get_Saved_BankListtDetails(responseArray : [[String : Any]])-> [ModelClass] {
           
           var Saved_BankDetails = [ModelClass]()
           for tempDict in responseArray{
               let tempobj = ModelClass()
                
               tempobj.verification_status = tempDict.validatedValue("verification_status", expected: Bool() as AnyObject) as? Bool ?? Bool()
               
               let bankdetail = tempDict.validatedValue("bank_account", expected: [[:]] as AnyObject) as! [[String:Any]]
               
               for temp in bankdetail {
                   let ter = ModelClass()
 
                   tempobj.ids = temp.validatedValue("id", expected: "" as AnyObject) as! String
                   tempobj.account_holder_name = temp.validatedValue("account_holder_name", expected: "" as AnyObject) as! String
                   tempobj.bank_name = temp.validatedValue("bank_name", expected: "" as AnyObject) as! String
                   tempobj.last4 = temp.validatedValue("last4", expected: "" as AnyObject) as! String
                   tempobj.routing_number = temp.validatedValue("routing_number", expected: "" as AnyObject) as! String
                   tempobj.currency = temp.validatedValue("currency", expected: "" as AnyObject) as! String
                   tempobj.account = temp.validatedValue("account", expected: "" as AnyObject) as! String
                   
               }
                 
               Saved_BankDetails.append(tempobj)
               
           }
           return Saved_BankDetails
       }
    
 
}
 
let signInConfig = GIDConfiguration(clientID: "856670496660-qsailjit03lsaeen7v1e6l769no55o93.apps.googleusercontent.com")
  
