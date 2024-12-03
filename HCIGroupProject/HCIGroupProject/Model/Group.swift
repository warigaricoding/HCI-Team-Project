//
//  Group.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/27/24.
//

import Foundation

struct DeviceGroup {
    var Id: String
    var name: String
    var deviceIds: [String]
    var schedule: [Event]
    var localLocationId: String
}

class MockDeviceGroup {
    
    var deviceGroupList: [DeviceGroup] = []
    
    init() {
        
        func generateEvent(for title: String, deviceName: String, repeatsDaily: Bool, start: Date? = nil, end: Date? = nil) -> Event {
            let startTime = start ?? Date() // Default to now if no start time is provided
            let endTime = end ?? Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? startTime.addingTimeInterval(3600) // Default to 1 hour later
            
            var event = Event(ID: UUID().uuidString)
            event.title = TextEvent(timeline: title)
            event.deviceName = deviceName
            event.start = startTime
            event.end = endTime
            event.recurringType = repeatsDaily ? .everyDay : .none
            event.color = repeatsDaily ? Event.Color(.systemCyan) : Event.Color(.systemBlue)
            return event
        }
        
        let deviceGroupList: [DeviceGroup] = [
            DeviceGroup(Id: "ZNAzMmALWvAngna2SRcn", name: "Lightings", deviceIds: [
                "78Z4NmRvAwa895riPyve", "UiOCLvZuZfl1CYF6SX0Z"
            ], schedule: [generateEvent(for: "Night Time", deviceName: "Lightings", repeatsDaily: true, start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!, end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!)], localLocationId: "Upstairs"),
            DeviceGroup(Id: "Yne6DaxhHp0452iusHhk", name: "Devices Downstairs", deviceIds: [
                "Zymy1VZ8gOJnMcFYv1aU", "FLQOsaJrXQQefvebXUpA"
            ], schedule: [generateEvent(for: "Downstairs Checkup", deviceName: "Devices Downstairs", repeatsDaily: true, start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!, end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!)], localLocationId: "Downstairs")
            
        ]
        
        self.deviceGroupList = deviceGroupList
    }
}
