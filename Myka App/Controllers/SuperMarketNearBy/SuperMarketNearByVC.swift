//
//  SuperMarketNearByVC.swift
//  Myka App
//
//  Created by YES IT Labs on 16/12/24.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SDWebImage
import BackgroundRemoval
import SwiftUI
 
class SuperMarketNearByVC: UIViewController {
    
    @IBOutlet weak var DelivaryLbl: UILabel!
    @IBOutlet weak var ClickNcollectLbl: UILabel!
    
    @IBOutlet weak var DelivaryBtnO: UIButton!
    @IBOutlet weak var ClickNcollectBtnO: UIButton!
    
    @IBOutlet weak var CollV: UICollectionView!
    
    @IBOutlet weak var MapView: GMSMapView!
    
    
    var gmsAddress: GMSAddress?
    var zoomCamera : GMSCameraPosition?
    let marker = GMSMarker()
    private let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var currentLat : String = ""
    var currentLong : String = ""
    
    var SuperMarketArr = [MarketModel]()
    
    var selectedMarker: GMSMarker?
    var infoWindow: UIView?
    
    var BackAction:()->() = {}
    
    var currentPage = 1
    var hasReachedEnd = false
    var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.MapView.layer.cornerRadius = 10
        self.MapView.layer.masksToBounds = true
        
        CollV.register(UINib(nibName: "SupermarketCollVCell", bundle: nil), forCellWithReuseIdentifier: "SupermarketCollVCell")
        CollV.delegate = self
        CollV.dataSource = self
        

        self.DelivaryLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.ClickNcollectLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.DelivaryLbl.textColor = UIColor.white
        self.ClickNcollectLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
       
        self.DelivaryLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.ClickNcollectLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
        self.DelivaryBtnO.isSelected = true
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.distanceFilter = 5
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        
        // Set the map's settings
        MapView.settings.myLocationButton = false // Hide the current location button
        MapView.isMyLocationEnabled = false // This disables the user's location dot
        
        self.getSuperMarketData()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DelivaryBtn(_ sender: UIButton) {
        self.DelivaryLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        self.ClickNcollectLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        
        self.DelivaryLbl.textColor = UIColor.white
        self.ClickNcollectLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        
        self.DelivaryLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.ClickNcollectLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
         
        self.DelivaryBtnO.isSelected = true
        self.ClickNcollectBtnO.isSelected = false
         
        CollV.reloadData()
    }
    
    
    
    @IBAction func ClickNcollectBtn(_ sender: UIButton) {
        self.DelivaryLbl.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 240/255, alpha: 1)
        self.ClickNcollectLbl.backgroundColor = UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1)
        
        self.DelivaryLbl.textColor = UIColor.init(red: 60/255, green: 69/255, blue: 65/255, alpha: 1)
        self.ClickNcollectLbl.textColor = UIColor.white
        
        self.ClickNcollectLbl.font = UIFont.init(name: "Poppins Medium", size: 16)
        self.DelivaryLbl.font = UIFont.init(name: "Poppins Regular", size: 16)
        
        self.DelivaryBtnO.isSelected = false
        self.ClickNcollectBtnO.isSelected = true
        
//        CollV.register(UINib(nibName: "SupermarketCollVCell", bundle: nil), forCellWithReuseIdentifier: "SupermarketCollVCell")
//        CollV.delegate = self
//        CollV.dataSource = self
        CollV.reloadData()
    }

}

extension SuperMarketNearByVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return SuperMarketArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.DelivaryBtnO.isSelected{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupermarketCollVCell", for: indexPath) as! SupermarketCollVCell//MarketCollVCell
            
            if SuperMarketArr[indexPath.item].isOpen == true{
                cell.ClosedBgV.isHidden = true
            }else{
                cell.ClosedBgV.isHidden = false
                let val = SuperMarketArr[indexPath.item].operationalHours ?? nil
               
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let CurrentDay = dateFormatter.string(from: today)
                 
                var todayHours: String?
                
                switch CurrentDay {
                case "Sunday":
                    todayHours = val?.sunday
                case "Monday":
                    todayHours = val?.monday
                case "Tuesday":
                    todayHours = val?.tuesday
                case "Wednesday":
                    todayHours = val?.wednesday
                case "Thursday":
                    todayHours = val?.thursday
                case "Friday":
                    todayHours = val?.friday
                case "Saturday":
                    todayHours = val?.saturday
                default:
                    todayHours = nil
                }
                 
                
                
                if let hours = todayHours {
                       print("Today's operational hours: \(hours)")
                    let firstPart = hours.components(separatedBy: " - ").first ?? ""
                       cell.ClosedLbl.text = "Closed now\nOpen at \(firstPart)"
                   } else {
                       print("No operational hours found for \(CurrentDay).")
                   }
            }
            
            let priceValue = SuperMarketArr[indexPath.item].total ?? 0
            let formattedPrice: String
            if priceValue == floor(priceValue) {
                // If the value is a whole number, show it as an integer
                formattedPrice = String(format: "%.0f", priceValue)
            } else {
                // If the value has decimals, round it to two decimal places
                formattedPrice = String(format: "%.2f", priceValue)
            }
            
            cell.priceLbl.text = "$\(formattedPrice)"
            
            let Imgurl = SuperMarketArr[indexPath.item].image ?? ""
            let URL = URL(string: Imgurl)
            
            cell.Img.sd_setImage(with: URL, placeholderImage: UIImage(named: "No_Image"))
          //  cell.Namelbl.text = SuperMarketArr[indexPath.item].storeName
            
            let Dist = SuperMarketArr[indexPath.item].distance ?? ""
            let FDist = formatQuantity(Dist)
            cell.Mileslbl.text = "\(FDist) miles"
            
            if SuperMarketArr[indexPath.item].isSlected == 1 {
                cell.BgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
                cell.BgV.borderWidth = 2
            }else{
                cell.BgV.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.BgV.borderWidth = 0
            }
            
            let isMissing = SuperMarketArr[indexPath.item].missing ?? 0 // if 0 all item avaialble
            if isMissing == 0{
                cell.Namelbl.text = "ALL ITEMS"
                cell.Namelbl.textColor = #colorLiteral(red: 0.02352941176, green: 0.7568627451, blue: 0.4117647059, alpha: 1)
            }else{
                cell.Namelbl.text = "\(isMissing) ITEMS\nMISSING"
                cell.Namelbl.textColor = #colorLiteral(red: 1, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
            }
        
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupermarketCollVCell", for: indexPath) as! SupermarketCollVCell
            
            cell.PriceLblH.constant = 0
            cell.PriceLblB.constant = 0
            
            let Imgurl = SuperMarketArr[indexPath.item].image ?? ""
            let URL = URL(string: Imgurl)
            
            cell.Img.sd_setImage(with: URL, placeholderImage: UIImage(named: "No_Image"))
            cell.Namelbl.text = SuperMarketArr[indexPath.item].storeName
            
            let Dist = SuperMarketArr[indexPath.item].distance ?? ""
            let FDist = formatQuantity(Dist)
            cell.Mileslbl.text = "\(FDist) miles"
            
            if SuperMarketArr[indexPath.item].isSlected == 1 {
                cell.BgV.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.2705882353, alpha: 1)
                cell.BgV.borderWidth = 2
            }else{
                cell.BgV.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.BgV.borderWidth = 0
            }
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for indx in 0..<SuperMarketArr.count{
            SuperMarketArr[indx].isSlected = 0
        }
 
        SuperMarketArr[indexPath.item].isSlected = 1
   
        self.CollV.reloadData()
        
        self.Api_To_UpdateSuperMarket()
    }
    
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  if self.DelivaryBtnO.isSelected {
            return CGSize(width: collectionView.frame.width/3 - 5, height: 185)
//        }else{
//            let padding: CGFloat = 3
//            let itemsPerRow: CGFloat = 3
//            let totalPadding = padding * (itemsPerRow + 1)
//            let availableWidth = collectionView.frame.size.width - totalPadding
//            let itemWidth = availableWidth / itemsPerRow
//            
//            return CGSize(width: itemWidth, height: itemWidth * 1.25)
//        }
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 3
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
     }
    
    // UIScrollViewDelegate method for detecting scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Detect scrolling direction
        let isScrollingDown = offsetY > lastContentOffset
        lastContentOffset = offsetY

        // Define a buffer to detect nearing the bottom
        let buffer: CGFloat = 0.0 // Adjust as needed

        if isScrollingDown {
            // Reached near the bottom
            if offsetY >= contentHeight - frameHeight - buffer && !hasReachedEnd {
                hasReachedEnd = true
                print("Reached bottom")
                self.getSuperMarketData()
            }
        } else {
            // Detect scrolling out of bottom
            if hasReachedEnd && offsetY < contentHeight - frameHeight - buffer {
                hasReachedEnd = false
                print("Scrolled out of bottom")
                // Add actions for scrolling out of bottom if needed
            }
        }
    }
 
 
       }

extension SuperMarketNearByVC {
    
    func getSuperMarketData() {
        var params:JSONDictionary = [:]
        
        params["latitude"] = AppLocation.lat
        params["longitude"] = AppLocation.long
        params["page"] = self.currentPage
        
        showIndicator(withTitle: "", and: "")
        
         
        let loginURL = baseURL.baseURL + appEndPoints.super_markets
        print(params,"Params")
        print(loginURL,"loginURL")
      
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            let data = try! json.rawData()
            do{
                
                let d = try JSONDecoder().decode(MarketModelClass.self, from: data)
                if d.success == true {
                    
                    let allData = d.data
//                    self.SuperMarketArr = allData ?? []
                    
                    self.SuperMarketArr.append(contentsOf: allData ?? [])
                     
                    self.SuperMarketArr = self.SuperMarketArr.filter { store in
                        store.total != nil && store.total != 0.0
                    }
                    
                    self.CollV.reloadData()
                    
                   
                    if self.hasReachedEnd == true{
                        self.MapView.clear()
                    }
                    
                    self.hasReachedEnd = false
                    
                    // Add custom markers
                    for indx in 0..<self.SuperMarketArr.count {
                        let name = self.SuperMarketArr[indx].storeName ?? ""
                        let latitude = self.SuperMarketArr[indx].address?.latitude ?? 0.0
                        let longitude = self.SuperMarketArr[indx].address?.longitude ?? 0.0
                            
                        let imageURL = self.SuperMarketArr[indx].image ?? ""
                        self.addCustomMarker(name: name, latitude: latitude, longitude: longitude, imageURL: imageURL, index: indx)
                        }
                }else{
                    
                    let msg = d.message ?? ""
                    self.showToast(msg)
                }
            }catch{
                
                print(error)
            }
        })
    }
    
    func Api_To_UpdateSuperMarket(){
        var params = [String: Any]()
        
        var selectedStoreID  = ""
        var selectedStoreName  = ""
       for itm in SuperMarketArr {
           if itm.isSlected == 1 {
               selectedStoreID  = itm.storeUUID ?? ""
               selectedStoreName = itm.storeName ?? ""
           }
        }
         
        params["store_id"] = selectedStoreID
        params["store_name"] = selectedStoreName
        
        showIndicator(withTitle: "", and: "")
        
        let loginURL = baseURL.baseURL + appEndPoints.select_store_product
        print(params,"Params")
        print(loginURL,"loginURL")
        
        WebService.shared.postServiceURLEncoding(loginURL, VC: self, andParameter: params, withCompletion: { (json, statusCode) in
            
            self.hideIndicator()
            
            guard let dictData = json.dictionaryObject else{
                return
            }
            
            if dictData["success"] as? Bool == true{
                self.BackAction()
                self.navigationController?.popViewController(animated: true)
            }else{
                let responseMessage = dictData["message"] as? String ?? ""
                self.showToast(responseMessage)
            }
        })
    }
    
    
    func addCustomMarker(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, imageURL: String, index: Int) {
        // Placeholder sizes
        let maxLabelWidth: CGFloat = 200
        let markerImageWidth: CGFloat = 30
        let markerImageHeight: CGFloat = 30

        // Create the label
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Montserrat-Bold", size: 24.0)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping

        // Predefined color palette
        let colors: [UIColor] = [
            UIColor(red: 0.85, green: 0.1, blue: 0.1, alpha: 1.0),
            UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0),
            UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.58, green: 0.0, blue: 0.65, alpha: 1.0),
            UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1.0),
            UIColor(red: 0.65, green: 0.16, blue: 0.16, alpha: 1.0),
            UIColor(red: 0.8, green: 0.0, blue: 0.8, alpha: 1.0),
            UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
        ]

        // Static variable for color index
        struct Static {
            static var lastColorIndex: Int? = nil
        }

        var newColorIndex: Int
        repeat {
            newColorIndex = Int.random(in: 0..<colors.count)
        } while newColorIndex == Static.lastColorIndex

        Static.lastColorIndex = newColorIndex
        nameLabel.textColor = colors[newColorIndex]

        // Calculate label size
        let maxSize = CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = nameLabel.sizeThatFits(maxSize)
        nameLabel.frame = CGRect(x: 0, y: 0, width: requiredSize.width, height: requiredSize.height)

        // Determine label position
        let markerPosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let markerPoint = self.MapView.projection.point(for: markerPosition)
        let visibleRegion = self.MapView.projection.visibleRegion()
        let screenBounds = CGRect(
            origin: CGPoint.zero,
            size: UIScreen.main.bounds.size
        )
        let containerWidth = requiredSize.width + markerImageWidth + 10
        let containerHeight = max(requiredSize.height, markerImageHeight)

        // Determine if the label should be on the left or right
        let isLeftSide = markerPoint.x + containerWidth > screenBounds.maxX

        // Create container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
        containerView.backgroundColor = .clear

        if isLeftSide {
            // Place label on the left
            nameLabel.frame.origin = CGPoint(x: markerImageWidth + 10, y: (containerHeight - requiredSize.height) / 2)
            let markerImageView = UIImageView(frame: CGRect(x: 0, y: (containerHeight - markerImageHeight) / 2, width: markerImageWidth, height: markerImageHeight))
            markerImageView.image = GMSMarker.markerImage(with: UIColor.red)
            markerImageView.contentMode = .scaleAspectFit
            containerView.addSubview(markerImageView)
            containerView.addSubview(nameLabel)
        } else {
            // Place label on the right
            nameLabel.frame.origin = CGPoint(x: 0, y: (containerHeight - requiredSize.height) / 2)
            let markerImageView = UIImageView(frame: CGRect(x: requiredSize.width + 10, y: (containerHeight - markerImageHeight) / 2, width: markerImageWidth, height: markerImageHeight))
            markerImageView.image = GMSMarker.markerImage(with: UIColor.red)
            markerImageView.contentMode = .scaleAspectFit
            containerView.addSubview(nameLabel)
            containerView.addSubview(markerImageView)
        }

        // Render container view to an image
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, false, 0)
        containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let markerIcon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Create and configure marker
        let marker = GMSMarker()
        marker.position = markerPosition
        marker.icon = markerIcon
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        marker.map = self.MapView
        marker.userData = index

        // Adjust camera position
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(14))
        self.MapView.animate(to: camera)
    }
 
    
    // to add custom marker and image.
//    func addCustomMarker(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, imageURL: String, index: Int) {
//        // Create a marker
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        
//        // Create a custom view for the marker
//        let customView = createCustomMarkerView(name: name, imageURL: imageURL)
//        
//        // Set the custom view as the marker icon
//        marker.iconView = customView
//        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0) // Anchor the marker at the bottom center
//        marker.map = self.MapView
//        marker.userData = index
//        
//        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(12.5))
//        self.MapView.animate(to: camera)
//    }
//    
// 
//
//    func createCustomMarkerView(name: String, imageURL: String) -> UIView {
//        // Placeholder sizes
//        let maxLabelWidth: CGFloat = 200
//        let markerImageWidth: CGFloat = 30 // Updated size
//        let markerImageHeight: CGFloat = 30 // Updated size
//
//        // Create the label and calculate its size dynamically
//        let nameLabel = UILabel()
//        nameLabel.text = name
//        nameLabel.font = UIFont(name: "Montserrat-Bold", size: 24.0)
//        nameLabel.numberOfLines = 0
//        nameLabel.lineBreakMode = .byWordWrapping
//        
//        // Predefined color palette
//        let colors: [UIColor] = [
//            UIColor(red: 0.85, green: 0.1, blue: 0.1, alpha: 1.0),   // Bold Red
//            UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0),    // Dark Green
//            UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0),    // Bright Blue
//            UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0),    // Vibrant Orange
//            UIColor(red: 0.58, green: 0.0, blue: 0.65, alpha: 1.0),  // Rich Purple
//            UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1.0),  // Deep Indigo
//            UIColor(red: 0.65, green: 0.16, blue: 0.16, alpha: 1.0), // Maroon
//            UIColor(red: 0.8, green: 0.0, blue: 0.8, alpha: 1.0),    // Bright Magenta
//            UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)     // Teal
//        ]
//        
//        // Static variable to keep track of last used color index
//        struct Static {
//            static var lastColorIndex: Int? = nil
//        }
//
//        var newColorIndex: Int
//        repeat {
//            newColorIndex = Int.random(in: 0..<colors.count)
//        } while newColorIndex == Static.lastColorIndex
//        
//        Static.lastColorIndex = newColorIndex
//        nameLabel.textColor = colors[newColorIndex]
//        
//        // Calculate label size
//        let maxSize = CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude)
//        let requiredSize = nameLabel.sizeThatFits(maxSize)
//        nameLabel.frame = CGRect(x: 0, y: 0, width: requiredSize.width, height: requiredSize.height)
//        
//        // Dynamically calculate the container size
//        let containerWidth = requiredSize.width + markerImageWidth + 10 // 10 is the spacing
//        let containerHeight = max(requiredSize.height, markerImageHeight)
//        
//        // Container for the marker
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
//        containerView.backgroundColor = .clear
//
//        // Add the label to the left
//        nameLabel.frame.origin = CGPoint(x: 0, y: (containerHeight - requiredSize.height) / 2)
//        containerView.addSubview(nameLabel)
//
//        // Marker image on the right
//        let markerImageView = UIImageView(frame: CGRect(x: requiredSize.width, y: (containerHeight - markerImageHeight) / 2, width: markerImageWidth, height: markerImageHeight))
//        let marker = GMSMarker.markerImage(with: UIColor.red)
//        markerImageView.image = marker// UIImage(named: "gps") // Your marker pin image
//        markerImageView.contentMode = .scaleAspectFit
//        containerView.addSubview(markerImageView)
//
//        return containerView
//    }
    

 
//    func createCustomMarkerView(name: String, imageURL: String) -> UIView {
//        // Placeholder sizes
//        let logoImageWidth: CGFloat = 90
//        let logoImageHeight: CGFloat = 85
//        let markerImageWidth: CGFloat = 35
//        let markerImageHeight: CGFloat = 35
//
//        // Dynamically calculate the container width
//        let containerWidth = logoImageWidth + markerImageWidth + 10 // 10 is the spacing
//        let containerHeight = max(logoImageHeight, markerImageHeight)
//        
//        // Container for the marker
//        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
//        containerView.backgroundColor = .clear
//
//        // Image (e.g., market logo) on the left
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImageWidth, height: logoImageHeight))
//        imageView.contentMode = .scaleToFill
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = UIColor.clear
//        imageView.image = nil // Default placeholder
//        containerView.addSubview(imageView)
//
//        // Marker image on the right
//        let markerImageView = UIImageView(frame: CGRect(x: logoImageWidth, y: (containerHeight - markerImageHeight) / 2, width: markerImageWidth, height: markerImageHeight))
//        markerImageView.image = UIImage(named: "gps") // Your marker pin image
//        markerImageView.contentMode = .redraw
//        containerView.addSubview(markerImageView)
//
//        // Load the image asynchronously and adjust the logo image view if needed
//        imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: nil) { (image, error, cacheType, url) in
//            if let loadedImage = image {
//                // Remove background from the loaded image
//                imageView.image = try? BackgroundRemoval.init().removeBackground(image: loadedImage)
//            } else if let error = error {
//                // Handle the error
//                print("Error loading image: \(error.localizedDescription)")
//            }
//        }
//        return containerView
//    }
  }

extension SuperMarketNearByVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        MapView.isMyLocationEnabled = false
        MapView.settings.myLocationButton = false
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                // If status has not yet been determied, ask for authorization
                manager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                // If authorized when in use
                manager.startUpdatingLocation()
                //stopTimer()
                self.MapView.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                currentLat = "\(location.latitude)"
                currentLong = "\(location.longitude)"
                
                break
            case .authorizedAlways:
                // If always authorized
                manager.startUpdatingLocation()
                self.MapView.delegate = self
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.distanceFilter = kCLDistanceFilterNone
                self.locationManager.startUpdatingLocation()
                guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                currentLat = "\(location.latitude)"
                currentLong = "\(location.longitude)"
                
                break
            case .restricted, .denied:
                // If restricted by e.g. parental controls. User can't enable Location Services
                // If user denied your app access to Location Services, but can grant access from Settings.app
                // Disable location features
                
                let alert = UIAlertController(title: "Allow Location Access", message: "My-Kai App needs to access your current location to show data according to your locaton. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
                
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        MapView.isMyLocationEnabled = false
        MapView.settings.myLocationButton = false
    }
    
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let lattitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        // 7
        MapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.currentLat = String(format: "%f", lattitude)
        self.currentLong = String(format: "%f", longitude)
        // 8
        locationManager.stopUpdatingLocation()
    }
    
    func showCurrentLocation() {
        MapView.settings.myLocationButton = false
        marker.icon = GMSMarker.markerImage(with: UIColor.clear)
        MapView.clear()
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        self.currentLat = String(format: "%f", lattitude)
        self.currentLong = String(format: "%f", longitude)
        let center = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = ""
        marker.map = MapView
        marker.icon = GMSMarker.markerImage(with: UIColor.orange)
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: Float(14.0))
        self.MapView.animate(to: camera)
        
        }
   
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D,placeName: String) {
        
        print(coordinate.latitude, "lat")
        print(coordinate.longitude, "lat")
        let geocoder = GMSGeocoder()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let _ = address.lines else {
                return
            }
            // 3
         
          //  self.searchTF.text = lines.joined(separator: "\n")
         
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                
            }
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // reverseGeocodeCoordinate(position.target, placeName: "")
        if let location = locationManager.location {
            reverseGeocodeCoordinate(location.coordinate, placeName: "")
        } else {
            print("Location is not available.")
        }
//        reverseGeocodeCoordinate(locationManager.location!.coordinate, placeName: "")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // self.addressLabel.lock()
        // addressLabel.lock()
    }
    
 
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        // Remove the existing info window
//        infoWindow?.removeFromSuperview()
//
//        // Define the size of the info window
//        let infoWindowWidth: CGFloat = 70
//        let infoWindowHeight: CGFloat = 55
//
//        // Create a custom info window
//        let infoWindow = UIView(frame: CGRect(x: 0, y: 0, width: infoWindowWidth, height: infoWindowHeight))
//        infoWindow.backgroundColor = UIColor.white
//        infoWindow.layer.cornerRadius = 10
//        infoWindow.layer.shadowColor = UIColor.black.cgColor
//        infoWindow.layer.shadowOpacity = 0.3
//        infoWindow.layer.shadowOffset = CGSize(width: 0, height: 2)
//
//        // Add an image to the info window
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: infoWindowWidth, height: infoWindowHeight))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 10
//
//        // Get the marker's index and retrieve the image URL
//        if let index = marker.userData as? Int, index < self.SuperMarketArr.count {
//            let imgURL = self.SuperMarketArr[index].image ?? ""
//
//            // Load the image from the URL
//            if let url = URL(string: imgURL) {
//                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "No_Image"))
//            }
//            
//            infoWindow.addSubview(imageView)
//
//            // Position the info window above the marker
//            let markerPosition = mapView.projection.point(for: marker.position)
//            infoWindow.center = CGPoint(x: markerPosition.x, y: markerPosition.y - (infoWindowHeight / 2))
//            mapView.addSubview(infoWindow)
//
//            // Store references
//            self.selectedMarker = marker
//            self.infoWindow = infoWindow
//        }
//
//        return true
//    }
//
//    func mapView(_ mapView: GMSMapView, didChange cameraPosition: GMSCameraPosition) {
//        // Update the position of the info window to follow the marker
//        if let marker = selectedMarker, let infoWindow = infoWindow {
//            let markerPosition = mapView.projection.point(for: marker.position)
//            infoWindow.center = CGPoint(x: markerPosition.x, y: markerPosition.y - (infoWindow.frame.height / 2))
//        }
//    }
//    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//            infoWindow?.removeFromSuperview()
//        }
}
