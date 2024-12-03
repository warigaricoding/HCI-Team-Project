//
//  Device.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

import Foundation


struct Device {
    var Id: String
    var name: String
    var brand: String
    var dateConnected: String
    var modelId: String
    var category: DeviceCategory
    var localLocationId: String // For categorizing by room
    var electricityUsage: [ElectricityUsage]
    var schedule: [Event] // Replaced DeviceSchedule with Event
}

enum DeviceCategory: String, CaseIterable, Comparable {
    case lighting
    case climateConrol
    case security
    case entertainment
    case energyManagement
    case appliances
    case waterManagement
    case homeAutomation
    case healthAndWellness
    case cleaningAndMaintenance
    
    var displayName: String {
        switch self {
        case .lighting:
            return "Lighting"
        case .climateConrol:
            return "Climate Control"
        case .security:
            return "Security"
        case .entertainment:
            return "Entertainment"
        case .energyManagement:
            return "Energy Management"
        case .appliances:
            return "Appliances"
        case .waterManagement:
            return "Water Management"
        case .homeAutomation:
            return "Home Automation"
        case .healthAndWellness:
            return "Health & Wellness"
        case .cleaningAndMaintenance:
            return "Cleaning & Maintenance"
        }
    }
    
    static func < (lhs: DeviceCategory, rhs: DeviceCategory) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct ElectricityUsage {
    var date: String // Format: "Jan 2024", "Jun 2024", etc.
    var usage: Double // In watts
}

struct DeviceSchedule {
    var scheduleID: String
    var startTime: Date
    var endTime: Date
    var repeatDays: [Date]
    var repeatsDaily: Bool
}

class MockDevices {
    
    var deviceList: [Device] = []
    
    init() {
        // Helper to generate a sample recurring event for each device
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
        
        let deviceList: [Device] = [
            Device(
                Id: "UiOWEfZuZfl1CYF6SX0Z",
                name: "Cleaning Robot",
                brand: "Narwal",
                dateConnected: "2024-01-15",
                modelId: "AE301",
                category: .cleaningAndMaintenance,
                localLocationId: "Living Room",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 150.10),
                    ElectricityUsage(date: "Feb 2024", usage: 160.15),
                    ElectricityUsage(date: "Mar 2024", usage: 140.25),
                    ElectricityUsage(date: "Apr 2024", usage: 155.35),
                    ElectricityUsage(date: "May 2024", usage: 165.45),
                    ElectricityUsage(date: "Jun 2024", usage: 170.55),
                    ElectricityUsage(date: "Jul 2024", usage: 180.30),
                    ElectricityUsage(date: "Aug 2024", usage: 190.70),
                    ElectricityUsage(date: "Sep 2024", usage: 185.80),
                    ElectricityUsage(date: "Oct 2024", usage: 211.80),
                    ElectricityUsage(date: "Nov 2024", usage: 213.00),
                    ElectricityUsage(date: "Dec 2024", usage: 209.80)
                ],
                
                schedule: [generateEvent(for: "Morning Routine", deviceName: "Cleaning Robot", repeatsDaily: true, start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!, end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!)]
            ),Device(
                Id: "UiOCLvZuZfl1CYF6SX0Z",
                name: "Smart Bulb",
                brand: "Philips",
                dateConnected: "2024-01-15",
                modelId: "L001",
                category: .lighting,
                localLocationId: "Living Room",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 150.10),
                    ElectricityUsage(date: "Feb 2024", usage: 160.15),
                    ElectricityUsage(date: "Mar 2024", usage: 140.25),
                    ElectricityUsage(date: "Apr 2024", usage: 155.35),
                    ElectricityUsage(date: "May 2024", usage: 165.45),
                    ElectricityUsage(date: "Jun 2024", usage: 170.55),
                    ElectricityUsage(date: "Jul 2024", usage: 180.30),
                    ElectricityUsage(date: "Aug 2024", usage: 190.70),
                    ElectricityUsage(date: "Sep 2024", usage: 185.80),
                    ElectricityUsage(date: "Oct 2024", usage: 211.80),
                    ElectricityUsage(date: "Nov 2024", usage: 213.00),
                    ElectricityUsage(date: "Dec 2024", usage: 209.80)
                ],
                
                schedule: [generateEvent(for: "Night Time", deviceName: "Smart Bulb", repeatsDaily: true, start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!, end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!)]
            ),
            Device(
                Id: "78Z4NmRvAwa895riPyve",
                name: "LED Strip",
                brand: "Govee",
                dateConnected: "2024-03-10",
                modelId: "L002",
                category: .lighting,
                localLocationId: "Bedroom",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 130.15),
                    ElectricityUsage(date: "Feb 2024", usage: 135.25),
                    ElectricityUsage(date: "Mar 2024", usage: 125.30),
                    ElectricityUsage(date: "Apr 2024", usage: 145.40),
                    ElectricityUsage(date: "May 2024", usage: 155.50),
                    ElectricityUsage(date: "Jun 2024", usage: 160.45),
                    ElectricityUsage(date: "Jul 2024", usage: 175.35),
                    ElectricityUsage(date: "Aug 2024", usage: 185.25),
                    ElectricityUsage(date: "Sep 2024", usage: 170.20),
                    ElectricityUsage(date: "Oct 2024", usage: 111.80),
                    ElectricityUsage(date: "Nov 2024", usage: 182.00),
                    ElectricityUsage(date: "Dec 2024", usage: 124.80)
                ],
                schedule:
                    [generateEvent(for: "Night Time", deviceName: "LED Strip", repeatsDaily: true, start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!, end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!)]
            ),
            Device(
                Id: "9OWarU1Y6yz1SbRfjP2K",
                name: "Smart Thermostat",
                brand: "Nest",
                dateConnected: "2024-01-01",
                modelId: "C001",
                category: .climateConrol,
                localLocationId: "Hallway",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 400.10),
                    ElectricityUsage(date: "Feb 2024", usage: 420.15),
                    ElectricityUsage(date: "Mar 2024", usage: 430.25),
                    ElectricityUsage(date: "Apr 2024", usage: 410.35),
                    ElectricityUsage(date: "May 2024", usage: 405.45),
                    ElectricityUsage(date: "Jun 2024", usage: 395.55),
                    ElectricityUsage(date: "Jul 2024", usage: 415.30),
                    ElectricityUsage(date: "Aug 2024", usage: 420.70),
                    ElectricityUsage(date: "Sep 2024", usage: 405.80),
                    ElectricityUsage(date: "Oct 2024", usage: 435.80),
                    ElectricityUsage(date: "Nov 2024", usage: 433.00),
                    ElectricityUsage(date: "Dec 2024", usage: 405.80)
                ],
                
                schedule:
                    [generateEvent(
                                for: "Daily Schedule",
                                deviceName: "Smart Thermostat",
                                repeatsDaily: true,
                                start: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!,
                                end: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
                            )]
            ),
            Device(
                Id: "Zymy1VZ8gOJnMcFYv1aU",
                name: "Air Purifier",
                brand: "Air Mega",
                dateConnected: "2024-02-20",
                modelId: "C002",
                category: .climateConrol,
                localLocationId: "Living Room",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 250.10),
                    ElectricityUsage(date: "Feb 2024", usage: 260.15),
                    ElectricityUsage(date: "Mar 2024", usage: 245.25),
                    ElectricityUsage(date: "Apr 2024", usage: 235.35),
                    ElectricityUsage(date: "May 2024", usage: 240.45),
                    ElectricityUsage(date: "Jun 2024", usage: 230.55),
                    ElectricityUsage(date: "Jul 2024", usage: 225.30),
                    ElectricityUsage(date: "Aug 2024", usage: 240.70),
                    ElectricityUsage(date: "Sep 2024", usage: 235.80),
                    ElectricityUsage(date: "Oct 2024", usage: 215.80),
                    ElectricityUsage(date: "Nov 2024", usage: 243.00),
                    ElectricityUsage(date: "Dec 2024", usage: 205.80)
                ],
                
                schedule: [
                        generateEvent(
                            for: "Evening Run",
                            deviceName: "Air Purifier",
                            repeatsDaily: true,
                            start: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!,
                            end: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
                        )
                    ]
            ),
            Device(
                Id: "FLQOsaJrXQQefvebXUpA",
                name: "Smart Lock",
                brand: "August",
                dateConnected: "2024-06-15",
                modelId: "S001",
                category: .security,
                localLocationId: "Front Door",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 30.10),
                    ElectricityUsage(date: "Feb 2024", usage: 35.15),
                    ElectricityUsage(date: "Mar 2024", usage: 25.25),
                    ElectricityUsage(date: "Apr 2024", usage: 20.35),
                    ElectricityUsage(date: "May 2024", usage: 28.45),
                    ElectricityUsage(date: "Jun 2024", usage: 30.55),
                    ElectricityUsage(date: "Jul 2024", usage: 25.30),
                    ElectricityUsage(date: "Aug 2024", usage: 35.70),
                    ElectricityUsage(date: "Sep 2024", usage: 28.80),
                    ElectricityUsage(date: "Oct 2024", usage: 35.80),
                    ElectricityUsage(date: "Nov 2024", usage: 12.00),
                    ElectricityUsage(date: "Dec 2024", usage: 1.80)
                ],
                
                schedule: [
                        generateEvent(
                            for: "Auto-Lock Time Interval",
                            deviceName: "Smart Lock",
                            repeatsDaily: true,
                            start: Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!,
                            end: Calendar.current.date(bySettingHour: 23, minute: 5, second: 0, of: Date())!
                        )
                    ]
            ),
            Device(
                Id: "FfITYUPMb8Cooxk124D7",
                name: "Video Doorbell",
                brand: "Ring",
                dateConnected: "2024-05-10",
                modelId: "S002",
                category: .security,
                localLocationId: "Front Door",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 50.20),
                    ElectricityUsage(date: "Feb 2024", usage: 55.35),
                    ElectricityUsage(date: "Mar 2024", usage: 45.25),
                    ElectricityUsage(date: "Apr 2024", usage: 50.30),
                    ElectricityUsage(date: "May 2024", usage: 48.45),
                    ElectricityUsage(date: "Jun 2024", usage: 52.55),
                    ElectricityUsage(date: "Jul 2024", usage: 60.10),
                    ElectricityUsage(date: "Aug 2024", usage: 58.20),
                    ElectricityUsage(date: "Sep 2024", usage: 53.45),
                    ElectricityUsage(date: "Oct 2024", usage: 15.80),
                    ElectricityUsage(date: "Nov 2024", usage: 43.00),
                    ElectricityUsage(date: "Dec 2024", usage: 20.80)
                ],
                schedule: []
            ),
            Device(
                Id: "98CD1E0Q1bQLUay0Ix7i",
                name: "Smart Refrigerator",
                brand: "LG",
                dateConnected: "2024-04-05",
                modelId: "A001",
                category: .appliances,
                localLocationId: "Kitchen",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 300.10),
                    ElectricityUsage(date: "Feb 2024", usage: 310.15),
                    ElectricityUsage(date: "Mar 2024", usage: 290.25),
                    ElectricityUsage(date: "Apr 2024", usage: 305.35),
                    ElectricityUsage(date: "May 2024", usage: 315.45),
                    ElectricityUsage(date: "Jun 2024", usage: 320.55),
                    ElectricityUsage(date: "Jul 2024", usage: 310.30),
                    ElectricityUsage(date: "Aug 2024", usage: 325.70),
                    ElectricityUsage(date: "Sep 2024", usage: 305.80),
                    ElectricityUsage(date: "Oct 2024", usage: 315.80),
                    ElectricityUsage(date: "Nov 2024", usage: 343.00),
                    ElectricityUsage(date: "Dec 2024", usage: 285.80)
                ],
                
                schedule: [
                    generateEvent(
                        for: "Cooling Schedule",
                        deviceName: "Smart Refrigerator",
                        repeatsDaily: true,
                        start: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!,
                        end: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!
                    ),
                    generateEvent(
                        for: "Energy Saving Mode",
                        deviceName: "Smart Refrigerator",
                        repeatsDaily: true,
                        start: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!,
                        end: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!
                    )
                ]
            ),
            Device(
                Id: "HXNnEcT219sUl9QeqIQk",
                name: "Smart Speaker",
                brand: "Amazon Echo",
                dateConnected: "2024-08-20",
                modelId: "E001",
                category: .entertainment,
                localLocationId: "Living Room",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 100.25),
                    ElectricityUsage(date: "Feb 2024", usage: 105.30),
                    ElectricityUsage(date: "Mar 2024", usage: 95.20),
                    ElectricityUsage(date: "Apr 2024", usage: 110.15),
                    ElectricityUsage(date: "May 2024", usage: 120.50),
                    ElectricityUsage(date: "Jun 2024", usage: 125.45),
                    ElectricityUsage(date: "Jul 2024", usage: 115.35),
                    ElectricityUsage(date: "Aug 2024", usage: 130.25),
                    ElectricityUsage(date: "Sep 2024", usage: 120.40),
                    ElectricityUsage(date: "Oct 2024", usage: 115.80),
                    ElectricityUsage(date: "Nov 2024", usage: 143.00),
                    ElectricityUsage(date: "Dec 2024", usage: 105.80)
                ],
                
                schedule: []
            ),
            Device(
                Id: "NGpQEyWgv2mUeSdCVCGk",
                name: "Smart TV",
                brand: "Samsung",
                dateConnected: "2024-07-15",
                modelId: "E002",
                category: .entertainment,
                localLocationId: "Bedroom",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 200.35),
                    ElectricityUsage(date: "Feb 2024", usage: 210.40),
                    ElectricityUsage(date: "Mar 2024", usage: 190.25),
                    ElectricityUsage(date: "Apr 2024", usage: 205.35),
                    ElectricityUsage(date: "May 2024", usage: 220.45),
                    ElectricityUsage(date: "Jun 2024", usage: 230.55),
                    ElectricityUsage(date: "Jul 2024", usage: 215.30),
                    ElectricityUsage(date: "Aug 2024", usage: 235.70),
                    ElectricityUsage(date: "Sep 2024", usage: 225.80),
                    ElectricityUsage(date: "Oct 2024", usage: 215.80),
                    ElectricityUsage(date: "Nov 2024", usage: 243.00),
                    ElectricityUsage(date: "Dec 2024", usage: 205.80)
                ],
                schedule: [
                        generateEvent(
                            for: "Movie Night",
                            deviceName: "Smart TV",
                            repeatsDaily: false,
                            start: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!,
                            end: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
                        )
                    ]
            ),
            Device(
                Id: "ZPzE9az1tqDC8cZppRSl",
                name: "Washing Machine",
                brand: "Bosch",
                dateConnected: "2024-11-10",
                modelId: "A002",
                category: .appliances,
                localLocationId: "Laundry Room",
                electricityUsage: [
                    ElectricityUsage(date: "Jan 2024", usage: 400.45),
                    ElectricityUsage(date: "Feb 2024", usage: 410.55),
                    ElectricityUsage(date: "Mar 2024", usage: 395.35),
                    ElectricityUsage(date: "Apr 2024", usage: 405.25),
                    ElectricityUsage(date: "May 2024", usage: 420.35),
                    ElectricityUsage(date: "Jun 2024", usage: 430.45),
                    ElectricityUsage(date: "Jul 2024", usage: 410.30),
                    ElectricityUsage(date: "Aug 2024", usage: 425.70),
                    ElectricityUsage(date: "Sep 2024", usage: 415.80),
                    ElectricityUsage(date: "Oct 2024", usage: 415.80),
                    ElectricityUsage(date: "Nov 2024", usage: 350.00),
                    ElectricityUsage(date: "Dec 2024", usage: 415.80)
                ],
                
                schedule: []
            )
        ]
        self.deviceList = deviceList
        
    }
}
