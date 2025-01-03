//
//  ExpandableCell.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import UIKit

class ExpandableCell: UICollectionViewCell {
    
    @IBOutlet weak var typeCellImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var areaNameLabel: UILabel!
    
    var viewMode: DeviceViewType = .category {
        didSet {
            determineViewMode()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRoundedCorners()
        generateRandomBackgroundColor()
        determineViewMode()
    }
    
    func determineViewMode() {
        if viewMode == .category {
            areaNameLabel.isHidden = true
            categoryNameLabel.isHidden = false
            typeCellImageView.isHidden = false

        } else {
            areaNameLabel.isHidden = false
            typeCellImageView.isHidden = true
            categoryNameLabel.isHidden = true
        }
    }
    
    func configure(deviceCategory category: DeviceCategory) {
        categoryNameLabel.text = category.displayName
        categoryNameLabel.textColor = .white

        // Load image and set rendering mode for tint
        if let image = UIImage(named: category.displayName)?.withRenderingMode(.alwaysTemplate) {
            typeCellImageView.image = image
            typeCellImageView.tintColor = .white // Apply white tint
        }

        // Set content mode to properly scale the image
    }
    func configure(location: String) {
        areaNameLabel.text = location
        areaNameLabel.textColor = .white
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
