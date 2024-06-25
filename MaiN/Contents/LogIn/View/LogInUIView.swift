//
//  MainUIView.swift
//  Airis
//
//  Created by 김수민 on 12/29/23.
//

import SwiftUI
import WebKit
import Alamofire
import SwiftSoup


struct LogInUIView: View {

    var body: some View {
            NavigationView {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 330, height: 330)
                        .background(Color(red: 0.81, green: 0.94, blue: 1))
                        .cornerRadius(330)
                        .blur(radius: 10)
                        .offset(x: -130, y: -310)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 435, height: 435)
                        .background(Color(red: 0.81, green: 0.94, blue: 1))
                        .cornerRadius(330)
                        .blur(radius: 10)
                        .offset(x: 90, y: 280)
                    // 앱 이름과 설명
                    VStack {
//                        Spacer()
                        HStack(spacing: 0){
                            Text("m")
                                .font(.system(size: 73, weight: .bold)).foregroundColor(.black)
                            Text("AI")
                                .font(.system(size: 73, weight: .bold))
                                .foregroundColor(.titleBlue)
                            Text("n")
                                .font(.system(size: 73, weight: .bold)).foregroundColor(.black)
                            
                        }.padding(.bottom, 1)
//
                        Text("SSU AI융합학부 \n 공지사항 및 예약 서비스")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20))
                            .frame(width: 300)
                            .font(.title)
                            .padding(.bottom, 63)

                        NavigationLink {
                            AgreeView().navigationBarHidden(true)
                        } label: {
                            Text("usaint 로그인")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: 59)
                                .font(.system(size: 20, weight: .bold))
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                    }.padding(.horizontal, 60)
                }
                .frame(width: 393, height: 852)
                .background(.white)
            }
        }
}

#Preview {
    LogInUIView()
}

