//
//  FilpClockEffectView.swift
//  Asher
//
//  Created by chuchu on 6/26/24.
//

import SwiftUI

struct FlipClockEffectView: View {
  @Binding var value: Int
  var size: CGSize
  var fontSize: CGFloat
  var cornerRadius: CGFloat
  var foreground: Color
  var background: Color
  var animationDuration: CGFloat = 0.8
  
  @State private var nextValue: Int = 0
  @State private var currentValue: Int = 0
  @State private var rotation: CGFloat = 0
  
  var body: some View {
    makeRectangleView()
  }
  
  @ViewBuilder
  private func makeRectangleView() -> some View {
    let halfHeight = size.height * 0.5
    let up = FlipClockEffectView.Position.up
    let down = FlipClockEffectView.Position.down
    
    ZStack {
      UnevenRoundedRectangle(
        topLeadingRadius: up.getTopRadius(cornerRadius),
        bottomLeadingRadius: up.getBottomRadius(cornerRadius),
        bottomTrailingRadius: up.getBottomRadius(cornerRadius),
        topTrailingRadius: up.getTopRadius(cornerRadius))
      .fill(background.shadow(.inner(radius: 1)))
      .frame(height: halfHeight)
      .overlay(alignment: .top) {
        textView(nextValue)
          .frame(size: size)
          .drawingGroup()
      }
      .clipped()
      .frame(maxHeight: .infinity, alignment: .top)
      
      UnevenRoundedRectangle(
        topLeadingRadius: up.getTopRadius(cornerRadius),
        bottomLeadingRadius: up.getBottomRadius(cornerRadius),
        bottomTrailingRadius: up.getBottomRadius(cornerRadius),
        topTrailingRadius: up.getTopRadius(cornerRadius))
      .fill(background.shadow(.inner(radius: 1)))
      .frame(height: halfHeight)
      .modifier(
        RotationModifier(
          rotation: rotation,
          currentValue: currentValue,
          nextValue: nextValue,
          fontSize: fontSize,
          foreground: foreground,
          size: size
        )
      )
      .clipped()
      .rotation3DEffect(
        Angle(degrees: rotation),
        axis: (x: 1.0, y: 0.0, z: 0.0),
        anchor: .bottom,
        anchorZ: 0,
        perspective: 0.3
      )
      .frame(maxHeight: .infinity, alignment: up.alignment)
      .zIndex(10)
      
      UnevenRoundedRectangle(
        topLeadingRadius: down.getTopRadius(cornerRadius),
        bottomLeadingRadius: down.getBottomRadius(cornerRadius),
        bottomTrailingRadius: down.getBottomRadius(cornerRadius),
        topTrailingRadius: down.getTopRadius(cornerRadius))
      .fill(background.shadow(.inner(radius: 1)))
      .frame(height: halfHeight)
      .overlay(alignment: .bottom) {
        textView(currentValue)
          .frame(size: size)
          .drawingGroup()
      }
      .clipped()
      .frame(maxHeight: .infinity, alignment: down.alignment)
    }
    .frame(size: size)
    .onChange(of: value, initial: true) {
      oldValue,
      newValue in
      currentValue = oldValue
      nextValue = newValue
      
      guard rotation == 0 else {
        currentValue = newValue
        return
      }
      
      guard oldValue != newValue else { return }
      
      withAnimation(
        .easeInOut(duration: animationDuration),
        completionCriteria: .logicallyComplete) {
          rotation = -180
        } completion: {
          rotation = 0
          currentValue = value
        }

    }
  }
  
  @ViewBuilder
  func textView(_ value: Int) -> some View {
    Text("\(value)")
      .font(.system(size: fontSize).bold())
      .foregroundStyle(foreground)
      .lineLimit(1)
  }
}

fileprivate struct RotationModifier: ViewModifier, Animatable {
  var rotation: CGFloat
  var currentValue: Int
  var nextValue: Int
  var fontSize: CGFloat
  var foreground: Color
  var size: CGSize
  var animatableData: CGFloat {
    get { rotation }
    set { rotation = newValue }
  }
  
  func body(content: Content) -> some View {
    content
      .overlay(alignment: .top) {
        Group {
          if -rotation > 90 {
            Text("\(nextValue)")
              .font(.system(size: fontSize).bold())
              .foregroundStyle(foreground)
              .scaleEffect(x: 1, y: -1)
              .transition(.identity)
              .lineLimit(1)
          } else {
            Text("\(currentValue)")
              .font(.system(size: fontSize).bold())
              .foregroundStyle(foreground)
              .transition(.identity)
              .lineLimit(1)
          }
        }
        .frame(size: size)
        .drawingGroup()
      }
  }
}

extension FlipClockEffectView {
  enum Position {
    case up
    case down
    
    func getTopRadius(_ radius: CGFloat) -> CGFloat {
      switch self {
      case .up: radius
      case .down: 0
      }
    }
    
    func getBottomRadius(_ radius: CGFloat) -> CGFloat {
      switch self {
      case .up: 0
      case .down: radius
      }
    }
    
    var alignment: Alignment {
      switch self {
      case .up: .top
      case .down: .bottom
      }
    }
  }
}

#Preview {
  FlipClockEffectView(
    value: .constant(0),
    size: CGSize(width: 100, height: 150),
    fontSize: 70,
    cornerRadius: 10,
    foreground: .white,
    background: .red
  )
}

extension View {
  func frame(size: CGSize, alignment: Alignment = .center) -> some View {
    self.frame(width: size.width, height: size.height, alignment: alignment)
  }
}
