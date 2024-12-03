//
//  DeviceGroupOverviewVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

class DeviceGroupOverviewVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var deviceGroups: [DeviceGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewController()
    }
    
    private func setupChildViewController() {
        guard let deviceGroupCollectionVC = storyboard?.instantiateViewController(withIdentifier: "DeviceGroupCollectionVC") as? DeviceGroupCollectionVC else {
            return
        }
        
        // Pass the device list to the collection view controller
        deviceGroupCollectionVC.deviceGroups = deviceGroups
        
        // Add as child view controller
        addChild(deviceGroupCollectionVC)
        containerView.addSubview(deviceGroupCollectionVC.view)
        deviceGroupCollectionVC.view.frame = containerView.bounds
        deviceGroupCollectionVC.didMove(toParent: self)
    }
    @IBAction func addDeviceGroupBtnPressed(_ sender: Any) {
        
        
    }
}
