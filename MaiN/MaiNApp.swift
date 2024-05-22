//
//  AirisApp.swift
//  Airis
//
//  Created by 김수민 on 12/29/23.
//

import SwiftUI

@main
struct MaiNApp: App {
    @AppStorage("isLogIn") var isLogin: String?
    var isAutoLogin: String? = UserDefaults.standard.string(forKey:"isAutoLogin")
    @StateObject var logInViewModel = LogInViewModel()

    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().backgroundColor = .gray00
    }

    var body: some Scene {
        WindowGroup {
            ApplicationSwitcher().environmentObject(logInViewModel)
        }
    }
}

struct ApplicationSwitcher: View {

    @EnvironmentObject var vm: LogInViewModel

    var body: some View {
        if (vm.loginSuccess) || (UserDefaults.standard.bool(forKey: "isAutoLogin")) {
            HomeUIView()
        } else {
            LogInUIView()
        }

    }
}
