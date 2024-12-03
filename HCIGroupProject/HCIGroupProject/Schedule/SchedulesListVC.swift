//
//  SchedulesListVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit
import Foundation

class SchedulesListVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var deviceOrGroupNameLabel: UILabel!
    @IBOutlet weak var addScheduleButton: UIButton!
    @IBOutlet weak var schedulesTableView: UITableView!

    // MARK: - Properties
    var deviceOrGroupName: String = "" // Name of the device group
    var schedules: [Event] = [] // Array of schedules
    var device: Device? = nil
    var deviceGroup: DeviceGroup? = nil
    
    var parentVC: UIViewController? = nil
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        initUI()
        schedulesTableView.dataSource = self // Set TableView data source
        schedulesTableView.delegate = self // Set TableView delegate
    }
    
    // MARK: - Configuration
    private func configure() {
        deviceOrGroupNameLabel.text = deviceOrGroupName
        loadSchedules()
        schedulesTableView.reloadData()
    }
    
    private func loadSchedules() {
        if let device = device {
            schedules = device.schedule
        }
        if let deviceGroup = deviceGroup {
            schedules = deviceGroup.schedule
        }
    }
    
    private func initUI() {
//        schedulesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
    }
    
    // MARK: - Actions
    @IBAction func addScheduleTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let scheduleVC = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as? ScheduleVC else {
            return
        }
        
        // Configure modal presentation style
        scheduleVC.deviceOrGroupName = deviceOrGroupName
        scheduleVC.delegate = self
        scheduleVC.mode = .add
        if let device = self.device {
            scheduleVC.device = device
        }
        if let group = self.deviceGroup {
            scheduleVC.deviceGroup = group
        }
        
        // Present the modal
        self.navigationController?.pushViewController(scheduleVC, animated: true)
    }
    
    func scheduleTimeString(start: Date, end: Date, isRepeatable: Bool) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // Format for hours and minutes with AM/PM
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E" // Short day name (e.g., Mon, Tue)
        
        let startString = timeFormatter.string(from: start)
        let endString = timeFormatter.string(from: end)
        let dayString = dayFormatter.string(from: start)
        
        if isRepeatable {
            return "\(startString) to \(endString)" // Repeatable schedule
        } else {
            return "\(startString) to \(endString) \(dayString)" // Non-repeatable schedule
        }
    }
}

// MARK: - UITableViewDataSource
extension SchedulesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        
        let schedule = schedules[indexPath.row]
        
        let scheduleStr = scheduleTimeString(start: schedule.start, end: schedule.end, isRepeatable: schedule.recurringType == .everyDay)
        cell.scheduleTime = scheduleStr
        cell.configure(with: schedule)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SchedulesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSchedule = schedules[indexPath.row]
        print("Selected schedule: \(selectedSchedule)")
        
        editSchedule(schedule: selectedSchedule)
        
        
        // Optionally navigate to a detailed schedule view
    }
    
    private func editSchedule(schedule: Event) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let scheduleVC = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as? ScheduleVC else {
            return
        }
        
        scheduleVC.deviceOrGroupName = deviceOrGroupName
        scheduleVC.delegate = self
        scheduleVC.mode = .edit
        if let device = self.device {
            scheduleVC.device = device
        }
        if let group = self.deviceGroup {
            scheduleVC.deviceGroup = group
        }
        scheduleVC.schedule = schedule
        
        // Present the modal
        self.navigationController?.pushViewController(scheduleVC, animated: true)
    }
    
    // Add trailing swipe actions for deleting a schedule
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Remove the schedule from the list
            self.schedules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Notify completion
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        // Create the configuration with the action
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - AddScheduleDelegate
extension SchedulesListVC: ScheduleDelegate {
    func didAddSchedule(_ schedule: Event) {
        schedules.append(schedule)
        schedulesTableView.reloadData()
    }
    
    func didEditSchedule(_ schedule: Event) {
        if let index = schedules.firstIndex(where: { $0.ID == schedule.ID }) {
                schedules[index] = schedule // Replace the old schedule with the edited one
            }
            schedulesTableView.reloadData()
        }
}

class ScheduleTableViewCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var scheduleNameLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var scheduleTime: String = ""
    
    // MARK: - Cell Configuration
    func configure(with schedule: Event) {
        scheduleNameLabel.text = schedule.title.timeline
        deviceNameLabel.text = schedule.deviceName
        scheduleTimeLabel.text = scheduleTime
        typeLabel.text = schedule.recurringType == .everyDay ? "Repeat Daily" : ""
    }
    
    // Optional: Handle reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        deviceNameLabel.text = nil
        scheduleTimeLabel.text = nil
        typeLabel.text = nil
    }
}

