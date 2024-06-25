//
//  AiNotiRow.swift
//  Airis
//
//  Created by 김수민 on 1/4/24.
//

import SwiftUI
import WebKit

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("ic_back")
        }
    }
}

struct AiNotiRow: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var modelData = ModelData()
    @State private var showFavoritesOnly = false
    
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
                    let filteredAiNotices = modelData.aiNotices.filter { (!showFavoritesOnly || $0.favorites) }
                    if filteredAiNotices.isEmpty {
                        VStack(){
                            Spacer()
                            Text("내용이 없습니다.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(modelData.aiNotices.filter { !showFavoritesOnly || $0.favorites }, id: \.id) { aiNoti in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink(destination: WKWebViewPractice(url: aiNoti.link)
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarItems(
                                            leading: CustomBackButton(),
                                            trailing: Button(action: {
                                                if let index = modelData.aiNotices.firstIndex(where: { $0.id == aiNoti.id }) {
                                                    modelData.aiNotices[index].favorites.toggle()
                                                    if modelData.aiNotices[index].favorites {
                                                        modelData.addFavorite(studentId: self.studentId ?? "", aiNotiId: aiNoti.id)
                                                    } else {
                                                        modelData.deleteFavorite(studentId: self.studentId ?? "", aiNotiId: aiNoti.id)
                                                    }
                                                }
                                            }) {
                                                Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                                    .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                            }
                                        )
                                        .navigationBarTitle("AI융합학부 공지사항", displayMode: .inline).foregroundColor(.black)
                                    ) {
                                        VStack {
                                            VStack(alignment: .leading, spacing: 6) {
                                                HStack {
                                                    Text(aiNoti.date).font(.bold(size: 16)).foregroundStyle(.blue02)
                                                    Spacer()
                                                }
                                                Text(aiNoti.title).font(.normal(size: 13)).foregroundStyle(.black).fixedSize(horizontal: false, vertical: true)
                                            }
                                            Spacer()
                                        }
                                        .frame(height: 80)
                                    }
                                    Button (action: {
                                        if let index = modelData.aiNotices.firstIndex(where: { $0.id == aiNoti.id }) {
                                            modelData.aiNotices[index].favorites.toggle()
                                            if modelData.aiNotices[index].favorites {
                                                modelData.addFavorite(studentId: self.studentId ?? "", aiNotiId: aiNoti.id)
                                            } else {
                                                modelData.deleteFavorite(studentId: self.studentId ?? "", aiNotiId: aiNoti.id)
                                            }
                                        }
                                    }) {
                                        Image(systemName: aiNoti.favorites ? "star.fill" : "star")
                                            .foregroundColor(aiNoti.favorites ? .yellow : .gray)
                                            .padding(.trailing, 10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
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
            .navigationBarTitle("AI융합학부 공지사항", displayMode: .inline)
    }
    
}
struct WKWebViewPractice: UIViewRepresentable {

    var url: String
    let webView: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func makeCoordinator() -> Coordinator {
            Coordinator()
        }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("통신중")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("통신 완료")
        }
    }
}

#Preview {
    return Group {
        AiNotiRow()
    }
}


struct FavoriteButton: View {
    @Binding var isSet: Bool

    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .yellow : .gray)
                .onTapGesture {
                    isSet.toggle()
                }
        }
    }
}
