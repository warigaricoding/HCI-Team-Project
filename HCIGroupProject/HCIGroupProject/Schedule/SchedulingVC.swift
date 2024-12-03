//
//  SchedulingVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/26/24.
//

import UIKit
import SwiftDate
import EventKit



final class SchedulingVC: UIViewController {
    
    @IBOutlet weak var toggleSchedulViewBtn: UIButton!
    
    @IBOutlet weak var calendarVCContainerView: UIView!
    
    
    
    var calendarVC: CalendarVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataDidUpdate(_:)), name: .dataDidUpdate, object: nil)

        toggleSchedulViewBtn.applyRoundedStyle(cornerRadius: 10)
        toggleSchedulViewBtn.setTitle("  Day", for: .normal)
        toggleSchedulViewBtn.clipsToBounds = true

        view.bringSubviewToFront(toggleSchedulViewBtn)
        // Find CalendarVC from children
        if let childVC = children.first(where: { $0 is CalendarVC }) as? CalendarVC {
            calendarVC = childVC
        }
        
        
        makeStickieBtn()
    }
    
    private func makeStickieBtn() {
        let stickyButton = UIButton(type: .system)
           stickyButton.setTitle("+", for: .normal)
            stickyButton.titleLabel?.font = UIFont.systemFont(ofSize: 40) // Set font size
           stickyButton.backgroundColor = .systemBlue
           stickyButton.setTitleColor(.white, for: .normal)
           stickyButton.layer.cornerRadius = 10
           stickyButton.translatesAutoresizingMaskIntoConstraints = false
        stickyButton.titleEdgeInsets = UIEdgeInsets(top: -2.5, left: 0, bottom: 5, right: 0) // Moves the text higher

           // Add action
           stickyButton.addTarget(self, action: #selector(stickyButtonTapped), for: .touchUpInside)
           
           // Add to the view
           view.addSubview(stickyButton)
           
           // Add constraints
        NSLayoutConstraint.activate([
            stickyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stickyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stickyButton.widthAnchor.constraint(equalToConstant: 50), // Adjust width
            stickyButton.heightAnchor.constraint(equalToConstant: 50) // Adjust height
        ])
    }
    
    @objc private func stickyButtonTapped() {
        print("Sticky button tapped")
        Utils().promptAlert(vc: self, title: "To Do", message: "Not yet implemented", actions: [.ok])
    }
    
    @IBAction func toggleSchedulViewBtnPressed(_ sender: UIButton) {
        
//        sender.isUserInteractionEnabled = false

        print("Toggle button pressed")
        if calendarVC?.calendarView.selectedType == .day {
            toggleSchedulViewBtn.setTitle("  Week", for: .normal)
        } else {
            toggleSchedulViewBtn.setTitle("  Day", for: .normal)
        }
        Utils().updateUIForAPICall(vc: self, on: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.calendarVC?.handleToggle()
            }
        })
        
        
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//            sender.isUserInteractionEnabled = true
//        }
    }
    
    @objc private func handleDataDidUpdate(_ notification: Notification) {
        Utils().updateUIForAPICall(vc: self, on: false, completion: {})
    }
    
    deinit {
        // Remove observer when the object is deallocated
        NotificationCenter.default.removeObserver(self, name: .dataDidUpdate, object: nil)
    }
}

extension Notification.Name {
    static let dataDidUpdate = Notification.Name("dataDidUpdate")
}

