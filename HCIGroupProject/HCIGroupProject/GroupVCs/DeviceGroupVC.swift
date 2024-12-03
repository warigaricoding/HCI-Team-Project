//
//  DeviceGroupVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/27/24.
//

import UIKit

class DeviceGroupVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var devicesTableView: UITableView!
    @IBOutlet weak var controlsBtn: UIButton!
    @IBOutlet weak var schedulingBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    // MARK: - Properties
    var deviceGroup: DeviceGroup!
    var deviceList: [Device] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        initUI()
        devicesTableView.dataSource = self // Set TableView data source
        devicesTableView.delegate = self // Set TableView delegate (if needed)
    }
    
    // MARK: - Configuration
    private func configure() {
        groupNameLabel.text = deviceGroup.name
        roomNameLabel.text = deviceGroup.localLocationId
        deviceList = AppConfig.shared.devices.filter { device in
            deviceGroup.deviceIds.contains(device.Id)
        }
        devicesTableView.reloadData()
    }
    
    private func initUI() {
        
        // Optionally register a cell for the TableView
        devicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
    }
    
    static func initialize(with deviceGroup: DeviceGroup) -> DeviceGroupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let groupVC = storyboard.instantiateViewController(withIdentifier: "DeviceGroupVC") as! DeviceGroupVC
        groupVC.deviceGroup = deviceGroup
        return groupVC
    }
    
    // MARK: - Actions
    @IBAction func controlsTapped(_ sender: UIButton) {
        // Handle controls button action
        print("Controls tapped for group: \(deviceGroup.name)")
    }
    
    @IBAction func schedulingTapped(_ sender: UIButton) {
        // Handle scheduling button action
        print("Scheduling tapped for group: \(deviceGroup.name)")
    }
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        // Handle settings button action
        print("Settings tapped for group: \(deviceGroup.name)")
    }
    @IBAction func addBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let devicesVC = storyboard.instantiateViewController(withIdentifier: "DevicesCollectionVC") as? DevicesCollectionVC else {
            return
        }
        
        // Configure modal presentation style
        
        devicesVC.modalPresentationStyle = .custom // Use popover for a centered effect
        devicesVC.transitioningDelegate = self
        //        devicesVC.modalPresentationStyle = .popover // Use popover for a centered effect
        devicesVC.preferredContentSize = CGSize(width: 364, height: 631)
        
        // Set up popover presentation controller
        if let popover = devicesVC.popoverPresentationController {
            popover.sourceView = self.view // Anchor to the presenting view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Center the popover
            popover.permittedArrowDirections = [] // Disable arrow
            popover.delegate = self // Enable adaptive behavior
        }
        
        devicesVC.isFromDeviceGroup = true
        devicesVC.parentVC = self
        
        devicesVC.deviceList = AppConfig.shared.devices.filter { sharedDevice in
            !self.deviceList.contains(where: { $0.Id == sharedDevice.Id })
        }
        
        
        // Present the modal
        self.present(devicesVC, animated: true, completion: nil)
        
        
    }
}

extension DeviceGroupVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, width: 340, height: 600)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverPresentationAnimator(width: 340, height: 600)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil // Optional: Provide a custom dismiss animation
    }
}


extension DeviceGroupVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Force popover to remain centered on iPhone
    }
}


// MARK: - UITableViewDataSource
extension DeviceGroupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceGroup.deviceIds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as? DeviceTableViewCell else {
            return UITableViewCell()
        }
        
        
        let device = deviceList[indexPath.row] // Replace with your data source
        cell.configure(with: device)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate (Optional)
extension DeviceGroupVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle device selection
        let selectedDeviceId = deviceGroup.deviceIds[indexPath.row]
        print("Selected device ID: \(selectedDeviceId)")
        
        if let device = AppConfig.shared.deviceWithId(id: selectedDeviceId) {
            let detailVC = DeviceDetailVC.initialize(with: device)
            // Push the view controller
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // Add trailing swipe actions for deleting a device
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a "Delete" action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Remove the device from the group
            let deviceToDelete = self.deviceList[indexPath.row]
            if let index = self.deviceGroup.deviceIds.firstIndex(of: deviceToDelete.Id) {
                self.deviceGroup.deviceIds.remove(at: index)
            }
            
            // Update the device list and table view
            self.deviceList.remove(at: indexPath.row)
            tableView.reloadData()
            
            // Notify completion
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        // Create the configuration with the action
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true // Allow full swipe to trigger the action
        return configuration
    }
}

class DeviceTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    // MARK: - Cell Configuration
    func configure(with device: Device) {
        deviceNameLabel.text = device.name
        locationLabel.text = device.localLocationId
        typeLabel.text = device.category.displayName
    }
    
    // Optional: Handle reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        deviceNameLabel.text = nil
        locationLabel.text = nil
        typeLabel.text = nil
    }
}
