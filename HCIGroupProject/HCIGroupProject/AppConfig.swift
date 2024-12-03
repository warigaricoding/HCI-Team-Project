//
//  AppConfig.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/26/24.
//

class AppConfig {
    // Shared instance
    static let shared = AppConfig(devices: MockDevices().deviceList, deviceGroups: MockDeviceGroup().deviceGroupList)
    
    // Private initializer to restrict instantiation
    private init(devices: [Device], deviceGroups: [DeviceGroup]) {
        self.deviceGroups = deviceGroups
        self.devices = devices
    }
    
    func deviceWithId(id: String) -> Device? {
        return devices.filter { $0.Id == id }.first
    }
    
    func deviceWithName(name: String) -> Device? {
        return devices.filter { $0.name == name }.first
    }
    
    var devices: [Device]
    var deviceGroups: [DeviceGroup]
    // Example properties
    
}
