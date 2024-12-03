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
    @IBOutlet weak var roomsBtn: UIButton!
    @IBOutlet weak var controlsBtn: UIButton!
    @IBOutlet weak var customSettingsBtn: UIButton!
    @IBOutlet weak var usageStatisticsBtn: UIButton!
    @IBOutlet weak var smartSuggestionsBtn: UIButton!
    
    var presentationVCWidth: CGFloat = 0
    var presentationVCHeight: CGFloat = 0
    var device: Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        initUI()
    }
    
    func configure() {
        deviceNameLabel.text = device.name
        
    }
    
    private func initUI() {
        roomsBtn.applyRoundedStyle()
        controlsBtn.applyRoundedStyle()
        customSettingsBtn.applyRoundedStyle()
        smartSuggestionsBtn.applyRoundedStyle()
    }
    
    static func initialize(with device: Device) -> DeviceDetailVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DeviceDetailVC") as! DeviceDetailVC
        detailVC.device = device
        return detailVC
    }
    
    @IBAction func roomsBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let roomVC = storyboard.instantiateViewController(withIdentifier: "RoomVC") as? RoomVC else {
            return
        }
        
        // Configure modal presentation style
        
        presentationVCWidth = 300
        presentationVCHeight = 140
        
        roomVC.modalPresentationStyle = .custom // Use popover for a centered effect
        roomVC.transitioningDelegate = self
        roomVC.preferredContentSize = CGSize(width: presentationVCWidth, height: presentationVCHeight)
        
        roomVC.roomText = device.localLocationId
        
        // Present the modal
        self.present(roomVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func controlsBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let turnOnVC = storyboard.instantiateViewController(withIdentifier: "TurnOnVC") as? TurnOnVC else {
            return
        }
        
        presentationVCWidth = 300
        presentationVCHeight = 140
        
        turnOnVC.modalPresentationStyle = .custom // Use popover for a centered effect
        turnOnVC.transitioningDelegate = self
        turnOnVC.preferredContentSize = CGSize(width: presentationVCWidth, height: presentationVCHeight)
        
        
        self.present(turnOnVC, animated: true, completion: nil)
        
    }
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingsVC = storyboard.instantiateViewController(withIdentifier: "DeviceSettingsVC") as? DeviceSettingsVC else {
            return
        }
        
        presentationVCWidth = 340
        presentationVCHeight = 300
        
        settingsVC.modalPresentationStyle = .custom // Use popover for a centered effect
        settingsVC.transitioningDelegate = self
        settingsVC.preferredContentSize = CGSize(width: presentationVCWidth, height: presentationVCHeight)
        
        settingsVC.parentVC = self
        settingsVC.device = self.device
        
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    
    @IBAction func scheculingBtnPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let schedulesListVC = storyboard.instantiateViewController(withIdentifier: "SchedulesListVC") as? SchedulesListVC else {
            return
        }
        
        schedulesListVC.transitioningDelegate = self
        schedulesListVC.preferredContentSize = CGSize(width: presentationVCWidth, height: presentationVCHeight)
        
        schedulesListVC.parentVC = self
        schedulesListVC.device = self.device
        
        navigationController?.pushViewController(schedulesListVC, animated: true)
    }
    
    
    
    
    
    @IBAction func showDetailsTapped(_ sender: UIButton) {
        // Instantiate DeviceInfoVC from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let deviceInfoVC = storyboard.instantiateViewController(withIdentifier: "DeviceInfoVC") as? DeviceInfoVC else {
            return
        }
        
        // Pass the current device to DeviceInfoVC
        deviceInfoVC.device = self.device
        
        // Set presentation style
        deviceInfoVC.modalPresentationStyle = .pageSheet
        if let sheet = deviceInfoVC.sheetPresentationController {
            sheet.detents = [.custom { _ in 400 }] // Custom height of 400
            sheet.prefersGrabberVisible = true // Optional: Show a grabber at the top
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Prevent fullscreen expansion on scroll
        }
        // Present the view controller
        self.present(deviceInfoVC, animated: true, completion: nil)
        }
}

extension DeviceDetailVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, width: presentationVCWidth, height: presentationVCHeight)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverPresentationAnimator(width: presentationVCWidth, height: presentationVCHeight)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil // Optional: Provide a custom dismiss animation
    }
}
