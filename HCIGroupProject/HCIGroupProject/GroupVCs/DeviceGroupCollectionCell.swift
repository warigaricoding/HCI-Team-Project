//
//  DeviceGroupCollectionCell.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

class DeviceGroupCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRoundedCorners()
        generateRandomBackgroundColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the label color to its default state
        groupNameLabel.textColor = .white // Or your desired default color
    }
    
    func configure(with deviceGroup: DeviceGroup) {
        groupNameLabel.text = deviceGroup.name
        groupNameLabel.textColor = .white
    }
    
    override var isSelected: Bool {
        didSet {
            groupNameLabel.textColor = isSelected ? .white : .white // Set the desired color
        }
    }

    override var isHighlighted: Bool {
        didSet {
            groupNameLabel.textColor = isHighlighted ? .white : .white // Set the desired color
        }
    }
    
    private func setupRoundedCorners() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func generateRandomBackgroundColor() {
        let randomColor = UIColor(
            red: CGFloat.random(in: 0.1...0.4),
            green: CGFloat.random(in: 0.1...0.4),
            blue: CGFloat.random(in: 0.1...0.4),
            alpha: 1.0
        )
        self.backgroundColor = randomColor
    }
}
