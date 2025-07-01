//
//  IntroVC1.swift
//  Myka
//
//  Created by YES IT Labs on 26/11/24.
//

import UIKit
import AdvancedPageControl

struct IntroVC1Data {
    let title: String
    let desc: String
    let image: UIImage
}

class IntroVC1: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var CollV: UICollectionView!
    @IBOutlet weak var NextBtnBGV: UIView!
    @IBOutlet weak var LetsGetBtnBGV: UIView!
    @IBOutlet weak var pageView: AdvancedPageControlView!
    
    var counter = 0
    var IntroArr = [IntroVC1Data(title: "Plan a Meal", desc: "Get meal plans tailored to your \npreferences and goals", image: UIImage(named: "Mask group")!), IntroVC1Data(title: "Compare Store Prices", desc: "My Kai adds your meal plan ingredients to\nyour cart and compares prices across\nnearby stores, giving you the best deals", image: UIImage(named: "Mask group1")!), IntroVC1Data(title: "10-Min Weekly Grocery Run", desc: "Finalize your grocery items and get them\ndelivered straight to your door", image: UIImage(named: "Mask group2")!), IntroVC1Data(title: "Track Your Expenses", desc: "Track and analyze your grocery expenses\nto save and stay on budget", image: UIImage(named: "Mask group3")!)]
    
    

    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NextBtnBGV.isHidden = false
        self.LetsGetBtnBGV.isHidden = true
        
       // pageView.drawer = ExtendedDotDrawer()
        pageView.drawer = ExtendedDotDrawer(numberOfPages: IntroArr.count,
                                            height: 10.0,
                                            width: 12.0,
                                            space: 10.0,
                                            raduis: 10.0,
                                                indicatorColor: UIColor.init(red: 254/255, green: 159/255, blue: 69/255, alpha: 1),
                                            dotsColor: .lightGray,
                                                isBordered: false,
                                                borderWidth: 0.0,
                                                indicatorBorderColor: .clear,
                                                indicatorBorderWidth: 0.0)
        
       
       // pageView.numberOfPages = imgArr.count
        pageView.drawer.currentItem = 0
        
        self.CollV.dataSource = self
        self.CollV.delegate = self
        self.CollV.register(UINib(nibName:"IntroVC1CollV",bundle: nil), forCellWithReuseIdentifier: "IntroVC1CollV")
        
        
        
        navigationController?.delegate = self
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        var indexes = self.CollV.indexPathsForVisibleItems
            
        indexes.sort()
        var index = indexes.first!
        index.row = index.row + 1
      if index[1] == 3{
          self.NextBtnBGV.isHidden = true
          self.LetsGetBtnBGV.isHidden = false
          UserDetail.shared.setOnboardingStatus(true)
        }else{
            UserDetail.shared.setOnboardingStatus(false)
            self.NextBtnBGV.isHidden = false
            self.LetsGetBtnBGV.isHidden = true
        }
        CollV.scrollToItem(at: index, at: .left, animated: true)
        CollV.reloadItems(at: [index])
    }
    
    @IBAction func LetsGetBtn(_ sender: UIButton) {
        let nextVc = self.storyboard?.instantiateViewController(identifier: "EnterNameVC") as! EnterNameVC
    self.navigationController?.pushViewController(nextVc, animated: true)
    }
}

extension IntroVC1: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return IntroArr.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroVC1CollV", for: indexPath) as! IntroVC1CollV
        
        cell.img.image = IntroArr[indexPath.item].image
      return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.CollV.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.CollV.cellForItem(at: index)!
        let position = self.CollV.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
           index.row = index.row+1
        }
        if index[1] == 0 {
            self.NextBtnBGV.isHidden = false
            self.LetsGetBtnBGV.isHidden = true
            UserDetail.shared.setOnboardingStatus(false)
        }else if index[1] == 3{
            self.NextBtnBGV.isHidden = true
            self.LetsGetBtnBGV.isHidden = false
            UserDetail.shared.setOnboardingStatus(true)
        }else{
            self.NextBtnBGV.isHidden = false
            self.LetsGetBtnBGV.isHidden = true
            UserDetail.shared.setOnboardingStatus(false)
        }
        
        self.CollV.scrollToItem(at: index, at: .left, animated: true )
        //self.CollV.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let visibleRect = CGRect(origin: self.CollV.contentOffset, size: self.CollV.bounds.size)
           let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
           if let visibleIndexPath = self.CollV.indexPathForItem(at: visiblePoint) {
               
               let index = visibleIndexPath.row
               
               self.TitleLbl.text = IntroArr[index].title
               self.DescLbl.text = IntroArr[index].desc
               self.pageView.setPage(index)
              // CollV.reloadItems(at: [visibleIndexPath])
               
               updateCollectionViewFrame()
           }
    }
        
    
    func updateCollectionViewFrame() {
        // Force layout update
        self.CollV.layoutIfNeeded()
        
        // Calculate the new height
        let contentHeight = self.CollV.collectionViewLayout.collectionViewContentSize.height
        
        // Update the frame
        self.CollV.frame.size.height = contentHeight
    }
  }

extension IntroVC1 : UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let collectionViewHeight = collectionView.frame.height
       print(collectionViewHeight, "collectionViewHeight")
    return CGSize(width: collectionView.frame.width, height: collectionViewHeight)
       
   }
 
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CollV.collectionViewLayout.invalidateLayout() // Ensures layout is recalculated
        CollV.reloadData()
    }
    
}
