//
//  HomeUIView.swift
//  Airis
//
//  Created by 김수민 on 12/29/23.
//

import SwiftUI

enum Tab {
    case notice
    case reservation
    case fix
    case profile
}

struct HomeUIView: View {
    @State private var selectedTab: Tab = .notice
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray01
    }
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                NoticeUIView()
                    .tabItem {
                        Image(selectedTab == .notice ? "notiTabFill" : "notiTab")
                        Text("공지사항").font(.system(size: 10))
                    }
                    .tag(Tab.notice)
                
                ReservationView()
                    .tabItem {
                        Image(selectedTab == .reservation ? "reserveTabFill" : "reserveTab")
                        Text("예약").font(.system(size: 10))
                    }
                    .tag(Tab.reservation)
                
                MypageView()
                    .tabItem {
                        Image(selectedTab == .profile ? "mypageTabFill" : "mypageTab")
                        Text("마이페이지").font(.system(size: 10))
                    }
                    .tag(Tab.profile)
            }
        }
    }
}
