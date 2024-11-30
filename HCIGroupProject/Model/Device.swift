//
//  Device.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/15/24.
//

struct Device {
    var name: String
    var brand: String
    var dateConnected: String
    var modelId: String
    var category: DeviceCategory
    var localLocationId: String // for categorizing by room
    var electricityUsage: [String]
    var customGroupId: String // "-1" for no group
    var relatedDevices: [String]
}

enum DeviceCategory: String, CaseIterable, Comparable {
    case lighting
    /*Smart bulbs
     Smart switches
     LED strips
     Motion sensors*/
    case climateConrol
    /*
     Smart thermostats
     Air conditioners
     Smart fans
     Humidifiers/dehumidifiers
     Air purifiers
     */
    case security
    /*
     Smart cameras (indoor & outdoor)
     Video doorbells
     Smart locks
     Motion detectors
     Window/door sensors
     Sirens/alarms
     */
    case entertainment
    /*
     Smart TVs
     Smart speakers
     Streaming devices
     Home theater systems
     Projectors
     */
    case energyManagement
    /*
     Smart plugs
     Smart meters
     Solar panels
     Battery storage systems
     */
    case appliances
    /*
     Smart refrigerators
     Washing machines
     Dishwashers
     Ovens & microwaves
     Coffee makers
     */
    case waterManagement
    /*
     Smart irrigation systems
     Leak detectors
     Smart water heaters
     */
    case homeAutomation
    /*
     Smart hubs
     Voice assistants (Alexa, Google Assistant)
     Smart remotes
     Sensors (temperature, humidity, occupancy)
     */
    case healthAndWellness
    /*
     Smart scales
     Sleep monitors
     Air quality monitors
     Smart fitness equipment (e.g., treadmills, bikes)
     */
    case cleaningAndMaintenance
    /*
     Robot vacuums/mops
     Lawn mowers
     Smart sprinklers
     */
    
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


class MockDevices {
    let deviceList: [Device] = [
        // Lighting
        Device(
            name: "Smart Bulb",
            brand: "Philips",
            dateConnected: "2024-01-01",
            modelId: "L001",
            category: .lighting,
            localLocationId: "Living Room",
            electricityUsage: ["10W", "15W", "12W"],
            customGroupId: "-1",
            relatedDevices: []
        ),
        
        Device(
            name: "LED Strip",
            brand: "Govee",
            dateConnected: "2024-01-05",
            modelId: "L002",
            category: .lighting,
            localLocationId: "Bedroom",
            electricityUsage: ["5W", "7W"],
            customGroupId: "-1",
            relatedDevices: ["L001"]
        ),
        
        // Climate Control
        Device(
            name: "Smart Thermostat",
            brand: "Nest",
            dateConnected: "2024-02-10",
            modelId: "C001",
            category: .climateConrol,
            localLocationId: "Hallway",
            electricityUsage: ["50W", "40W"],
            customGroupId: "A",
            relatedDevices: []
        ),
        
        Device(
            name: "Air Purifier",
            brand: "Dyson",
            dateConnected: "2024-03-15",
            modelId: "C002",
            category: .climateConrol,
            localLocationId: "Living Room",
            electricityUsage: ["20W"],
            customGroupId: "-1",
            relatedDevices: []
        ),
        
        // Security
        Device(
            name: "Smart Lock",
            brand: "August",
            dateConnected: "2024-04-01",
            modelId: "S001",
            category: .security,
            localLocationId: "Front Door",
            electricityUsage: ["2W"],
            customGroupId: "B",
            relatedDevices: []
        ),
        
        Device(
            name: "Video Doorbell",
            brand: "Ring",
            dateConnected: "2024-05-20",
            modelId: "S002",
            category: .security,
            localLocationId: "Front Door",
            electricityUsage: ["5W"],
            customGroupId: "B",
            relatedDevices: ["S001"]
        ),
        
        // Entertainment
        Device(
            name: "Smart TV",
            brand: "Samsung",
            dateConnected: "2024-06-10",
            modelId: "E001",
            category: .entertainment,
            localLocationId: "Living Room",
            electricityUsage: ["100W", "150W"],
            customGroupId: "C",
            relatedDevices: []
        ),
        
        Device(
            name: "Smart Speaker",
            brand: "Amazon Echo",
            dateConnected: "2024-07-12",
            modelId: "E002",
            category: .entertainment,
            localLocationId: "Bedroom",
            electricityUsage: ["10W"],
            customGroupId: "C",
            relatedDevices: []
        ),
        
        // Appliances
        Device(
            name: "Smart Refrigerator",
            brand: "LG",
            dateConnected: "2024-08-01",
            modelId: "A001",
            category: .appliances,
            localLocationId: "Kitchen",
            electricityUsage: ["200W"],
            customGroupId: "-1",
            relatedDevices: []
        ),
        
        Device(
            name: "Washing Machine",
            brand: "Bosch",
            dateConnected: "2024-09-01",
            modelId: "A002",
            category: .appliances,
            localLocationId: "Laundry Room",
            electricityUsage: ["500W", "300W"],
            customGroupId: "D",
            relatedDevices: []
        )
    ]
}
