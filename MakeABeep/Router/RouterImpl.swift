//
//  RouterImpl.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import UIKit


class RouterImpl: NSObject, Router {
    
    var storyboard: UIStoryboard!
    
    fileprivate var currentViewController: UIViewController? {
        return UIApplication.topViewController
    }
    
}

// Route functions

extension RouterImpl {
    
    fileprivate func initRootViewController(with rootViewController: UIViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = rootViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    private func getViewController(type: RouterViewControllerType) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: type.identifier)
    }

    func pushViewController(type: RouterViewControllerType) -> UIViewController {
        let nextViewController = getViewController(type: type)
        currentViewController?.navigationController?.pushViewController(nextViewController, animated: true)
        return nextViewController
    }
    
    func presentViewController(type: RouterViewControllerType) -> UIViewController  {
        
        let nextViewController = getViewController(type: type)
        
        if currentViewController != nil {
             currentViewController?.present(nextViewController, animated: true, completion: nil)
        } else {
            initRootViewController(with: nextViewController)
        }
        return UIViewController()
    }
}

extension UIApplication {
    
    private class func _topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return _topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return _topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return _topViewController(base: presented)
        }
        return base
    }
    
    class var topViewController: UIViewController? {
        return _topViewController()
        
    }
}

class RouterImpl2: NSObject, Router{
    
    func pushViewController(type: RouterViewControllerType) -> UIViewController {
        print("aiaiai")
        return UIViewController()
    }
    
    func presentViewController(type: RouterViewControllerType) -> UIViewController  {
        
        print("tratata")
        return UIViewController()
    }

}
