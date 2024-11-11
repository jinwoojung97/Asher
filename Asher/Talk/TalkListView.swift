//
//  TalkListView.swift
//  Asher
//
//  Created by chuchu on 7/18/24.
//

import SwiftUI

struct TalkListView: View {
    var body: some View {
        if !UserDefaultsManager.shared.isInspected {
            inspectionView
                .background(.main1)
        } else {
            Button(action: {NavigationManager.shared.push(TalkRepresentable().ignoresSafeArea())}, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
        }
        
        
    }
    
    @ViewBuilder
    var inspectionView: some View {
        VStack(spacing: 20) {
            Image(.inspection)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("서비스 점검 중입니다")
                .font(.notoSans(width: .bold, size: 22))
                .foregroundStyle(.subtitleOn)
            
            Text("빠른 시일 내에 서비스를 복구하도록 최선을 다하겠으며, 이로 인해 불편을 끼쳐드려 대단히 죄송합니다.")
                .font(.notoSans(width: .regular, size: 16))
                .foregroundStyle(.subtitleOn)
                .padding(.horizontal, 8)
            
            Spacer()
        }
    }
}

struct TalkRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TalkViewController {
        return TalkViewController()
    }
    
    func updateUIViewController(_ uiViewController: TalkViewController, context: Context) {
        // 필요 시 UIViewController 업데이트
    }
}
