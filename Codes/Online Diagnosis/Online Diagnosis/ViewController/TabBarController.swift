//
//  TabBarController.swift
//  Online Diagnosis
//
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace 1 with the index of the tab item you want to hide
        let indexToHide = 1
        let userType = UserDefaultsManager.shared.getUserType()
        if userType == UserType.doctor.rawValue{
            if indexToHide < viewControllers?.count ?? 0 {
                // Create a new array without the view controller you want to hide
                var updatedViewControllers = viewControllers ?? []
                updatedViewControllers.remove(at: indexToHide)
                
                // Set the updated view controllers array
                setViewControllers(updatedViewControllers, animated: false)
            }
        }

    }
}
