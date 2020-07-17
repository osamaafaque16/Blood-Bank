//
//  pageControllerViewController.swift
//  BloodBankApp
//
//  Created by Apple on 3/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class pageControllerViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
 
    

    lazy var  orderViewController: [UIViewController] = {
        
        return [self.newVc(viewController:"screenOne"),
                self.newVc(viewController:"screenTwo"),
               self.newVc(viewController:"screenThree")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstViewControoler = orderViewController.first{
            setViewControllers([firstViewControoler], direction: .forward, animated: true) { (nil) in
                
            }
        }
        
        configurePageControl()

        // Do any additional setup after loading the view.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex =  orderViewController.index(of: viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
           return nil
        }
        
        guard orderViewController.count > previousIndex else{
            return nil
        }
        return orderViewController[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
               guard let viewControllerIndex =  orderViewController.index(of: viewController) else{
               return nil
           }
           
           let nextIndex = viewControllerIndex + 1
        guard orderViewController.count > nextIndex else {
              return nil
           }
           
           guard orderViewController.count > nextIndex else{
               return nil
           }
           return orderViewController[nextIndex]
     }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderViewController.index(of: pageContentViewController)!
    }
    
    func configurePageControl(){
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width:UIScreen.main.bounds.width , height: 50))
        pageControl.numberOfPages = orderViewController.count
        pageControl.currentPage = 0
        pageControl.tintColor = .systemRed
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .systemRed
        self.view.addSubview(pageControl)
    }
    
    func newVc(viewController:String) -> UIViewController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    



}
