//
//  FilpClockEffectView.swift
//  Asher
//
//  Created by chuchu on 6/26/24.
//

import SwiftUI

struct FlipClockEffectView: View {
  var size: CGSize
  var fontSize: CGFloat
  var design: FlipClockEffectView.Design
  
  var body: some View {
    ZStack {
      makeRectangleView(position: .up(design))
      makeRectangleView(position: .down(design))
    }
    .frame(size: size)
  }
  
  @ViewBuilder
  private func makeRectangleView(position: FlipClockEffectView.Position) -> some View {
    let halfHeight = size.height * 0.5
    let isUp = position == .up
    ZStack {
      UnevenRoundedRectangle(
        topLeadingRadius: position.topRadius,
        bottomLeadingRadius: position.bottomRadius,
        bottomTrailingRadius: position.bottomRadius,
        topTrailingRadius: position.topRadius)
      .fill(isUp ? .border: .red)
//      .fill(position == .up() ? .background: .background.shadow(.inner(radius: 1)))
      .frame(height: halfHeight)
      .frame(maxHeight: .infinity, alignment: position.alignment)
    }
  }
}

extension FlipClockEffectView {
  struct Design {
    var cornerRadius: CGFloat
    var foreground: Color
    var background: Color
  }
  enum Position {
    case up(FlipClockEffectView.Design)
    case down(FlipClockEffectView.Design)
    
    var topRadius: CGFloat {
      switch self {
      case .up(let design): design.cornerRadius
      case .down(_): 0
      }
    }
    
    var bottomRadius: CGFloat {
      switch self {
      case .up(_): 0
      case .down(let design): design.cornerRadius
      }
    }
    
    var alignment: Alignment {
      switch self {
      case .up(_): .top
      case .down(_): .bottom
      }
    }
    
    @ViewBuilder
    var background: some View {
      switch self {
      case .up(let design): design.background
      case .down(let design): design.background.overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.black, lineWidth: 1)
          .shadow(radius: 1))
      }
    }
  }
}

#Preview {
  FlipClockEffectView(
    size: CGSize(width: 100, height: 150),
    fontSize: 70,
    design: FlipClockEffectView.Design(cornerRadius: 10, foreground: .white, background: .red)
  )
}

extension View {
  func frame(size: CGSize, alignment: Alignment = .center) -> some View {
    self.frame(width: size.width, height: size.height, alignment: alignment)
  }
}
