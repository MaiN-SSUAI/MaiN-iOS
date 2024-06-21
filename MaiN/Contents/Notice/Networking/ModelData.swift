//
//  ModelData.swift
//  MaiN
//
//  Created by 김수민 on 1/3/24.
//

import Foundation
import Moya
import SwiftUI

class ModelData: ObservableObject {
    @Published var aiNotices: [AiNoti] = []
    @Published var isLoading = true
    let provider = MoyaProvider<AiNotiAPI>(plugins: [AuthPlugin()])
    init() {
        setAPIValue()
    }

    func addFavorite(studentId: String, aiNotiId: Int) {
        provider.request(.aiNotiFavoritesAdd(studentId: studentId, aiNotiId: aiNotiId)) { result in
            switch result {
            case .success(let response):
                print("Successfully added to favorites")
            case .failure(let error):
                print("Error adding to favorites: \(error)")
            }
        }
    }

    func deleteFavorite(studentId: String, aiNotiId: Int) {
        provider.request(.aiNotiFavoritesDelete(studentId: studentId, aiNotiId: aiNotiId)) { result in
            switch result {
            case .success(let response):
                print("Successfully removed from favorites")
            case .failure(let error):
                print("Error removing from favorites: \(error)")
            }
        }
    }
    
    func setAPIValue() {
        guard let studentId = UserDefaults.standard.string(forKey: "studentNumber") else {
            return
        }
        print(type(of: studentId))
        provider.request(.aiNotiFavorites(studentNo: studentId, pageNo: 1)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print("학부 공지사항(aiNoti) 네트워크 성공🚨")
                    if let aiNoticess = try? response.map([AiNoti].self) {
                        print(2)
                        print("학부 공지사항(aiNoti) 매핑 성공🚨")
                        self.aiNotices = aiNoticess
                        self.isLoading = false
                    } else {
                        print("학부 공지사항(aiNoti) 매핑 실패🚨")
                        self.isLoading = false
                    }
                case .failure(let error):
                    print("학부 공지사항(aiNoti) 네트워크 실패🚨")
                    self.isLoading = false
                    print("\(error)")
                }
            }
        }
    }
}
