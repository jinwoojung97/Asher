//
//  TalkListView.swift
//  Asher
//
//  Created by chuchu on 7/18/24.
//

import SwiftUI

struct TalkListView: View {
    var body: some View {
        Button(action: {NavigationManager.shared.push(TalkView())}, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
    }
}
