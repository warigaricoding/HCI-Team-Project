//
//  DeviceInfoVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/25/24.
//

import UIKit

class DeviceInfoVC: UIViewController {
    
    // Example outlets for labels
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var connectedSinceLabel: UILabel!
    @IBOutlet weak var modelIdLabel: UILabel!
    @IBOutlet weak var locatedInLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    
    // Property to receive the device from DeviceDetailVC
    var device: Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure the device is not nil
        guard let device = device else {
            fatalError("Device must be passed to DeviceInfoVC before presentation.")
        }
        
        // Populate labels with the device details
        brandLabel.text = device.brand
        connectedSinceLabel.text = device.dateConnected
        modelIdLabel.text = device.modelId
        locatedInLabel.text = device.localLocationId
        deviceTypeLabel.text = device.category.displayName
    }
}
