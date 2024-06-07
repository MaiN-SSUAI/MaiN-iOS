//
//  SsuNotiRow.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import SwiftUI

struct SsuNotiRow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var ssuNotiModelData = SsuNotiModelData()
    @State private var showFavoritesOnly = false
    @State private var selectedTab = "전체"
    @State var webViewIsLoading: Bool = true
    let studentId = UserDefaults.standard.string(forKey: "studentNumber")
 
    var body: some View {
        Group {
            if ssuNotiModelData.isLoading {
                    ProgressView("Loading...")
            } else {
                VStack(){
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("즐겨찾기 보기").font(.normal(size: 13)).foregroundColor(.black)
                    }.frame(width: 338, height: 35).toggleStyle(SwitchToggleStyle(tint: .blue03))
                    ScrollView(.horizontal, showsIndicators: false){
                            HStack {
                                TabButton(title: "전체", selectedTab: $selectedTab)
                                TabButton(title: "학사", selectedTab: $selectedTab)
                                TabButton(title: "장학", selectedTab: $selectedTab)
                                TabButton(title: "국제교류", selectedTab: $selectedTab)
                                TabButton(title: "외국인유학생", selectedTab: $selectedTab)
                                TabButton(title: "채용", selectedTab: $selectedTab)
                                TabButton(title: "비교과·행사", selectedTab: $selectedTab)
                                TabButton(title: "교원채용", selectedTab: $selectedTab)
                                TabButton(title: "교직", selectedTab: $selectedTab)
                                TabButton(title: "봉사", selectedTab: $selectedTab)
                                TabButton(title: "기타", selectedTab: $selectedTab)
                                TabButton(title: "코로나19관련소식", selectedTab: $selectedTab)
                            }
                    }
                    let filteredSsuNotices = ssuNotiModelData.ssuNotices.filter { notice in
                        // '전체' 탭이 선택되었거나, 공지사항의 카테고리가 선택된 탭과 일치할 경우 true 반환
                        (selectedTab == "전체" || notice.category == selectedTab) && (!showFavoritesOnly || notice.favorites)
                    }
                    if filteredSsuNotices.isEmpty {
                        VStack(){
                            Spacer()
                            Text("내용이 없습니다.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(filteredSsuNotices, id: \.id) { aiNoti in
                                NavigationLink(destination: WKWebViewPractice(url: aiNoti.link)
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(
                                        leading: CustomBackButton(),
                                        trailing: Button(action: {
                                            if let index = ssuNotiModelData.ssuNotices.firstIndex(where: { $0.id == aiNoti.id }) {
                                                ssuNotiModelData.ssuNotices[index].favorites.toggle()
                                                if ssuNotiModelData.ssuNotices[index].favorites {
                                                    ssuNotiModelData.addFavorite(studentId: self.studentId ?? "", ssucatchNotiId: aiNoti.id)
                                                } else {
                                                    ssuNotiModelData.deleteFavorite(studentId: self.studentId ?? "", ssucatchNotiId: aiNoti.id)
                                                }
                                            }
                                        }) {
                                            Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                                .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                        }
                                        .navigationBarTitle("SSU:catch 공지사항", displayMode: .inline)
                                    )
                                ) {
                                    VStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack {
                                                Text(aiNoti.sDate).font(.bold(size: 16)).foregroundStyle(.blue02)
                                                Spacer()
                                                Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                                    .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                            }
                                            Text(aiNoti.title).font(.normal(size: 13)).foregroundStyle(.black).fixedSize(horizontal: false, vertical: true)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("\(aiNoti.category)").font(.normal(size: 13)).foregroundColor(.black)
                                                .padding(.horizontal, 11).padding(.vertical, 3).overlay(
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .stroke(.black, lineWidth: 1)
                                                )
                                                .padding(.trailing, 8)
                                            
                                            if (aiNoti.progress != "") {
                                                Text("\(aiNoti.progress)".replacingOccurrences(of: "\n", with: "")).font(.normal(size: 13)).foregroundColor(.white)
                                                    .padding(.horizontal, 11).padding(.vertical, 3).background(.blue03)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 100)
                                }
                                .listRowBackground(Color.white) // 각 항목의 배경색을 흰색으로 설정
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.top, 4)
                    }
                }.padding().background(.gray00)
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic_back")
            })
            .navigationBarTitle("SSU:catch 공지사항", displayMode: .inline)
    }
    func toggleFavorite(studentId: String, aiNotiId: Int) {
        let urlString = "/ainoti/favorites/add/\(studentId)/\(aiNotiId)"
        guard let url = URL(string: "https://your-api-base-url.com\(urlString)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or status code")
                return
            }
            if let data = data {}
        }
        task.resume()
    }
    
}

struct TabButton: View {
    let title: String
    @Binding var selectedTab: String

    var body: some View {
        Button(action: {
            self.selectedTab = title
        }) {
            Text(title)
                .font(.normal(size: 13))
                .padding()
                .frame(width: 83, height: 25)
                .background(self.selectedTab == title ? .blue03 : Color.white)
                .foregroundColor(self.selectedTab == title ? .white : .black)
                .cornerRadius(10)
        }
    }
}
