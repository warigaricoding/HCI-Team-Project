//
//  ViewController.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import UIKit
import Foundation


class CentralizedOverviewVC: UIViewController {
    
    @IBOutlet weak var toggleGroupByBtn: UIButton!
    
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var selectedIndexPath: IndexPath?

    var deviceList: [Device] = MockDevices().deviceList
    
    var deviceCategories: [DeviceCategory] {
        return Array(Set(deviceList.map { $0.category })).sorted { $0.rawValue < $1.rawValue }
    }
    
    var locationIds: [String] {
        return Array(Set(deviceList.map { $0.localLocationId })).sorted()
    }
    
    var deviceViewType: DeviceViewType = .category {
        didSet {
            byLabel.text = deviceViewType == .category ? "by Category" : "by Area"
            toggleGroupByBtn.setTitle(deviceViewType == .category ? "List By Area" : "List By Category", for: .normal)
            if let navController = children.first as? UINavigationController,
               let typeCollectionVC = navController.viewControllers.first as? TypeCollectionVC {
                typeCollectionVC.updateViewType(to: deviceViewType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navController = children.first as? UINavigationController,
           let typeCollectionVC = navController.viewControllers.first as? TypeCollectionVC {
            typeCollectionVC.delegate = self
        }
        initUI()
    }
    
    
    
    func initUI() {
        toggleGroupByBtn.layer.cornerRadius = 10
        toggleGroupByBtn.clipsToBounds = true
        byLabel.text = deviceViewType == .category ? "by Category" : "by Area"
        toggleGroupByBtn.setTitle(deviceViewType == .category ? "List By Area" : "List By Category", for: .normal)
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            containerView.frame.size.height = view.bounds.height - tabBarHeight
        }
    }
    
    @IBAction func toggleModeBtnPressed(_ sender: Any) {
        toggleDeviceViewType()
    }
    
    private func toggleDeviceViewType() {
        if let navController = children.first as? UINavigationController {
            // Check if the current top view controller is DevicesCollectionVC
            if navController.topViewController is DevicesCollectionVC {
                // Pop back to TypeCollectionVC before toggling
                navController.popViewController(animated: true)
            }
        }
        
        // Toggle the device view type
        self.deviceViewType = (self.deviceViewType == .category) ? .room : .category
        
        // Notify TypeCollectionVC of the view type change
        if let navController = children.first as? UINavigationController,
           let typeCollectionVC = navController.viewControllers.first as? TypeCollectionVC {
            typeCollectionVC.updateViewType(to: self.deviceViewType)
        }
    }
}

extension CentralizedOverviewVC: TypeCollectionVCDelegate {
    func deviceSelected(_ device: Device) {
           // Use the factory method to initialize DeviceDetailVC with the selected device
           let detailVC = DeviceDetailVC.initialize(with: device)
           // Push the view controller
           navigationController?.pushViewController(detailVC, animated: true)
       }
    
    func provideDeviceCategories() -> [DeviceCategory] {
        return deviceCategories
    }
    
    func provideLocationIds() -> [String] {
        return locationIds
    }
    
    func provideDevices() -> [Device] {
        return deviceList
    }
    
    func viewTypeDidChange(to viewType: DeviceViewType) {
        if let navController = children.first as? UINavigationController,
           let typeCollectionVC = navController.viewControllers.first as? TypeCollectionVC {
            typeCollectionVC.updateViewType(to: viewType)
        }
    }
}

enum DeviceViewType {
    case category
    case room
}
