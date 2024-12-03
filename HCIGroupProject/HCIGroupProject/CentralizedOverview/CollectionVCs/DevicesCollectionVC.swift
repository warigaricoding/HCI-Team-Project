//
//  DevicesCollectionVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import UIKit

protocol DevicesCollectionVCDelegate: AnyObject {
    func deviceSelected(_ device: Device)
}

class DevicesCollectionVC: UICollectionViewController {
    weak var delegate: DevicesCollectionVCDelegate?

    var isFromSmartHub = false
    var isFromDeviceGroup = false
    var parentVC: UIViewController?
    var deviceList: [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 364, height: 631)

        if isFromSmartHub {
            deviceList = AppConfig.shared.devices
            collectionView.reloadData()
        }
        
        if isFromDeviceGroup {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFromSmartHub {
            if let vc = parentVC as? SmartHubVC {
                self.dismiss(animated: false) {
                    let detailVC = DeviceDetailVC.initialize(with: self.deviceList[indexPath.row])
                    // Push the view controller
                    vc.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            return
        }
        
        if isFromDeviceGroup {
            if let vc = parentVC as? DeviceGroupVC {
                self.dismiss(animated: false) {
                    // Add the selected device to the group
                    let selectedDevice = self.deviceList[indexPath.row]
                    vc.deviceGroup.deviceIds.append(selectedDevice.Id)
                    vc.deviceList.append(selectedDevice)
                    
                    // Reload the table view
                    DispatchQueue.main.async {
                        vc.devicesTableView.reloadData()
                        print("Devices in group: \(vc.deviceList.map { $0.name })") // Debugging output
                    }
                }
            }
        }
        selectedIndexPath = indexPath
        delegate?.deviceSelected(deviceList[indexPath.row])
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCollectionCell", for: indexPath) as? DeviceCollectionCell else {
                return UICollectionViewCell()
            }
            let device = deviceList[indexPath.item]
            cell.configure(with: device) // Assuming you have a configure method
            return cell
        }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension DevicesCollectionVC: UICollectionViewDelegateFlowLayout {
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

