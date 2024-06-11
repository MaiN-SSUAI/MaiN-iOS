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
                                                              studentNo: ["20221813", "20220900"], 
                                                              start: "2024-05-25T01:00:00.000+09:00", end: "2024-05-25T02:00:00.000+09:00",
                                                              start_pixel: "36", end_pixel: "72"),
                                                Reservation(reservId: 0,
                                                            studentNo: ["20233107"],
                                                            start: "2024-06-03T13:00:00.000+09:00", end: "2024-06-03T16:00:00.000+09:00",
                                                            start_pixel: "468", end_pixel: "576")]
    
    @Published var weekReservations: [[Reservation]] = [
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T01:00:00.000+09:00",
            end: "2024-05-25T02:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72"),
             Reservation(reservId: 16,
             studentNo: ["20221813", "20220900"],
             start: "2024-05-25T02:10:00.000+09:00",
             end: "2024-05-25T03:00:00.000+09:00",
             start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")],
            [Reservation(reservId: 16,
            studentNo: ["20221813", "20220900"],
            start: "2024-05-25T04:00:00.000+09:00",
            end: "2024-05-25T05:00:00.000+09:00",
            start_pixel: "36", end_pixel: "72")]]
    
    //MARK: View
    @Published var isInfoModalPresented: Bool = false
    @Published var isDetailModalPresented: Bool = false
    @Published var isRegisterModalPresented: Bool = false
    @Published var selectedDate: Date = Date() { // API 강제 호출
        didSet {
            fetchReservationAPI(for: selectedDate)
            fetchWeekReservationAPI(for: selectedDate)
        }
    }
    @Published var selectedDateIndex: Int = 0
    @Published var dayOrWeek: String = "week"
    @Published var selectedReservation: Reservation?
    @Published var alertMessage: String? = nil
    @Published var showAlert: Bool = false
    
    //MARK: Network
    @Published var isLoading: Bool = false // API 호출 진행중
    @Published var isWeekLoading: Bool = false // API 호출 진행중
    
    //MARK: User
    @EnvironmentObject var logInVM: LogInViewModel
    
    //MARK: init
    init() {
        fetchReservationAPI(for: selectedDate)
        fetchWeekReservationAPI(for: selectedDate)
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
                        print("세미나실 매핑 성공🚨")
                        self.reservations = reservations
                    } else {
                        print("세미나실 매핑 실패🚨")
                    }
                case .failure:
                    print("세미나실 네트워크 요청 실패🚨")
                }
            }
            self.isLoading = false
        }
    }
    
    func fetchWeekReservationAPI(for date: Date) {
        self.isWeekLoading = true
        provider.request(.getWeekReservation(date: date.toDateString())) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    print(response)
//                    if let reservations = try? response.map([Reservation].self) {
//                        print("week 세미나실 매핑 성공🚨")
//                        self.reservations = reservations
//                    } else {
//                        print("week 세미나실 매핑 실패🚨")
//                    }
                    do {
                        let decodedData = try JSONDecoder().decode(WeekReservations.self, from: response.data)
                        self.weekReservations = [
                            decodedData.Mon,
                            decodedData.Tue,
                            decodedData.Wed,
                            decodedData.Thu,
                            decodedData.Fri,
                            decodedData.Sat,
                            decodedData.Sun
                        ]
                        print("week 세미나실 매핑 성공🚨")
                    } catch {
                        print("week 세미나실 매핑 실패🚨: \(error)")
                    }
                case .failure:
                    print("세미나실 네트워크 요청 실패🚨")
                }
            }
            self.isWeekLoading = false
        }
    }
    
    func addReservation() {
        //API 연결 + 비동기처리
        fetchReservationAPI(for: selectedDate)
        fetchWeekReservationAPI(for: selectedDate)
    }
    
    func checkUser(user: String, date: String, completion: @escaping (Bool) -> Void) {
        provider.request(.checkUser(user: user, date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            var checkValid: Bool
                            switch responseString {
                            case "uninformed/valid user", "informed/valid user":
                                checkValid = true
                            case "More than 2 appointments a week", "Reservation can only be made for this month and the next month":
                                checkValid = false
                            default:
                                checkValid = false
                            }
                            self.alertMessage = responseString
                            print("사용자 추가 결과 : \(responseString)")
                            completion(checkValid)
                        }
                    }
                    print("사용자 추가 api 매핑 성공")
                } catch {
                    print("사용자 추가 api 매핑 실패")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage = "네트워크 통신이 실패하였습니다."
                    completion(false)
                }
                print("사용자 추가 api 통신 실패")
            }
        }
    }

}
