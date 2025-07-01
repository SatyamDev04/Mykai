//
//  AddCardBankContainerVC.swift
//  Myka App
//
//  Created by YES IT Labs on 19/12/24.
//

import UIKit
 
class AddCardBankContainerVC: UIViewController {
     
    @IBOutlet weak var AddBankAccO: UIButton!
    @IBOutlet weak var AddCardO: UIButton!
    @IBOutlet weak var btnsBgView:UIView!
    @IBOutlet weak var ContainerV: UIView!
    
    @IBOutlet weak var BgV: UIView!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
   
    var addCardVC:AddCardVC! = nil
    var AddbankVC:AddBankVC! = nil
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 1
        createPageViewController()
        self.btnClicked(btn: self.AddCardO)
//        
        BgV.layer.cornerRadius = 15
      // Round top-left and top-right corners only
        BgV.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @IBAction func BackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func BankBtn(_ sender: UIButton) {
        AddCardO.setBackgroundImage(UIImage(named: ""), for: .normal)
        AddBankAccO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        AddCardO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        AddBankAccO.setTitleColor(UIColor.white, for: .normal)
        btnClicked(btn: sender)
    }
    
    @IBAction func CardBtn(_ sender: UIButton) {
        AddCardO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
        AddBankAccO.setBackgroundImage(UIImage(named: ""), for: .normal)
        AddCardO.setTitleColor(UIColor.white, for: .normal)
        AddBankAccO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
        btnClicked(btn: sender)
    }
    
     
    @IBAction private func btnClicked(btn: UIButton) {
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in })
    }
}

extension AddCardBankContainerVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate{
    private func createPageViewController() {
        // Initialize the page view controller
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        // Set UIScrollView delegate for pageController's scroll view
        for subview in pageController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        // Instantiate view controllers
        AddbankVC = self.storyboard?.instantiateViewController(withIdentifier: "AddBankVC") as? AddBankVC
        addCardVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as? AddCardVC
        
        arrVC = [AddbankVC, addCardVC]
        
        // Set initial view controller for the pageController
        pageController.setViewControllers([addCardVC!], direction: .forward, animated: false, completion: nil)
        
        // Add pageController as a child view controller
        self.addChild(pageController)
        ContainerV.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        // Use Auto Layout to match the frame of ContainerV
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: ContainerV.topAnchor ),
            pageController.view.bottomAnchor.constraint(equalTo: ContainerV.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: ContainerV.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: ContainerV.trailingAnchor)
        ])
    }
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.firstIndex(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
            
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        if index == 0 {
            
        }else{
            
        }
        if(index != -1) {
            index = index + 1
           
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.firstIndex(of: (pageViewController1.viewControllers?.last)!)
            if let cur = currentPage {
                if cur == 0 {
                    AddCardO.setBackgroundImage(UIImage(named: ""), for: .normal)
                    AddBankAccO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
                    AddCardO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
                    AddBankAccO.setTitleColor(UIColor.white, for: .normal)
                }else{
                    AddCardO.setBackgroundImage(UIImage(named: "Rectangle 47"), for: .normal)
                    AddBankAccO.setBackgroundImage(UIImage(named: ""), for: .normal)
                    AddCardO.setTitleColor(UIColor.white, for: .normal)
                    AddBankAccO.setTitleColor(#colorLiteral(red: 0, green: 0.786260426, blue: 0.4870494008, alpha: 1), for: .normal)
                }
            }
        }
        
    }
}
