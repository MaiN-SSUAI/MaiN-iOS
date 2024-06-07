//
//  SsuNotiModelData.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya
import SwiftUI


class SsuNotiModelData: ObservableObject {
    @Published var ssuNotices: [SsuNoti] = []
    @Published var isLoading = true
    let provider = MoyaProvider<SsuNotiAPI>()
    init() {
        setAPIValue()
    }

    func addFavorite(studentId: String, ssucatchNotiId: Int) {
        provider.request(.ssuNotiFavoritesAdd(studentId: studentId, ssucatchNotiId: ssucatchNotiId)) { result in
            switch result {
            case .success(let response):
                print("Successfully added to favorites")
            case .failure(let error):
                print("Error adding to favorites: \(error)")
            }
        }
    }
    
    func deleteFavorite(studentId: String, ssucatchNotiId: Int) {
        provider.request(.ssuNotiFavoritesDelete(studentId: studentId, ssucatchNotiId: ssucatchNotiId)) { result in
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
        provider.request(.ssuNotiFavorites(studentId: studentId)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let aiNoticess = try? response.map([SsuNoti].self) {
                        self.ssuNotices = aiNoticess
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
