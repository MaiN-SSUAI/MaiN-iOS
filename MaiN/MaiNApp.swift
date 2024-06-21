//
//  AirisApp.swift
//  Airis
//
//  Created by 김수민 on 12/29/23.
//

import SwiftUI

@main
struct MaiNApp: App {
    @StateObject var vm = LogInViewModel()

    var body: some Scene {
        WindowGroup {
            if (vm.loginSuccess || UserDefaults.standard.bool(forKey: "isAutoLogin")){
                HomeUIView().environmentObject(vm)
            } else {
                LogInUIView().environmentObject(vm)
            }
        }
    }
}
