//
//  ChartViewRepresentable.swift
//  Asher
//
//  Created by chuchu on 7/15/24.
//

import SwiftUI

import DGCharts

struct ChartViewRepresentable: UIViewRepresentable {
    @Binding var updateSignal: UUID
    func makeUIView(context: Context) -> ChartView {
        let chartView = ChartView()
        chartView.chartView.delegate = context.coordinator
        return chartView
    }
    
    func updateUIView(_ uiView: ChartView, context: Context) {
        uiView.updateChart()
        uiView.chartView.notifyDataSetChanged()
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
            let infoView = GraphInfoView(data: entry.data as? DatabaseManager.ChartInfo)
            self.infoView = infoView
            let deviceWidth = UIScreen.main.bounds.width
            let x = min(max(introViewInset, highlight.xPx), deviceWidth - introViewInset)
            
            chartView.addSubview(infoView)
            
            infoView.snp.makeConstraints {
                $0.centerX.equalTo(x)
                $0.centerY.equalTo(20)
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
