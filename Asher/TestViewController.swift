//
//  TestViewController.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//

import UIKit
import SwiftUI

final class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        setting()
    }
    
    private func setting() {
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Hello, UIKit in SwiftUI!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

struct TestViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TestViewController {
        return TestViewController()
    }
    
    func updateUIViewController(_ uiViewController: TestViewController, context: Context) {
        // 필요 시 UIViewController 업데이트
    }
}

struct CustomTabbarView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                    .ignoresSafeArea(.all, edges: .top)
                ChatView()
                    .tag(Tab.chat)
                    .ignoresSafeArea(.all, edges: .top)
                EmotionView()
                    .tag(Tab.emotion)
                    .ignoresSafeArea(.all, edges: .top)
                MeditationView()
                    .tag(Tab.profile)
                    .ignoresSafeArea(.all, edges: .top)
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .frame(height: 70)
                    .ignoresSafeArea(.all)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack() {
            TabBarButton(tab: .home, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(tab: .chat, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(tab: .emotion, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(tab: .profile, selectedTab: $selectedTab)
        }
        .padding(.bottom, 8)
        .padding(.horizontal)
        .background(Color.yellow)
    }
}

struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: tab.iconName)
                    .font(.system(size: 24))
                    .padding(.top)
                Text(tab.title)
                    .font(.caption)
                
            }
            .foregroundColor(selectedTab == tab ? Color.blue : Color.gray)
        }
        .padding(.horizontal)
        
    }
}

enum Tab: String {
    case home
    case chat
    case emotion
    case profile
    
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .chat:
            return "bubble.left.and.bubble.right.fill"
        case .emotion:
            return "smiley"
        case .profile:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .chat:
            return "Chat"
        case .emotion:
            return "Emotion"
        case .profile:
            return "Profile"
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                
                NavigationLink {
                    Text("안녕하세요 ㅎㅎ")
                        .font(.system(size: 50))
                    
                    Text("안녕하세요 ㅎㅎ")
                        .font(.notoSans(width: .extraBold ,size: 15))
                } label: {
                    Text("Wow")
                }
            }
        }
        .onAppear {
            for family in UIFont.familyNames {
                print("Family: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("  \(name)")
                }
            }
        }
    }
}

struct ChatView: View {
    var body: some View {
        Color.green
            .ignoresSafeArea()
    }
}

struct EmotionView: View {
    var body: some View {
        Color.blue
            .ignoresSafeArea()
    }
}

struct MeditationView: View {
    var body: some View {
        Color.purple
            .ignoresSafeArea()
    }
}

struct ProfileView: View {
    var body: some View {
        Color.orange
            .ignoresSafeArea()
    }
}

#Preview {
    CustomTabbarView()
}


extension Font {
    public enum NotoSansKr {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
        case thin
        
        var name: String {
            switch self {
            case .black: return "Black"
            case .bold: return "Bold"
            case .extraBold: return "ExtraBold"
            case .extraLight: return "ExtraLight"
            case .light: return "Light"
            case .medium: return "Medium"
            case .regular: return "Regular"
            case .semiBold: return "SemiBold"
            case .thin: return "Thin"
            }
        }
    }
    
    public static func notoSans(width: NotoSansKr, size: CGFloat) -> Font {
        let fontName = "NotoSansKR-"
        return .custom(fontName + width.name, size: size)
    }
}
