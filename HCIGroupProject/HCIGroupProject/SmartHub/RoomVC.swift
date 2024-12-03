//
//  RoomVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

class RoomVC: UIViewController {
    
    var roomText = ""
    @IBOutlet weak var deviceRoomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        deviceRoomLabel.text = roomText
    }
}
