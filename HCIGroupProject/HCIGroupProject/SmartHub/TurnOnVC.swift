//
//  TurnOnVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

class TurnOnVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    
    var toggle: Bool = false {
        didSet {
            toggleBtnText(toggle: self.toggle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        startBtn.applyRoundedStyle()
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        var str = ["", ""]
        Utils().updateUIForAPICall(vc: self, on: true, completion: {})
        if !toggle {
            str = ["Initiated","Device successfully started"]
        } else {
            str = ["Stopped","Device successfully finished running"]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let wself = self else { return }
            
            Utils().updateUIForAPICall(vc: wself, on: false, completion: {
                Utils().promptAlert(vc: wself, title: str.first ?? "", message: str.last ?? "", actions: [.ok])
                wself.toggle = !wself.toggle
            })
        }
        
    }
    
    private func toggleBtnText(toggle: Bool) {
        var configuration = UIButton.Configuration.plain()
        
        if toggle {
            configuration.title = "Turn Off"
            configuration.attributedTitle = AttributedString("Turn Off", attributes: AttributeContainer([.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]))
        } else {
            configuration.title = "Start"
            configuration.attributedTitle = AttributedString("Start", attributes: AttributeContainer([.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]))
        }
        startBtn.configuration = configuration

        
    }
    
}
