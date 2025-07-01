//
//  ApplePayHelper.swift
//  My Kai
//
//  Created by Sumit Kumar on 21/05/25.
//

import Foundation
import StripeApplePay
import PassKit

//MARK: - Applepay Constant
class Applepay : NSObject {
    static let country = "US"
    static let currency = "USD"
    static let merchantID = "merchant.com.getmykai.mykai"
}

protocol ApplePayHelperDelegate {
    func applePayDidComplete(isSuccess: Bool, error: String?)
}

class ApplePayHelper : NSObject{
  
    var totalAmount = ""
    var tipAmount = ""
    var subtotalAmount = ""
    var delegate : ApplePayHelperDelegate?
    
    
    func presentApplePay(onVC: UIViewController) {
        
        StripeAPI.defaultPublishableKey = "pk_test_51Qko2KEowij4RlG8Ehh3tKQVhxVJUMzAPIi0rTnsX77jwtz5F8LfHfSvS9d2PTg8G7I5NQ3x19JlqdMaAihRcXAn00MvY1CI0X"//Test
       
        let merchantIdentifier = Applepay.merchantID
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: Applepay.country, currency: Applepay.currency)
        
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (that is, "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "SubTotal", amount: NSDecimalNumber(string: subtotalAmount)),
            PKPaymentSummaryItem(label: "Tip", amount: NSDecimalNumber(string: tipAmount)),
            PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: totalAmount)),
        ]
        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
            // Present Apple Pay payment sheet
            applePayContext.presentApplePay()
          //  applePayContext.presentApplePay(on: onVC)
        } else {
            // There is a problem with your Apple Pay configuration
        }
    }
}
extension ApplePayHelper : ApplePayContextDelegate{
    
//    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
//        //get client secret key from backend with using API
//        let clientSecret = ""
//        completion(clientSecret, nil)
//    }
    
        func applePayContext(
            _ context: STPApplePayContext,
            didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod,
            paymentInformation: PKPayment,
            completion: @escaping STPIntentClientSecretCompletionBlock
        ) {
            fetchClientSecret { result in
                switch result {
                case .success(let clientSecret):
                    print("Fetched clientSecret: \(clientSecret)")
                    let input = clientSecret
                    if let piValue = input.components(separatedBy: "_secret").first {
                        print(piValue) // Output: pi_3RU0e5Eowij4RlG80uYZHkJX
                        PaymentIntent = piValue
                    }
                    completion(clientSecret, nil)
                case .failure(let error):
                    print("Error fetching clientSecret: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPApplePayContext.PaymentStatus, error: Error?) {
        switch status {
        case .success:
            print("Payment succeeded, show a receipt view")
            self.delegate?.applePayDidComplete(isSuccess: true, error: nil)
            break
        case .error:
            print("Payment failed, show the error")
            self.delegate?.applePayDidComplete(isSuccess: false, error: error?.localizedDescription)
            break
        case .userCancellation:
            print("User canceled the payment")
            self.delegate?.applePayDidComplete(isSuccess: false, error: nil)
            break
        }
    }
    
        func fetchClientSecret(completion: @escaping (Result<String, Error>) -> Void) {
            let token = UserDetail.shared.getTokenWith()
    
        //    showIndicator(withTitle: "", and: "")
    
            let loginURL = baseURL.baseURL + appEndPoints.charge_apple
            print(loginURL, "loginURL")
    
            guard let url = URL(string: loginURL) else {
              //  hideIndicator()
                completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "The provided URL is invalid"])))
                return
            }
    
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
     
            // Add the necessary request body data
         
              
    
            let body: [String: Any] = [
                "subtotal": subtotalAmount,
                "tip": tipAmount,
                "total": totalAmount
            ]
    
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
               // hideIndicator()
                completion(.failure(error))
                return
            }
    
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              //  self.hideIndicator()
    
                if let error = error {
                    completion(.failure(error))
                    return
                }
    
                guard let data = data,
                      let response = response as? HTTPURLResponse else {
                    let serverError = NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "No response or data received from server"])
                    completion(.failure(serverError))
                    return
                }
    
    
                if response.statusCode == 200 {
                    do {
                        // Parse JSON response
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let dictData = json["data"] as? String {
    
                            // Extract client_secret from data
                            let clientSecret = dictData
    
                            if !clientSecret.isEmpty {
                                DispatchQueue.main.async {
                                    //self.SecreteKey = clientSecret
                                    completion(.success(clientSecret))
                                }
                            } else {
                                let parseError = NSError(domain: "Parsing Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Client secret not found in server response"])
                                completion(.failure(parseError))
                            }
                        } else {
                            let parseError = NSError(domain: "Parsing Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse server response"])
                            completion(.failure(parseError))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let serverError = NSError(domain: "Server Error", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with status code \(response.statusCode)"])
                    completion(.failure(serverError))
                }
            }
    
            task.resume()
        }
}

var PaymentIntent = ""
