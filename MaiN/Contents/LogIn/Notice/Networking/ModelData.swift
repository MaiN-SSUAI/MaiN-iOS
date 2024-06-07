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
    let provider = MoyaProvider<AiNotiAPI>()
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
        provider.request(.aiNotiFavorites(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let aiNoticess = try? response.map([AiNoti].self) {
                        print(2)
                        self.aiNotices = aiNoticess
                        self.isLoading = false
                    } else {
                        self.isLoading = false
                    }
                case .failure:
                    self.isLoading = false
                }
            }
        }
    }
}
