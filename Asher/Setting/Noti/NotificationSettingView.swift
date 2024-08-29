//
//  NotificationSettingView.swift
//  Asher
//
//  Created by Chuchu Pro on 6/29/24.
//

import SwiftUI

import ComposableArchitecture

struct NotificationSettingView: View {
  @State var notifiIsOn: Bool = false
  @State var store = Store(initialState: NotificationFeature.State()) { NotificationFeature() }
  let customHeaderView: CustomHeaderView
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      customHeaderView
      GeometryReader { _ in
        VStack(spacing: 4) {
          Toggle(isOn: viewStore.binding(get: \.notiInfo.useNoti, send: { .setUseNoti($0) })) {
            Text("알림 설정")
          }
          .padding(.horizontal)
          .padding(.bottom, 4)
          
          Divider()
          
          let useNoti = viewStore.state.notiInfo.useNoti
          
          if useNoti {
            checkDayView()
            
            DatePicker(
              "",
              selection: viewStore.binding(get: \.notiInfo.notiTime, send: { .setNotiTime($0) }),
              displayedComponents: .hourAndMinute
            )
              .datePickerStyle(.wheel)
              .labelsHidden()
          } else {
            Text("wow")
          }
          
        }
      }
      .onAppear { viewStore.send(.onAppear) }
      .onDisappear { viewStore.send(.onDisappear) }
    }
  }
  
  @ViewBuilder
  private func checkDayView() -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text("요일 설정")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
        .padding(.vertical, 4)
      
      ScrollView(.horizontal) {
        HStack {
          ForEach(Days.allCases, id: \.self) { day in
            let selectedDay = viewStore.state.notiInfo.selectedDay.contains(day)
            let background: Color = selectedDay ? .current: .border
            CapsuleText(text: day.text, background: background) {
              viewStore.send(.setSelectedDay(day))
            }
          }
        }
        .padding(.horizontal, 16)
      }
      .scrollIndicators(.never)
      
      HStack {
          ForEach(DaySetting.allCases, id: \.self) { setting in
            let selectedSetting = viewStore.state.notiInfo.selectedDay == setting.daySetting
            let background: Color = selectedSetting ? .current: .border
            
            CapsuleText(text: setting.text, background: background) {
              viewStore.send(.setDaySetting(setting))
            }
          }
        Spacer()
      }
      .padding(.horizontal, 16)
    }.padding(.bottom, 4)
  }
}

#Preview {
  NotificationSettingView(notifiIsOn: false, customHeaderView: CustomHeaderView(action: { }, title: ""))
}

enum Days: Int {
  case sun = 1
  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  
  static let current: Days = Days(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .mon
  
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

extension Days: CaseIterable, Codable { }

enum DaySetting {
    case everyday
    case weekend
  
  var daySetting: Set<Days> {
    switch self {
    case .everyday: Set(Days.allCases)
    case .weekend: [.sat, .sun]
    }
  }
  
  var text: String {
    switch self {
    case .everyday: "매일"
    case .weekend: "주말"
    }
  }
}

extension DaySetting: CaseIterable { }

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
