//
//  HomeView.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("안녕하세요 ㅎㅎ")
                .font(.system(size: 50))
            
            Text("안녕하세요 ㅎㅎ")
                .font(.notoSans(width: .extraBold ,size: 15))
        }
        .padding(.bottom, UIApplication.shared.safeAreaInset.bottom + 75)
    }
}


