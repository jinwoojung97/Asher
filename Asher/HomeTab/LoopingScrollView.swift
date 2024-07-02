//
//  LoopingScrollView.swift
//  Asher
//
//  Created by chuchu on 6/19/24.
//

import SwiftUI

struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var width: CGFloat
    var spacing: CGFloat = 0.0
    var items: Item
    @ViewBuilder var content: (Item.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            // 안전성 체크
            let repaetingCount = width > 0 ?  Int((size.width / width).rounded()) + 1: 1
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .padding([.horizontal, .vertical], spacing)
                            .frame(width: width)
                    }
                    
                    ForEach(0..<repaetingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .padding([.horizontal, .vertical], spacing)
                            .frame(width: width)
                    }
                }
                .background {
                    ScrollViewHelper(
                        width: width,
                        spacing: spacing,
                        itemsCount: items.count,
                        repeatingCount: repaetingCount)
                }
            }
        }
    }
}

import Combine

fileprivate struct ScrollViewHelper: UIViewRepresentable {
    var width: CGFloat
    var spacing: CGFloat
    var itemsCount: Int
    var repeatingCount: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            width: width,
            spacing: spacing,
            itemsCount: itemsCount,
            repeatingCount: repeatingCount)
    }
    
    func makeUIView(context: Context) -> UIView { .init() }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView,
                !context.coordinator.isAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.scrollView = scrollView
                context.coordinator.isAdded = true
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemsCount: Int
        var repeatingCount: Int
        var isAdded: Bool = false
        var scrollView: UIScrollView?
        var timer: AnyCancellable?
        
        init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemsCount = itemsCount
            self.repeatingCount = repeatingCount
            
            super.init()
            startTimer()
        }
        
        private func startTimer() {
            timer = Timer.publish(every: 5, on: .main, in: .common)
                .autoconnect()
                .sink(receiveValue: { [weak self] _ in self?.autoScroll() })
        }
        
        private func stopTimer() {
            timer?.cancel()
            timer = nil
        }
        
        private func autoScroll() {
            guard let scrollView else { return }
            
            let mainContentSize = CGFloat(itemsCount) * (width - spacing)
            let targetOffsetX = scrollView.contentOffset.x + width
            
            if scrollView.contentOffset.x > CGFloat(itemsCount) * (width - spacing) {
                print("cehck scrollView")
                scrollView.contentOffset.x = 0
            }
            
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset.x = targetOffsetX
            }
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let minX = scrollView.contentOffset.x
            let mainContentSize = CGFloat(itemsCount) * (width - spacing)
            let spacingSize = CGFloat(itemsCount) * spacing
            
            if minX > (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= mainContentSize + spacingSize
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += mainContentSize + spacingSize
            }
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { stopTimer() }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate { startTimer()}
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { startTimer() }
     }
}

