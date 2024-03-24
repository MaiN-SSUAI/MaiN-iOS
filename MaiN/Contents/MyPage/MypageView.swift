//
//  MypageView.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import SwiftUI

struct MypageView: View {
    
    @State var showAutoLoginAlert = false
    @State var isLogout = false
    
    var body: some View {
        VStack(alignment: .center){
            Spacer().frame(height: 31)
            Text("마이페이지").font(.bold(size: 22)).padding(.bottom, 24).foregroundColor(.black)
            Image("profile").frame(width: 149, height: 149).padding(.bottom, 27)
            VStack(alignment: .leading, spacing: 22){
                Divider().frame(width: 254)
                HStack(){
                    Text("학번").font(.bold(size: 15)).foregroundColor(.black)
                    Spacer()
                    Text("\(UserDefaults.standard.string(forKey: "schoolNumber")!)").font(.bold(size: 15)).foregroundColor(.black)
                }
                Divider().frame(width: 254)
                Button(action: {
                    self.showAutoLoginAlert = true
                }){
                    HStack(){
                        Text("로그아웃").font(.bold(size: 15)).foregroundColor(.black)
                        Spacer()
                    }
                }.alert(isPresented: $showAutoLoginAlert) {
                    Alert(
                        title: Text("로그아웃"),
                        message: Text("로그아웃 하시겠습니까?"),
                        primaryButton: .default(Text("취소").foregroundColor(.blue), action: {
                        }),
                        secondaryButton: .default(Text("확인").foregroundColor(.red), action: {
                            UserDefaults.standard.removeObject(forKey: "isLogIn")
                        })
                    )
                }
                Divider().frame(width: 254)
            }.padding(.horizontal, 46).padding(.vertical, 46).background(.white).cornerRadius(10)
                .padding(.horizontal, 20)
            Spacer()
        }.background(.gray00)
    }
}


#Preview {
    MypageView()
}
