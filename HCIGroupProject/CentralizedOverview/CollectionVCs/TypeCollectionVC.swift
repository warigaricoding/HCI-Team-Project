//
//  TypeCollectionVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import UIKit

protocol TypeCollectionVCDelegate: AnyObject {
    func provideDeviceCategories() -> [DeviceCategory]
    func provideLocationIds() -> [String]
    func provideDevices() -> [Device]
}

class TypeCollectionVC: UICollectionViewController {
    weak var delegate: TypeCollectionVCDelegate?
    
    var deviceCategories: [DeviceCategory] = []
    
    var devices: [Device] = []
    
    var locationIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch categories from the delegate
        if let categories = delegate?.provideDeviceCategories(), let locationIds = delegate?.provideLocationIds() {
            self.deviceCategories = categories
            self.locationIds = locationIds
            collectionView.reloadData()
        }
        
        if let devices = delegate?.provideDevices() {
            self.devices = devices
        }

    }
    
    func updateViewType(to viewType: DeviceViewType) {
        switch viewType {
        case .category:
            if let categories = delegate?.provideDeviceCategories() {
                self.deviceCategories = categories
                self.locationIds = []
            }
        case .room:
            if let locations = delegate?.provideLocationIds() {
                self.locationIds = locations
                self.deviceCategories = []
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        guard let devicesVC = storyboard?.instantiateViewController(withIdentifier: "DevicesCollectionVC") as? DevicesCollectionVC else { return }
        
        // Determine the list of devices to pass based on the current view type
        if !deviceCategories.isEmpty {
            let selectedCategory = deviceCategories[indexPath.item]
            devicesVC.deviceList = devices.filter { $0.category == selectedCategory }
        } else if !locationIds.isEmpty {
            let selectedLocation = locationIds[indexPath.item]
            devicesVC.deviceList = devices.filter { $0.localLocationId == selectedLocation }
        }
        
        // Set the delegate to self
        devicesVC.delegate = self
        
        navigationController?.pushViewController(devicesVC, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !deviceCategories.isEmpty {
            return deviceCategories.count
        } else {
            return locationIds.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpandableCell", for: indexPath) as? ExpandableCell else {
            return UICollectionViewCell()
        }
        
        if !deviceCategories.isEmpty {
            let category = deviceCategories[indexPath.item]
            cell.configure(deviceCategory: category)
        } else if !locationIds.isEmpty {
            let location = locationIds[indexPath.item]
            cell.configure(location: location)
        }
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension TypeCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewWidth = collectionView.bounds.width
        let numberOfCellsPerRow: CGFloat = 2
        let cellWidth = (collectionViewWidth - (padding * (numberOfCellsPerRow + 1))) / numberOfCellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension TypeCollectionVC: DevicesCollectionVCDelegate {
    func deviceSelected(_ device: Device) {
        // Pass the notification up to CentralizedOverviewVC
        (delegate as? CentralizedOverviewVC)?.deviceSelected(device)
    }
    
}
