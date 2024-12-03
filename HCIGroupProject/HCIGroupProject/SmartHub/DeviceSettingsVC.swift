//
//  SettingsVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit
import Foundation

class DeviceSettingsVC: UIViewController {
    
    var device: Device? = nil
    var parentVC: UIViewController?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let device = self.device {
            configure(device)
        }
    }
    
    
    func configure(_ device: Device) {
        nameTextField.text = device.name
        locationTextField.text = device.localLocationId
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        device?.name = nameTextField.text ?? ""
        device?.localLocationId = locationTextField.text ?? ""
        
        if let vc = parentVC as? DeviceDetailVC {
            vc.device = self.device
            vc.configure()
            self.dismiss(animated: true)
        }
    }
}
