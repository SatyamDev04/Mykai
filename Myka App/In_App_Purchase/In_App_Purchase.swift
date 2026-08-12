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

    static let productsDidUpdateNotification = Notification.Name("IAPProductsDidUpdateNotification")
    static let productsDidFailNotification = Notification.Name("IAPProductsDidFailNotification")
    private static let pendingPurchaseProductKey = "IAPPendingPurchaseProductIdentifier"
    private static let pendingPurchaseUserKey = "IAPPendingPurchaseUserIdentifier"

    var viewController = UIViewController()

    static let shared = IAPManager()

    var VC = UIViewController()

    var products: [SKProduct] = []

    private let productIdentifiers: Set<ProductID> = [.yearlyPlan]
    private var productsRequest: SKProductsRequest?
    private var isFetchingProducts = false
    private var activePurchaseProductIdentifier: String?
    private var isRestoringPurchases = false

    var yearlyProduct: SKProduct? {
        products.first { $0.productIdentifier == ProductID.yearlyPlan.rawValue }
    }

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    // Fetch products from the App Store
    func fetchProducts() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.fetchProducts()
            }
            return
        }

        guard !isFetchingProducts else { return }
        isFetchingProducts = true
        let request = SKProductsRequest(productIdentifiers: Set(productIdentifiers.map { $0.rawValue }))
        productsRequest = request
        request.delegate = self
        request.start()
    }

    // SKProductsRequestDelegate method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.isFetchingProducts = false
            self.productsRequest = nil
            self.products = response.products

            if !response.invalidProductIdentifiers.isEmpty {
                print("Invalid StoreKit product identifiers: \(response.invalidProductIdentifiers)")
            }

            for product in self.products {
                if let discount = product.discounts.first {
                    print("Promotional offer available: \(discount)")

                    if discount.price == NSDecimalNumber(string: "0.00") {
                        print("This offer has a 0.00 price for the promotion.")
                    }
                } else {
                    print("No promotional offer available for product: \(product.productIdentifier)")
                }
            }

            NotificationCenter.default.post(name: IAPManager.productsDidUpdateNotification, object: nil)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isFetchingProducts = false
            self.productsRequest = nil
            print("StoreKit products request failed: \(error.localizedDescription)")
            NotificationCenter.default.post(name: IAPManager.productsDidFailNotification, object: nil)
        }
    }

    func localizedPrice(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "\(product.price)"
    }
}

extension IAPManager: SKPaymentTransactionObserver {

    // Call this method when the "Restore Purchases" button is tapped
        func restorePurchases() {
            guard Thread.isMainThread else {
                DispatchQueue.main.async {
                    self.restorePurchases()
                }
                return
            }

            isRestoringPurchases = true
            SKPaymentQueue.default().restoreCompletedTransactions()
        }

    func buyProduct(_ product: SKProduct, vc: UIViewController) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.buyProduct(product, vc: vc)
            }
            return
        }

        guard SKPaymentQueue.canMakePayments() else {
            print("User cannot make payments.")
            vc.hideIndicator()
            return
        }

        let payment = SKMutablePayment(product: product)

        payment.applicationUsername = "userId"+UserDetail.shared.getUserId()

        activePurchaseProductIdentifier = product.productIdentifier
        UserDefaults.standard.set(product.productIdentifier, forKey: IAPManager.pendingPurchaseProductKey)
        UserDefaults.standard.set(payment.applicationUsername, forKey: IAPManager.pendingPurchaseUserKey)
        self.VC = vc
        SKPaymentQueue.default().add(payment)
        vc.showIndicator(withTitle: "", and: "")
    }

    // SKPaymentTransactionObserver method to handle transaction updates
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    self.handleSuccessfulPurchase(transaction)

                case .failed:
                    self.VC.hideIndicator()
                    self.handleFailedPurchase(transaction)

                case .restored:
                    self.VC.hideIndicator()
                    self.handleRestoredPurchase(transaction)
                default:
                    break
                }
            }
        }
    }

    // Handle a successful purchase
    func handleSuccessfulPurchase(_ transaction: SKPaymentTransaction) {
        print("Purchase successful: \(transaction.payment.productIdentifier)")
        guard shouldSubmitReceipt(for: transaction) else {
            print("Skipping receipt submission for transaction that was not started by the current user.")
            SKPaymentQueue.default().finishTransaction(transaction)
            return
        }

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
                let data:[String: String] = [
                    "data": "Purchase successful",
                    "Receipt": receiptString,
                    "product_id": transaction.payment.productIdentifier,
                    "transaction_id": transaction.transactionIdentifier ?? ""
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil, userInfo: data)
          //      isSubscription_purchased = true
         //   }
        }
        activePurchaseProductIdentifier = nil
        clearPendingPurchase()
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    // Handle a failed purchase
    func handleFailedPurchase(_ transaction: SKPaymentTransaction) {
        let pendingProductIdentifier = UserDefaults.standard.string(forKey: IAPManager.pendingPurchaseProductKey)
        if transaction.payment.productIdentifier == activePurchaseProductIdentifier ||
            transaction.payment.productIdentifier == pendingProductIdentifier {
            activePurchaseProductIdentifier = nil
            clearPendingPurchase()
        }

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
        guard transaction.payment.productIdentifier == ProductID.yearlyPlan.rawValue else {
            SKPaymentQueue.default().finishTransaction(transaction)
            return
        }

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
            let data:[String: String] = [
                "data": "Purchase successful",
                "Receipt": receiptString,
                "product_id": transaction.payment.productIdentifier,
                "transaction_id": transaction.transactionIdentifier ?? ""
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseNotification"), object: nil, userInfo: data)
        }
            isRestoringPurchases = false
            SKPaymentQueue.default().finishTransaction(transaction)

    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.isRestoringPurchases = false
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            self.isRestoringPurchases = false
            self.VC.hideIndicator()
            print("Restore failed: \(error.localizedDescription)")
        }
    }

    private func shouldSubmitReceipt(for transaction: SKPaymentTransaction) -> Bool {
        guard transaction.payment.productIdentifier == ProductID.yearlyPlan.rawValue else {
            return false
        }

        if isRestoringPurchases {
            return true
        }

        let currentUserName = "userId" + UserDetail.shared.getUserId()
        let pendingProductIdentifier = activePurchaseProductIdentifier ??
            UserDefaults.standard.string(forKey: IAPManager.pendingPurchaseProductKey)
        let pendingUserName = UserDefaults.standard.string(forKey: IAPManager.pendingPurchaseUserKey)

        return transaction.payment.productIdentifier == pendingProductIdentifier &&
            transaction.payment.applicationUsername == currentUserName &&
            pendingUserName == currentUserName
    }

    private func clearPendingPurchase() {
        UserDefaults.standard.removeObject(forKey: IAPManager.pendingPurchaseProductKey)
        UserDefaults.standard.removeObject(forKey: IAPManager.pendingPurchaseUserKey)
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
