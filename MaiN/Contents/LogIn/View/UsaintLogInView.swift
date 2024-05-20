//
//  UsaintLoginView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct UsaintLogInView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var logInVM: LogInViewModel

    var body: some View {
        ZStack() {
            //MARK: Usaint LogIn
            VStack(spacing: 0) {
                HStack(){
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Image("ic_back").padding()
                    })
                    Spacer()
                }
                WebView()
            }
            .background(.white)
            .alert(isPresented: $logInVM.showAlert) {
                Alert(title: Text(""), message: Text(logInVM.alertMessage), dismissButton: .default(Text("확인")))
            }
            
            //MARK: Success Usaint LogIn
            if logInVM.isAuthenticating {
                MaiNLoadingView()
                    .onAppear {
                        logInVM.sendTokenToServer { success in
                            if success {
                                logInVM.loginSuccess = true
                            } else {
                                print()
                            }
                        }
                    }
            }
            
            //MARK: After Receive Token
            NavigationLink (
                destination: HomeUIView().navigationBarHidden(true),
                isActive: $logInVM.loginSuccess,
                label: {
                    EmptyView()
                }
            )
        }
    }
    
}

#Preview {
    UsaintLogInView()
}
