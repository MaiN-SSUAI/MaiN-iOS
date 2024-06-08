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
    @Published var reservations: [Reservation] = [Reservation(reservId: 16,
          studentNo: ["20221813", "20220900"], start: "2024-05-25T01:00:00.000+09:00",
          end: "2024-05-25T02:00:00.000+09:00", start_pixel: "36", end_pixel: "72")]
    
    //MARK: View
    @Published var isInfoModalPresented: Bool = false
    @Published var isDetailModalPresented: Bool = false
    @Published var isRegisterModalPresented: Bool = false
    @Published var selectedDate: Date = Date() { // API 강제 호출
        didSet {
            fetchReservationAPI(for: selectedDate)
        }
    }
    @Published var dayOrWeek: String = "day"
    @Published var selectedReservation: Reservation?

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

    func showInfoModal() {
        isInfoModalPresented = true
    }
    
    func changeDate(date: Date) {
        selectedDate = date
    }
    
    //MARK: Network
    let provider = MoyaProvider<NewReservationAPI>()
    
    func fetchReservationAPI(for date: Date) {
        self.isLoading = true
        provider.request(.getReservation(date: date.toDateString())) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
                    if let reservations = try? response.map([Reservation].self) {
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
    
    func addUser(studentId: String) {
        print("")
    }
}
