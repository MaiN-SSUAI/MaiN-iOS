//
//  ReservationViewModel.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI
import Moya

class ReservationViewModel: ObservableObject {
    //MARK: data
    @Published var reservations: [NewReservation] = []
    
    //MARK: View
    @Published var isInfoModalPresented: Bool = false
    @Published var selectedDate: Date = Date() { // API 강제 호출
        didSet {
            fetchReservationAPI(for: selectedDate)
        }
    }
    @Published var dayOrWeek: String = "day"

    //MARK: Network
    @Published var isLoading: Bool = false // API 호출 진행중
    @Published var trigger: Bool = false { // API 강제 호출
        didSet {
            if trigger {
                fetchReservationAPI(for: selectedDate)
            }
        }
    }
    
    //MARK: init
    init() {
        fetchReservationAPI(for: selectedDate)
    }

    let provider = MoyaProvider<NewReservationAPI>()
    func fetchReservationAPI(for date: Date) {
        self.isLoading = true 
        provider.request(.getReservation(date: date.toDateString(), selectedSeminar: "세미나실 1")) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    if let reservations = try? response.map([NewReservation].self) {
                        self.reservations = reservations
                    } else { 
                        print("세미나실 매핑 실패🚨")
                    }
                case .failure:
                    print("세미나실 네트워크 요청 실패🚨")
                }
            }
            self.isLoading = false
            self.trigger = false
        }
    }

    func showInfoModal() {
        isInfoModalPresented = true
    }
    
    func changeDate(date: Date) {
        selectedDate = date
    }
}
