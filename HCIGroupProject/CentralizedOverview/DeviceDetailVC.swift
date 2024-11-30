//
//  DeviceDetailVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/16/24.
//

import Foundation
import UIKit

class DeviceDetailVC: UIViewController {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var connectedDateLabel: UILabel!
    @IBOutlet weak var modelIdLabel: UILabel!
    @IBOutlet weak var locatedInLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    
    var device: Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var name: String
//        var brand: String
//        var dateConnected: String
//        var modelId: String
//        var category: DeviceCategory
//        var localLocationId: String // for categorizing by room
//        var electricityUsage: [String]
//        var customGroupId: String // "-1" for no group
//        var relatedDevices: [String]
        configure()
    }
    
    private func configure() {
        deviceNameLabel.text = device.name
        brandLabel.text = device.brand
        connectedDateLabel.text = device.dateConnected
        modelIdLabel.text = device.modelId
        locatedInLabel.text = device.localLocationId
        deviceTypeLabel.text = device.category.displayName
    }
    
    static func initialize(with device: Device) -> DeviceDetailVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        detailVC.device = device
        return detailVC
    }
}
