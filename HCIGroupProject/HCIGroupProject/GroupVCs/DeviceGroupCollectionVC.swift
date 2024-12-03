//
//  DeviceGroupCollectionVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

class DeviceGroupCollectionVC: UICollectionViewController {
    var deviceGroups: [DeviceGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceGroups.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceGroupCollectionCell", for: indexPath) as? DeviceGroupCollectionCell else {
            return UICollectionViewCell()
        }
        
        // Configure the cell with the device group
        let group = deviceGroups[indexPath.item]
        cell.configure(with: group)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? DeviceGroupCollectionCell
        cell?.groupNameLabel.textColor = .white // Ensure consistent color

        
        let selectedGroup = deviceGroups[indexPath.item]
        
        // Navigate to DeviceGroupVC
        guard let deviceGroupVC = storyboard?.instantiateViewController(withIdentifier: "DeviceGroupVC") as? DeviceGroupVC else {
            return
        }
        
        // Pass the selected device group to the new view controller
        deviceGroupVC.deviceGroup = selectedGroup
        
        // Push the new view controller onto the navigation stack
        navigationController?.pushViewController(deviceGroupVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DeviceGroupCollectionVC: UICollectionViewDelegateFlowLayout {
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
