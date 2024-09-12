//
//  ToastTextView.swift
//  Asher
//
//  Created by chuchu on 9/12/24.
//

import SwiftUI
import UIKit

struct ToastLayerView<Content: View>: View {
  @ViewBuilder var content: Content
  @State private var overlayWindow: UIWindow?
  
  var body: some View {
    content.onAppear {
      if let windowScene = UIApplication.shared.window?.windowScene,
         overlayWindow == nil {
        let window = PassthrougWindow(windowScene: windowScene)
        let rootController = UIHostingController(rootView: ToastGroup())
        rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
        rootController.view.backgroundColor = .clear
        
        window.backgroundColor = .clear
        window.rootViewController = rootController
        window.isHidden = false
        window.isUserInteractionEnabled = true
        window.tag = 100
        
        overlayWindow = window
      }
    }
  }
}

fileprivate class PassthrougWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let view = super.hitTest(point, with: event) else { return nil }
    
    return rootViewController?.view == view ? nil: view
  }
}

class Toast: ObservableObject {
  static let shared = Toast()
  @Published fileprivate var toasts: [ToastItem] = []
  
  func present(toastItem: ToastItem) {
    withAnimation(.snappy) {
      toasts.append(toastItem)
    }
  }
}

struct ToastItem: Identifiable {
  let id: UUID = .init()
  var title: String
  var symbol: String?
  var tint: Color = .primary
  var isUserInteractionEnabled: Bool = false
  var timing: ToastTime = .medium
  
}

enum ToastTime: CGFloat {
  case short = 1.5
  case medium = 2.5
  case long = 3.5
}

fileprivate struct ToastGroup: View {
  @ObservedObject var model = Toast.shared
  
  var body: some View {
    GeometryReader {
      let size = $0.size
      let safeArea = $0.safeAreaInsets
      
      
      ZStack {
        ForEach(model.toasts) { toast in
          ToastView(size: size, item: toast)
            .scaleEffect(scale(toast))
            .offset(y: offsetY(toast))
            .shadow(color: .primary.opacity(0.1), radius: 5, x: 0, y: 5)
            .shadow(color: .primary.opacity(0.1), radius: 5, x: 0, y: -5)
            .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
        }
      }
      .padding(.bottom, safeArea.top == .zero ? 32: 24)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
  }
  
  private func offsetY(_ item: ToastItem) -> CGFloat {
    let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
    let totalCount = CGFloat(model.toasts.count) - 1
    let currentCount = totalCount - index
    return currentCount >= 2 ? -20: currentCount * -10
  }
  
  private func scale(_ item: ToastItem) -> CGFloat {
    let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
    let totalCount = CGFloat(model.toasts.count) - 1
    let currentCount = totalCount - index
    return 1.0 - (currentCount >= 2 ? 0.2: currentCount * 0.1)
  }
}

fileprivate struct ToastView: View {
  var size: CGSize
  var item: ToastItem
  @State private var animateIn: Bool = false
  @State private var animateOut: Bool = false
  var body: some View {
    HStack(spacing: 0) {
      if let symbol = item.symbol {
        Image(systemName: symbol)
          .font(.title3)
      }
      
      Text(item.title).foregroundStyle(.black)
    }
    .foregroundStyle(.white)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(.white)
    .clipShape(.capsule)
    .onTapGesture { removeToast() }
    .gesture(
      DragGesture(minimumDistance: 0)
        .onEnded({ value in
          let endY = value.translation.height
          let velocityY = value.velocity.height
          
          if endY + velocityY > 100 { removeToast() }
        })
    )
    
    .task {
      try? await Task.sleep(for: .seconds(item.timing.rawValue))
      
      removeToast()
    }
    .frame(maxWidth: size.width * 0.7)
    .transition(.offset(y: 150))
  }
  
  private func removeToast() {
    withAnimation(.snappy) {
      removeToastItem()
    }
  }
  
  private func removeToastItem() { Toast.shared.toasts.removeAll { $0.id == item.id } }
}
