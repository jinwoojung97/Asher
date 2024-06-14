//
//  AlignmentedText.swift
//  Asher
//
//  Created by chuchu on 6/14/24.
//

import SwiftUI

struct AlignmentedText: View {
    private let text: String
    private let alignment: Alignment
    private let spacing: CGFloat
    
    init(
        text: String,
        alignment: Alignment = .leading,
        spacing: CGFloat = 16.0
    ) {
        self.alignment = alignment
        self.text = text
        self.spacing = spacing
    }
    
    var edge: Edge.Set {
        switch alignment {
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .leading
        }
    }
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(edge, spacing)
    }
}
