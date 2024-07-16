//
//  NotificationSettingView.swift
//  Asher
//
//  Created by Chuchu Pro on 6/29/24.
//

import SwiftUI

struct NotificationSettingView: View {
  @State var notifiIsOn: Bool = false
  let customHeaderView: CustomHeaderView
  
  var body: some View {
    customHeaderView
    ScrollView {
      Toggle(isOn: $notifiIsOn) {
        Text("알림 설정")
      }.padding()
      
      //      LazyVGrid(columns: columns) {
      ChipLayout(verticalSpacing: 8, horizontalSpacing: 8) {
        ForEach(Days.allCases, id: \.self) { day in
          Text(day.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
              Capsule().foregroundStyle(.blue)
            )
          
        }
      }.padding(.horizontal)
      
    }
  }
}

//#Preview {
//  NotificationSettingView(notifiIsOn: false, customHeaderView: CustomHeaderView(action: { }, title: ""))
//}

public enum Days: Int {
  case sun = 1
  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  
  var text: String {
    switch self {
    case .sun: return "일요일"
    case .mon: return "월요일"
    case .tue: return "화요일"
    case .wed: return "수요일"
    case .thu: return "목요일"
    case .fri: return "금요일"
    case .sat: return "토요일"
    }
  }
}

extension Days: CaseIterable { }

struct ChipLayout: Layout {
  var verticalSpacing: CGFloat = 0
  var horizontalSpacing: CGFloat = 0
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    return CGSize(width: proposal.width ?? 0, height: proposal.height ?? 0)
  }
  
  // proposal 제공 뷰크기
  // bounds 위치
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    print("bound: ", bounds)
    print("proposal: ", proposal)
    
    var sumX: CGFloat = bounds.minX
    var sumY: CGFloat = bounds.minY
    
    for index in subviews.indices {
      let view = subviews[index]
      let viewSize = view.sizeThatFits(.unspecified)
      guard let proposalWidth = proposal.width else { continue }
      
      // 가로 끝인경우 아래로 이동
      if (sumX + viewSize.width > proposalWidth) {
        sumX = bounds.minX
        sumY += viewSize.height
        sumY += verticalSpacing
      }
      
      let point = CGPoint(x: sumX, y: sumY)
      // anchor: point의 기준 적용지점
      // proposal: unspecified, infinity -> 넘어감, zero -> 사라짐, size -> 제안한크기 만큼 지정됨
      // size지정해줘야 텍스트긴경우 짤림
      view.place(at: point, anchor: .topLeading, proposal: proposal)
      sumX += viewSize.width
      sumX += horizontalSpacing
    }
  }
  
}
