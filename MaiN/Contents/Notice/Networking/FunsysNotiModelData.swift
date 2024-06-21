//
//  FunsysModelData.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya
import SwiftUI

class FunsysNotiModelData: ObservableObject {
    
    @Published var funsysNotices: [FunsysNoti] = []
    @Published var isLoading = true
    let provider = MoyaProvider<FunsysNotiAPI>(plugins: [AuthPlugin()])
    
    init() {
        setAPIValue()
    }
    
    func addFavorite(studentId: String, funsysNotiId: Int) {
        provider.request(.funsysNotiFavoritesAdd(studentId: studentId, funsysNotiId: funsysNotiId)) { result in
            switch result {
            case .success(let response):
                print("Successfully added to favorites")
            case .failure(let error):
                print("Error adding to favorites: \(error)")
            }
        }
    }
    
    func deleteFavorite(studentId: String, funsysNotiId: Int) {
        provider.request(.funsysNotiFavoritesDelete(studentId: studentId, funsysNotiId: funsysNotiId)) { result in
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
        provider.request(.funsysNotiFavorites(studentId: studentId, pageNo: 1)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let aiNoticess = try? response.map([FunsysNoti].self) {
                        print("🍎funsysNoti 매핑 성공")
                        self.funsysNotices = aiNoticess
                        self.isLoading = false
                    } else {
                        print("🍎funsysNoti 매핑 실패")
                        self.isLoading = false
                    }
                case .failure:
                    print("🍎funsysNoti 네트워크 실패")
                    self.isLoading = false
                }
            }
        }
    }
}
