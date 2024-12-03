//
//  PDFGenerator.swift
//  HCIGroupProject
//
//  Created by Wha Jong on 11/26/24.
//

import UIKit
import PDFKit
import Charts
import DGCharts

class PDFGenerator {
    func generateUsageStatsPDF() -> UIActivityViewController {
            let devices = AppConfig.shared.devices
            let pdfData = createPDF(devices: devices)
            
            // Save the PDF to a file
            let pdfFilePath = savePDF(data: pdfData)
            
            // Create the Activity View Controller
            let activityVC = UIActivityViewController(activityItems: [pdfFilePath], applicationActivities: nil)
            return activityVC
        }
    
    func createPDF(devices: [Device]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Smart Hub",
            kCGPDFContextAuthor: "Your App",
            kCGPDFContextTitle: "Device Usage Statistics"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth: CGFloat = 595.2 // A4 width
        let pageHeight: CGFloat = 841.8 // A4 height
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Header Title
            let title = "Device Usage Statistics"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            let titleSize = title.size(withAttributes: titleAttributes)
            title.draw(at: CGPoint(x: (pageWidth - titleSize.width) / 2, y: 40), withAttributes: titleAttributes)
            
            // Graph
            let chartView = createGraph(for: devices)
            chartView.frame = CGRect(x: 50, y: 100, width: pageWidth - 100, height: 300)
            chartView.backgroundColor = .white
            
            context.cgContext.translateBy(x: chartView.frame.origin.x, y: chartView.frame.origin.y)
            chartView.layer.render(in: context.cgContext)
            context.cgContext.translateBy(x: -chartView.frame.origin.x, y: -chartView.frame.origin.y)
            
            // Add text description
            let description = "The following graph represents electricity usage across devices."
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ]
            let textRect = CGRect(x: 50, y: 420, width: pageWidth - 100, height: 200)
            description.draw(in: textRect, withAttributes: textAttributes)
        }
        
        return data
    }
    
    func savePDF(data: Data) -> URL {
        let fileName = "DeviceUsageStats.pdf"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
        return fileURL
    }
    
    func createGraph(for devices: [Device]) -> LineChartView {
        let chartView = LineChartView()
        
        // Prepare data entries for the chart
        var dataSets: [LineChartDataSet] = []
        var allDates: [String] = []
        
        for device in devices {
            let entries = device.electricityUsage.enumerated().map { (index, usage) -> ChartDataEntry in
                if !allDates.contains(usage.date) {
                    allDates.append(usage.date)
                }
                let xValue = Double(allDates.firstIndex(of: usage.date) ?? 0)
                return ChartDataEntry(x: xValue, y: usage.usage)
            }
            
            let dataSet = LineChartDataSet(entries: entries, label: device.name)
            dataSet.colors = [UIColor.random()] // Random color for each device
            dataSet.circleColors = [UIColor.random()]
            dataSets.append(dataSet)
        }
        
        let data = LineChartData(dataSets: dataSets)
        chartView.data = data
        
        // Customize x-axis labels to show dates
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: allDates)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45 // Rotate labels for better readability
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false

        // General chart customization
        chartView.rightAxis.enabled = false
        chartView.legend.form = .line
        chartView.drawGridBackgroundEnabled = false
        
        return chartView
    }

    
}
