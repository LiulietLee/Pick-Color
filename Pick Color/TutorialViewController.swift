//
//  TutorialViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 25/8/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {

    fileprivate var pageController = UIPageViewController()
    
    fileprivate let gifs = ["tut1", "tut2", "tut3", "tut4"]
    fileprivate let labels = [
        "zoom in or out with two fingers",
        "move around with two fingers",
        "pick color with one finger",
        "double-tap to reset the image's position",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = self.storyboard?.instantiateViewController(withIdentifier: "page") as! UIPageViewController
        pageController.dataSource = self
        let viewControllers = [viewControllerAt(index: 0)]
        pageController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        let size = view.bounds.size
        pageController.view.frame = CGRect(x: 0, y: 20.0, width: size.width, height: size.height - 80.0)
        
        self.addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
    }
    
    fileprivate func viewControllerAt(index: Int) -> TutorialContentViewController {
        if index >= gifs.count || index < 0 {
            return TutorialContentViewController()
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "content") as! TutorialContentViewController
        vc.index = index
        vc.gifName = gifs[index]
        vc.text = labels[index]
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! TutorialContentViewController
        if vc.index == gifs.count - 1 {
            return nil
        }
        return viewControllerAt(index: vc.index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! TutorialContentViewController
        if vc.index == 0 {
            return nil
        }
        return viewControllerAt(index: vc.index - 1)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return gifs.count
    }

    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
