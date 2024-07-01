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
    //MARK: State property
    @Published var ssuNotices: [SsuNoti] = []
    @Published var isLoading = true
    
    //MARK: property
    private var paging = 0
    private var isFetching: Bool = true
    private let provider = MoyaProvider<SsuNotiAPI>(plugins: [AuthPlugin()])
    
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
        
        if isFetching == true {
            paging += 1
            provider.request(.ssuNotiFavorites(studentId: studentId, pageNo: paging)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(response):
                        if let aiNoticess = try? response.map([SsuNoti].self) {
                            if aiNoticess == [] {
                                self.isFetching = false
                            } else {
                                self.ssuNotices += aiNoticess
                                self.isLoading = false
                            }
                        } else {
                            self.isLoading = false
                        }
                    case .failure:
                        self.isLoading = false
                    }
                }
            }
        } else { return }
    }
    
    func retrySuccess() {
        self.isLoading = true
        setAPIValue()
    }
}
