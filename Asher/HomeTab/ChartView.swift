//
//  ChartView.swift
//  Asher
//
//  Created by chuchu on 7/11/24.
//

import SwiftUI

import DGCharts

struct ChartViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ChartView {
        let chartView = ChartView()
        chartView.chartView.delegate = context.coordinator
        return chartView
    }
    
    func updateUIView(_ uiView: ChartView, context: Context) {
        // Update the view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: ChartViewRepresentable
        var infoView: GraphInfoView?
        var selectedHighlight: Highlight?
        
        init(_ parent: ChartViewRepresentable) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            removeAllInfoView()
            selectedHighlight = highlight
            let infoView = GraphInfoView().then {
                $0.addCornerRadius(radius: 4)
            }
            self.infoView = infoView
            let deviceWidth = UIScreen.main.bounds.width
            let x = min(max(introViewInset, highlight.xPx), deviceWidth - introViewInset)
            
            infoView.backgroundColor = .white
            
            chartView.addSubview(infoView)
            
            infoView.snp.makeConstraints {
                $0.centerX.equalTo(x)
                $0.centerY.equalTo(20)
                $0.width.equalTo(60)
                $0.height.equalTo(40)
            }
        }
        
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            removeAllInfoView()
        }
        
        func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) { }
        
        func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
            guard let highlight = selectedHighlight,
                  let chartView = chartView as? LineChartView else { return }
            
            let transformer = chartView.getTransformer(forAxis: .left)
            let point = transformer.pixelForValues(x: highlight.x, y: highlight.y)
            let deviceWidth = UIScreen.main.bounds.width
            let x = min(max(introViewInset, point.x), deviceWidth - introViewInset)
            
            infoView?.snp.updateConstraints { $0.centerX.equalTo(x) }
        }
        
        private func removeAllInfoView() {
            infoView?.removeFromSuperview()
            infoView = nil
            selectedHighlight = nil
        }
        
        private var introViewInset: CGFloat { 100 / 2 + 8 }
    }
}


import UIKit
import SnapKit


final class ChartView: UIView {
    lazy var chartView = LineChartView().then {
        $0.chartDescription.enabled = false
        $0.dragEnabled = true
        $0.setScaleEnabled(true)
        $0.pinchZoomEnabled = true
        $0.data = testData()
        $0.setVisibleXRangeMaximum(5)
        
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
        
        chartView.moveViewToX(1)
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        addSubview(chartView)
    }
    
    private func setConstraints() {
        chartView.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func testData() -> ChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<20 {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double.random(in: 50...100))
            dataEntries.append(dataEntry)
        }

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

final class GraphInfoView: UIView {
    let infoLabel = UILabel().then {
        $0.text = "24/07/04"
        $0.textColor = .blue
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var moodView = makeMoodView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.addShadow(offset: CGSize(width: 0, height: 2))
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        [infoLabel, moodView].forEach(addSubview)
    }
    
    private func setConstraints() {
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        moodView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    private func makeMoodView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.backgroundColor = .green
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        let array = RandomGenerator.randomMoodArray()
        
        array
            .map(makeLabel)
            .forEach(stackView.addArrangedSubview)
        
        return stackView
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        return label
    }
}

class RandomGenerator {
    static func randomMoodArray() -> [String] {
        var resultArray: [String] = []
        let moodArray: [String] = ["😆" ,"🙂" ,"😐" ,"☹️" ,"🤬" ]
        
        (0...2).forEach { _ in
            let randomBool = Bool.random()
            if randomBool { resultArray.append(moodArray.randomElement() ?? "") }
        }
        
        return resultArray.isEmpty ? ["🐞"]: resultArray
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
