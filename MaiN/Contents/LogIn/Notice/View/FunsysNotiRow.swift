//
//  FunsysNotiRow.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import SwiftUI

struct FunsysNotiRow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var modelData = FunsysNotiModelData()
    @State private var showFavoritesOnly = false
    @State var webViewIsLoading = true
    let studentId = UserDefaults.standard.string(forKey: "studentNumber")
 
    var body: some View {
        Group {
            if modelData.isLoading {
                ProgressView("Loading...")
            } else {
                VStack(){
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("즐겨찾기 보기").font(.normal(size: 13)).foregroundColor(.black)
                    }.frame(width: 338, height: 35).toggleStyle(SwitchToggleStyle(tint: .blue03))
                    let filteredFunsysNotices = modelData.funsysNotices.filter { (!showFavoritesOnly || $0.favorites) }
                    if filteredFunsysNotices.isEmpty {
                        VStack(){
                            Spacer()
                            Text("내용이 없습니다.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(filteredFunsysNotices, id: \.id) { aiNoti in
                            NavigationLink(destination: WKWebViewPractice(url: aiNoti.link)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(
                                    leading: CustomBackButton(),
                                    trailing: Button(action: {
                                        if let index = modelData.funsysNotices.firstIndex(where: { $0.id == aiNoti.id }) {
                                            modelData.funsysNotices[index].favorites.toggle()
                                            if modelData.funsysNotices[index].favorites {
                                                modelData.addFavorite(studentId: self.studentId ?? "", funsysNotiId: aiNoti.id)
                                            } else {
                                                modelData.deleteFavorite(studentId: self.studentId ?? "", funsysNotiId: aiNoti.id)
                                            }
                                        }
                                    }) {
                                        Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                            .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                    }
                                    .navigationBarTitle("펀 시스템", displayMode: .inline)
                                )
                            ) {
                                VStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text("\(aiNoti.startDate) ~ \(aiNoti.end_date)").font(.bold(size: 16)).foregroundStyle(.blue02)
                                            Spacer()
                                            Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                                .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                        }
                                        Text(aiNoti.title).font(.normal(size: 13)).foregroundStyle(.black).fixedSize(horizontal: false, vertical: true)
                                    }
                                    Spacer()
                                }
                                .frame(height: 80)
                            }
                            .listRowBackground(Color.white)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                }.padding().background(.gray00)
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic_back")
            })
            .navigationBarTitle("펀 시스템", displayMode: .inline)
    }
    func toggleFavorite(studentId: String, funsysNotiId: Int) {
        let urlString = "/ainoti/favorites/add/\(studentId)/\(funsysNotiId)"
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

#Preview {
    FunsysNotiRow()
}
