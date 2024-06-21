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
                         start_pixel: "36", end_pixel: "72")]] {
         didSet {
             if (weekReservations.allSatisfy { $0.isEmpty }) {reservations = []} else {
                 reservations = weekReservations[selectedDateIndex]
             }
         }
     }
    
    @Published var selectedDetailReservInfo: ReservDetailInfo = ReservDetailInfo(reservId: 0, studentIds: [], purpose: "", time: "")
    
    //MARK: View
    @Published var isInfoModalPresented: Bool = false
    @Published var isDetailModalPresented: Bool = false
    @Published var isRegisterModalPresented: Bool = false
    @Published var selectedDate: Date = Date() {
        didSet {
            updateSelectedDateIndex()
        }
    }
    @Published var selectedDateIndex: Int = 0 {
        didSet {
            if weekReservations.allSatisfy { $0.isEmpty } {
                reservations = []
            } else {
                reservations = weekReservations[selectedDateIndex]
            }
        }
    }
    @Published var dayOrWeek: String = "day"
    @Published var selectedReservation: Reservation?
    @Published var alertMessage: String? = nil
    @Published var showAlert: Bool = false
    
    //MARK: Network
    @Published var isLoading: Bool = false // API 호출 진행중
    @Published var isWeekLoading: Bool = false // API 호출 진행중
    @Published var trigger: Bool = false { // API 강제 호출
        didSet {
            print("⭐️⭐️⭐️⭐️⭐️trigger작동")
            fetchWeekReservationAPI(for: selectedDate)
        }
    }
    //MARK: User
    @EnvironmentObject var logInVM: LogInViewModel
    
    //MARK: init
    init() {
        let authPlugin = AuthPlugin()
        authPlugin.onRetrySuccess = { [weak self] in
            self?.fetchReservationAPI(for: self?.selectedDate ?? Date())
            self?.fetchWeekReservationAPI(for: self?.selectedDate ?? Date())
        }
        self.provider = MoyaProvider<NewReservationAPI>(plugins: [authPlugin])
        fetchReservationAPI(for: selectedDate)
        fetchWeekReservationAPI(for: selectedDate)
    }

    private func updateSelectedDateIndex() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        
        switch weekday {
        case 1: // Sunday
            selectedDateIndex = 6
        case 2: // Monday
            selectedDateIndex = 0
        case 3: // Tuesday
            selectedDateIndex = 1
        case 4: // Wednesday
            selectedDateIndex = 2
        case 5: // Thursday
            selectedDateIndex = 3
        case 6: // Friday
            selectedDateIndex = 4
        case 7: // Saturday
            selectedDateIndex = 5
        default:
            selectedDateIndex = -1 // Error case, should not happen
        }
    }
    
    func showInfoModal() {
        isInfoModalPresented = true
    }
    
    func changeDate(date: Date) {
        selectedDate = date
    }
    
    //MARK: Network
    var provider = MoyaProvider<NewReservationAPI>()
    
    func fetchReservationAPI(for date: Date) {
        self.isLoading = true
        provider.request(.getReservation(date: date.toDateString())) { result in
            switch result {
            case let .success(response):
                print(response)
                if let reservations = try? response.map([Reservation?].self) {
                    print("세미나실 매핑 성공🚨")
                    print("🌷accessToekn:\(TokenManager.shared.accessToken)")
                    print("🌷refreshToekn:\(TokenManager.shared.refreshToken)")
                    self.reservations = reservations.compactMap { $0 }
                } else {
                    print("세미나실 매핑 실패🚨")
                    print("🌷accessToekn:\(TokenManager.shared.accessToken)")
                    print("🌷refreshToekn:\(TokenManager.shared.refreshToken)")
                }
            case .failure:
                print("세미나실 네트워크 요청 실패🚨")
            }
            self.isLoading = false
        }
    }
    
    func fetchWeekReservationAPI(for date: Date) {
        self.isWeekLoading = true
        provider.request(.getWeekReservation(date: date.toDateString())) { result in
            switch result {
            case let .success(response):
                print(response)
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
                    self.weekReservations = [[]]
                    if self.dayOrWeek == "week" {
                        self.alertMessage = "네트워크 에러"
                        self.showAlert = true
                    } else {
                        self.fetchReservationAPI(for: self.selectedDate)
                    }
                }
            case .failure:
                self.weekReservations = [[]]
                print("세미나실 네트워크 요청 실패🚨")
                if self.dayOrWeek == "week" {
                    self.alertMessage = "네트워크 에러"
                    self.showAlert = true
                } else {
                    self.fetchReservationAPI(for: self.selectedDate)
                }
            }
            self.isWeekLoading = false
        }
    }
    
    func addReservation(reservInfo: ReservInfo, completion: @escaping (String) -> Void) {
//        self.isLoading = true
        self.isWeekLoading = true
        provider.request(.addReservation(reserv: reservInfo)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                if statusCode == 200 {
                    if let responseString = String(data: response.data, encoding: .utf8) {
                            print("세미나실 예약 등록 API 성공🔥 : \(responseString)")
                            completion("예약이 등록되었습니다.")
                    }
                } else if statusCode == 400 {
                    if let responseData = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                        let errorMessage = responseData.detail
                        print("세미나실 예약 등록 API 실패🔥 - 상태 코드: \(statusCode) 메시지: \(errorMessage)")
                        completion("\(errorMessage)")
                    } else {
                        print("세미나실 예약 등록 API 실패🔥 - 상태 코드: \(statusCode)")
                        completion("\(statusCode))")
                    }
                } else {
                    print("세미나실 예약 등록 API 실패🔥 - 상태 코드: \(statusCode)")
                    completion("네트워크 요청이 실패하였습니다.")
                }
            case .failure(let error):
                print("세미나실 예약 등록 API 실패🔥 : \(error)")
                completion("네트워크 요청이 실패하였습니다.")
            }
            self.isWeekLoading = false
        }
    }

    
    func deleteReservation(reservId: Int, completion: @escaping (String) -> Void) {
        self.isLoading = true
        self.isWeekLoading = true
        provider.request(.deleteReservation(reservId: reservId)) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                        print("세미나실 예약 삭제 API 성공🔥")
                        completion("예약이 삭제되었습니다.")
                }
            case .failure(let error):
                    print("세미나실 예약 삭제 API 실패🔥: \(error)")
                    completion("네트워크 요청이 실패하였습니다")
            }
            self.isLoading = false
            self.isWeekLoading = false
        }
    }
    
    func checkUser(user: String, date: String, completion: @escaping (Bool) -> Void) {
        provider.request(.checkUser(user: user, date: date)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 401 {
                    print("인증 실패🚨: 401 에러")
                    self.alertMessage = "세미나실 이용수칙을 다시 확인해주세요"
                    completion(false)
                } else {
                    do {
                        if let responseString = String(data: response.data, encoding: .utf8) {
                            DispatchQueue.main.async {
                                print("등록 responseString : \(responseString)")
                                var checkValid: Bool
                                switch responseString {
                                case "uninformed/valid user", "informed/valid user":
                                    checkValid = true
                                case "More than 2 appointments a week":
                                    checkValid = false
                                    self.alertMessage = "일주일에 최대 2회 세미나실을 사용할 수 있습니다."
                                case "Reservation can only be made for this month and the next month":
                                    checkValid = false
                                    self.alertMessage = "세미나실은 이번달과 다음달만 예약 가능합니다."
                                default:
                                    checkValid = false
                                }
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

struct ReservInfo: Codable, Hashable {
    let studentIds: [String]
    let purpose: String
    let startDateTimeStr: String
    let endDateTimeStr: String
}

struct ErrorResponse: Decodable {
    let message: String
    let code: String
    let status: Int
    let detail: String
}
