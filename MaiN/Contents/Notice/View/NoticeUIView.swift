//
//  NoticeUIView.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import SwiftUI

struct NoticeUIView: View {
    
    @State var shouldNavigateToHome = false
    
    var body: some View {
        NavigationView {
            ZStack(){
                Color.gray00.edgesIgnoringSafeArea(.all)
                VStack(spacing:20){
                    
                    NavigationLink(destination: AiNotiRow()) {
                        HStack {
                            Image("AI")
                                .resizable()
                                .frame(width: 54, height: 54) //
                                .scaledToFit()
                                .padding(.leading)
                            Text("AI융합학부 공지사항")
                                .frame(maxWidth: .infinity)
                                .font(.bold(size: 15))
                                .foregroundColor(.black)
                        }
                        .padding(20)
                        .frame(width: 338, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 3, y: 4)
                    }
                    
                    NavigationLink(destination: SsuNotiRow()) {
                        HStack(){
                            Image("SSU")
                                .frame(width: 50, height: 30)
                                .padding(.leading)
                            VStack(alignment: .leading){
                                Text("SSU:catch 공지사항 ")
                                    .font(.bold(size: 15))
                                    .foregroundColor(.black)
                            }.frame(maxWidth: .infinity).padding(30)
                        }
                        .padding(20)
                    }
                    .frame(width: 338, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 3, y: 4)
                    
                    
                    NavigationLink(destination: FunsysNotiRow()) {
                        HStack(){
                            Image("Funsys")
                                .frame(width: 50, height: 30)
                                .padding(.leading)
                            VStack(alignment: .leading){
                                Text("펀 시스템")
                                    .font(.bold(size: 15))
                                    .foregroundColor(.black)
                                Text("비교과 종합정보시스템")
                                    .font(.light(size: 15))
                                    .foregroundColor(.gray02)
                            }.frame(maxWidth: .infinity).padding(30)
                        }
                        .padding(20)
                    }
                    .frame(width: 338, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 3, y: 4)
                }.background(.gray00)
            }
        }
    }
}

#Preview {
    NoticeUIView()
}
