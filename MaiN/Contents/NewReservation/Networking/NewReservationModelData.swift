//  ReservationModelData.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import Foundation
import Moya
class NewReservationModelData: ObservableObject {
    @Published var selectedDate: String
    @Published var firstSeminarRoom: [NewReservation] = []
    @Published var secondSeminarRoom: [NewReservation] = []
    @Published var thirdSeminarRoom: [NewReservation] = []
    @Published var isLoading: Bool = true // 데이터 로딩 상태
    
    let provider = MoyaProvider<NewReservationAPI>()
    
    init(selectedDate: String) {
            self.selectedDate = selectedDate
    }
    
    func setAPIValue() {
        var requestCount = 0
        let totalRequests = 3
        let handleResponse: () -> Void = {
            requestCount += 1
            if requestCount == totalRequests {
                self.isLoading = false
            }
        }

        provider.request(.getReservation(date: selectedDate, selectedSeminar: "세미나실 1")) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let reservations = try? response.map([NewReservation].self) {
                        self.firstSeminarRoom.append(contentsOf: reservations)
                        handleResponse()
                    } else { handleResponse() }
                case .failure:
                    handleResponse()
                }
            }
        }

        provider.request(.getReservation(date: selectedDate, selectedSeminar: "세미나실 2")) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let reservations = try? response.map([NewReservation].self) {
                        self.secondSeminarRoom = reservations
                        handleResponse()
                    } else {handleResponse()}
                case .failure:
                    return
                }
            }
        }
        
        provider.request(.getReservation(date: selectedDate, selectedSeminar: "교수 회의실")) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if let reservations = try? response.map([NewReservation].self) {
                        self.thirdSeminarRoom = reservations
                        handleResponse()
                    } else {handleResponse()}
                case .failure:
                    return
                }
            }
        }
    }
}

