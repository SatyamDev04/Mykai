//
//  In_App_Purchase.swift
//  Roam
//
//  Created by YES IT Labs on 08/07/24.
//
  
import StoreKit
import SwiftUI
import UIKit
import SwiftyJSON

class IAPManager: NSObject, SKProductsRequestDelegate {
    
    var viewController = UIViewController()
    
    static let shared = IAPManager()
    
    var VC = UIViewController()
    
    var products: [SKProduct] = []
    
    let productIdentifiers: Set<ProductID> = [.WeeklyPlan, .MonthlyPlan, .yearlyPlan]
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // Fetch products from the App Store
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(productIdentifiers.map { $0.rawValue }))
        request.delegate = self
        request.start()
    }
    
    // SKProductsRequestDelegate method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in products {
            if let discount = product.discounts.first {
                print("Promotional offer available: \(discount)")
                
                if discount.price == NSDecimalNumber(string: "0.00") {
                    print("This offer has a 0.00 price for the promotion.")
                }
            } else {
                print("No promotional offer available for product: \(product.productIdentifier)")
            }
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    // Call this method when the "Restore Purchases" button is tapped
        func restorePurchases() {
            SKPaymentQueue.default().restoreCompletedTransactions()
        }

    func buyProduct(_ product: SKProduct, vc: UIViewController) {
        guard SKPaymentQueue.canMakePayments() else {
            print("User cannot make payments.")
            return
        }
        
        let payment = SKMutablePayment(product: product)
        
        payment.applicationUsername = "userId"+UserDetail.shared.getUserId()
        
        SKPaymentQueue.default().add(payment)
        vc.showIndicator(withTitle: "", and: "")
        self.VC = vc
    }
    
    // SKPaymentTransactionObserver method to handle transaction updates
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handleSuccessfulPurchase(transaction)
                
            case .failed:
                viewController.hideIndicator()
                viewController.hideIndicator()
                handleFailedPurchase(transaction)
                
            case .restored:
                viewController.hideIndicator()
                viewController.hideIndicator()
                //handleRestoredPurchase(transaction)
                handleSuccessfulPurchase(transaction)
            default:
                break
            }
        }
    }
    
    // Handle a successful purchase
    func handleSuccessfulPurchase(_ transaction: SKPaymentTransaction) {
        print("Purchase successful: \(transaction.payment.productIdentifier)")
        
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            let receiptString = receiptData.base64EncodedString()
            print("Receipt data: \(receiptString)")
            
            let transactionDict: [String: Any] = [
                "transaction_id": transaction.transactionIdentifier ?? "",
                "product_id": transaction.payment.productIdentifier,
                "transaction_date": transaction.transactionDate?.description ?? "",
                "receipt_data": receiptString
            ]
            
            // Notify with receipt data
           // if isSubscription_purchased == false{
                let data:[String: String] = ["data": "Purchase successful", "Receipt": receiptString]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
          //      isSubscription_purchased = true
         //   }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // Handle a failed purchase
    func handleFailedPurchase(_ transaction: SKPaymentTransaction) {
     
        if let error = transaction.error as? SKError {
            if error.code == .unknown {
                print("User not eligible for the promotional offer: \(error.localizedDescription)")
                VC.hideIndicator()
            } else {
                print("Transaction failed with error: \(error.localizedDescription)")
                VC.hideIndicator()
            }
        } else {
            print("Transaction failed: \(transaction.error?.localizedDescription ?? "Unknown error")")
            VC.hideIndicator()
        }
        
        // Notify failure
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil, userInfo: ["data": "Purchase failed"])
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // Handle a restored purchase
    func handleRestoredPurchase(_ transaction: SKPaymentTransaction) {
        print("Transaction restored: \(transaction.payment.productIdentifier)")
          
        print("Purchase successful: \(transaction.payment.productIdentifier)")
        
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            let receiptString = receiptData.base64EncodedString()
            print("Receipt data: \(receiptString)")
            
            let transactionDict: [String: Any] = [
                "transaction_id": transaction.transactionIdentifier ?? "",
                "product_id": transaction.payment.productIdentifier,
                "transaction_date": transaction.transactionDate?.description ?? "",
                "receipt_data": receiptString
            ]
            
            // Notify with receipt data
            // if isSubscription_purchased == false{
            let data:[String: String] = ["data": "Purchase successful", "Receipt": receiptString]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: data)
        }
            SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func fetchReceipt(completion: @escaping (String?) -> Void) {
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            let receiptString = receiptData.base64EncodedString(options: [])
            completion(receiptString)
        } else {
            let request = SKReceiptRefreshRequest()
            request.delegate = self
            request.start()
        }
    }
 
}

// Utility struct to handle Apple receipt
struct AppleReceipt {
    static var receipt: String? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        if FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                return receiptData.base64EncodedString(options: [])
            } catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}
