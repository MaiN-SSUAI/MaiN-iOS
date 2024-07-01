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
    //MARK: State property
    @Published var funsysNotices: [FunsysNoti] = []
    @Published var isLoading = true
    
    //MARK: property
    private var paging = 0
    private var isFetching: Bool = true
    private let provider = MoyaProvider<FunsysNotiAPI>(plugins: [AuthPlugin()])
    
    //MARK: init
    init() {
        if let authPlugin = provider.plugins.first(where: { $0 is AuthPlugin }) as? AuthPlugin {
            authPlugin.onRetrySuccess = { [weak self] in
                self?.retrySuccess()
            }
        }
        setAPIValue()
    }
    
    //MARK: function - API
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
        
        if isFetching == true {
            paging += 1
            provider.request(.funsysNotiFavorites(studentId: studentId, pageNo: paging)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(response):
                        if let aiNoticess = try? response.map([FunsysNoti].self) {
                            if aiNoticess == [] {
                                self.isFetching = false
                            } else {
                                self.funsysNotices += aiNoticess
                                self.isLoading = false
                            }
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
        
    // 재시도 성공 시 호출될 메서드
    func retrySuccess() {
        self.isLoading = true
        setAPIValue()
    }
}

