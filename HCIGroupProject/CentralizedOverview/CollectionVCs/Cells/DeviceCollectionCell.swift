//
//  DeviceCollectionCell.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import UIKit

class DeviceCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceBrandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRoundedCorners()
        generateRandomBackgroundColor()
    }
    
    func configure(with device: Device) {
//        label.text = text
        deviceNameLabel.text = device.name
        deviceBrandLabel.text = device.brand
    }
    
    private func setupRoundedCorners() {
        // Round corners
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        // Optional: Add a border and shadow for better visibility
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func generateRandomBackgroundColor() {
        // Generate a random dark color
        let randomColor = UIColor(
            red: CGFloat.random(in: 0.1...0.4),
            green: CGFloat.random(in: 0.1...0.4),
            blue: CGFloat.random(in: 0.1...0.4),
            alpha: 1.0
        )
        self.backgroundColor = randomColor
    }
}
