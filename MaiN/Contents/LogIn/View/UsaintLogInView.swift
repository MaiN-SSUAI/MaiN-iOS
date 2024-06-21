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
    @State var showAutoLoginAlert: Bool = false
    @State var showAlert: Bool = false
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
                WebView(urlString: "https://smartid.ssu.ac.kr/Symtra_sso/smln.asp?apiReturnUrl=https%3A%2F%2Fsaint.ssu.ac.kr%2FwebSSO%2Fsso.jsp", showAlert: $showAlert)
            }
            .background(.white)
            
            //MARK: Success Usaint LogIn
            if logInVM.isAuthenticating {
                MaiNLoadingView()
                .onAppear {
                    logInVM.sendTokenToServer { success in
                        if success {
                            logInVM.isAuthenticating = false
                            showAutoLoginAlert = true
                            showAlert = true
                        } else {
                            print("")
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            if showAutoLoginAlert {
                return Alert(
                    title: Text("자동 로그인 활성화"),
                    message: Text("자동 로그인을 활성화 하시겠습니까?"),
                    primaryButton: .default(Text("취소").foregroundColor(.blue), action: {
                        UserDefaults.standard.set(false, forKey: "isAutoLogin")
                        logInVM.loginSuccess = true
                    }),
                    secondaryButton: .default(Text("확인").foregroundColor(.red), action: {
                        UserDefaults.standard.set(true, forKey: "isAutoLogin")
                        logInVM.loginSuccess = true
                    })
                )
            } else {
                return Alert(
                    title: Text(""),
                    message: Text(logInVM.alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
    
}

#Preview {
    UsaintLogInView()
}
