//
//  ChartView.swift
//  Asher
//
//  Created by chuchu on 7/11/24.
//

import SwiftUI

import DGCharts
import SnapKit


final class ChartView: UIView {
    lazy var chartView = LineChartView().then {
        $0.chartDescription.enabled = false
        $0.dragEnabled = false
        $0.setScaleEnabled(true)
        $0.pinchZoomEnabled = true
        $0.data = testData()
        $0.setVisibleXRangeMaximum(10)
        $0.maxVisibleCount = 10
        $0.viewPortHandler.setMaximumScaleX(1.5)
        
        $0.gridBackgroundColor = .red
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.drawAxisLineEnabled = false
        $0.xAxis.drawLabelsEnabled = false
        $0.leftAxis.drawAxisLineEnabled = false
        $0.rightAxis.enabled = false
        $0.leftAxis.axisMinimum = 0
        $0.leftAxis.axisMaximum = 100
        $0.doubleTapToZoomEnabled = false
        $0.rightAxis.drawAxisLineEnabled = false
        $0.legend.enabled = false
        $0.leftAxis.valueFormatter = EmojiValueFormatter()
    }
    
    var infoView: GraphInfoView?
    var selectedHighlight: Highlight?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let test = DatabaseManager.shared.fetchChartItems()
            .sorted { $0.index < $1.index }
            .map { ChartDataEntry(x: $0.index, y: $0.score, data: $0) }
            .last
        
        if let test {
            chartView.moveViewToX(test.x)
        }
    }
    
    func updateChart() { chartView.data = testData() }
    
    private func commonInit() {
        self.backgroundColor = .main1
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        addSubview(chartView)
    }
    
    private func setConstraints() {
        chartView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(320)
        }
    }
    
    private func testData() -> ChartData {
        guard !DatabaseManager.shared.fetchChartItems().isEmpty else { return ChartData() }
        var dataEntries: [ChartDataEntry] = []
        let chartData = DatabaseManager.shared.fetchChartItems()
            .sorted { $0.index < $1.index }
            .map { ChartDataEntry(x: $0.index, y: $0.score, data: $0) }
        
        dataEntries = chartData

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Sample Data")
        
        let gradientColors: [CGColor] = [UIColor(red: 85/255, green: 170/255, blue: 1, alpha: 0.5).cgColor,
                                         UIColor.red.withAlphaComponent(0.5).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        lineChartDataSet.lineWidth = 1
        lineChartDataSet.label = nil
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.setColor(.purple)
        lineChartDataSet.setCircleColor(.purple)
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        lineChartDataSet.drawFilledEnabled = true
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        return lineChartData
    }
}




class EmojiValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 80..<100: return "😆"
        case 60..<80: return "🙂"
        case 40..<60: return "😐"
        case 20..<40: return "☹️"
        case 0..<20: return "🤬"
        default: return ""
        }
    }
}
