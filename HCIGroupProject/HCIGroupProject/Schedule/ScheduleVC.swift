//
//  ScheduleVC.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/29/24.
//

import UIKit

protocol ScheduleDelegate: AnyObject {
    func didAddSchedule(_ schedule: Event)
    func didEditSchedule(_ schedule: Event)
}

class ScheduleVC: UIViewController {
    
    // MARK: - Properties
    var deviceOrGroupName: String = ""
    var device: Device? = nil
    var deviceGroup: DeviceGroup? = nil
    weak var delegate: ScheduleDelegate?
    var schedule: Event? = nil

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceGroupNameLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var scheduleNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var timeConstraint: Date? = nil
    var mode: ScheduleVCMode = .edit
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTapGesture()

    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - Configuration
    private func configure() {
        
        titleLabel.text = mode == .add ? "Add Schedule" : "Edit Schedule"
        deviceOrGroupName = device?.name ?? deviceGroup?.name ?? ""
        deviceGroupNameLabel.text = deviceOrGroupName
        scheduleNameTextField.text = schedule?.title.timeline ?? ""
        
        // Configure date and time pickers
        startDatePicker.datePickerMode = .dateAndTime
        endDatePicker.datePickerMode = .time
        
        startDatePicker.minuteInterval = 1
        endDatePicker.minuteInterval = 1
        
        if let schedule = self.schedule {
            startDatePicker.date = schedule.start
            endDatePicker.date = schedule.end
            repeatSwitch.isOn = schedule.recurringType == .everyDay
        }

        // Configure save button
        saveButton.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Combine date and time pickers into single Date objects
        let startDate = startDatePicker.date
        var endDate = endDatePicker.date
        
        // Use Calendar to combine the day of startDate with the time of endDate
        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: endDate)
        
        // Merge day components from startDate with time components from endDate
        startDateComponents.hour = endTimeComponents.hour
        startDateComponents.minute = endTimeComponents.minute
        startDateComponents.second = endTimeComponents.second
        
        guard let newEndDate = calendar.date(from: startDateComponents) else {
            showErrorAlert(message: "Error Time Conversion.")
            return

        }
        endDate = newEndDate

        // Validate time range
        if startDate >= newEndDate {
            showErrorAlert(message: "End time must be later than start time.")
            return
        }
        
        
        if var event = self.schedule {
            
            event.title = TextEvent(timeline: scheduleNameTextField.text ?? "", list: scheduleNameTextField.text ?? "")
            event.deviceName = device?.name ?? deviceGroup?.name ?? ""
            event.start = startDate
            event.end = newEndDate
            event.recurringType = repeatSwitch.isOn ? .everyDay : .none
            event.color = repeatSwitch.isOn ? Event.Color(.systemCyan) : Event.Color(.systemBlue)
            
            self.delegate?.didEditSchedule(event)
        } else {
            
            var event = Event(ID: UUID().uuidString)
            
            event.title = TextEvent(timeline: scheduleNameTextField.text ?? "", list: scheduleNameTextField.text ?? "")
            event.deviceName = device?.name ?? deviceGroup?.name ?? ""
            event.start = startDate
            event.end = newEndDate
            event.recurringType = repeatSwitch.isOn ? .everyDay : .none
            event.color = repeatSwitch.isOn ? Event.Color(.systemCyan) : Event.Color(.systemBlue)
            // Create the schedule event
            
            self.delegate?.didAddSchedule(event)
        }
        

        navigationController?.popViewController(animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

enum ScheduleVCMode {
    case add
    case edit
}
