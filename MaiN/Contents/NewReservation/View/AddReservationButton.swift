//
//  AddReservationButton.swift
//  MaiN
//
//  Created by 김수민 on 1/11/24.
//

import SwiftUI
import Moya
struct AddReservationButton: View {
    @Binding var alertMessage: String
    @Binding var alertShow: Bool
    @Binding var loadDataDoIt: Bool
    @Binding var selectedDate: Date
    @Binding var isModalPresented: Bool
    var body: some View {
        Button(action: representAddModal){
            Text("예약")
                .font(.normal(size: 15))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
        }.sheet(isPresented: $isModalPresented) {
            AddFirstSeminarModal(alertMessage: $alertMessage, alertShow: $alertShow, isModalPresented: $isModalPresented, reservationDate: $selectedDate, loadDataDoIt: $loadDataDoIt)
                .presentationDetents([.fraction(0.5)])
        }
    }
    func representAddModal() {
        isModalPresented.toggle()
    }

}

struct AddFirstSeminarModal: View {
    @Binding var alertMessage: String
    @Binding var alertShow: Bool
    @State var startTime = Date()
    @State var endTime = Date()
    @State var wakeUp = Date()
    @Binding var isModalPresented: Bool
    @State var selectedSeminarRoom = "세미나실1"
    let studentID: String = UserDefaults.standard.string(forKey: "studentNumber") ?? "정보 없음"
    var seminarRooms = ["세미나실1", "세미나실2", "교수회의실"]
    @Binding var reservationDate: Date
    @Binding var loadDataDoIt: Bool
    var body: some View {
        VStack(){
            VStack(spacing : 3){
                Text("등록하기").font(.normal(size: 15))
                    .foregroundColor(.black)
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                Picker("세미나실 선택", selection: $selectedSeminarRoom) {
                    ForEach(seminarRooms, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                HStack {
                    Text("학번")
                        .font(.normal(size: 15))
                        .foregroundColor(.black)
                        .frame(width: 100, alignment: .leading)
                        .padding(10)
                        .background(Color.white)
                    Spacer()
                    Text("\(studentID)").font(.bold(size: 15)).foregroundColor(.black).padding(.trailing, 10)
                }
                .padding(9)
                .background(Color.white)
                
                HStack {
                    Text("시작 시간")
                        .font(.normal(size: 15))
                        .frame(width: 100, alignment: .leading)
                        .padding(10)
                        .foregroundColor(.black)
                    Spacer()
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(9)
                .background(Color.white)
                
                HStack {
                    Text("종료 시간")
                        .font(.normal(size: 15))
                        .frame(width: 100, alignment: .leading)
                        .padding(10)
                        .foregroundColor(.black)
                    Spacer()
                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(9)
                .background(Color.white)
                
                Button(action: {
                    isModalPresented = false
//                    loadDataDoIt.toggle()
                    alertShow = true
                    loadReservationData(seminarRoom: selectedSeminarRoom,summary: studentID, startDateTimeStr: convertDateString(inputString: startTime), endDateTimeStr: convertDateString(inputString: endTime)){ success,message  in
                        loadDataDoIt.toggle()
                    }}){
                        Text("저장").font(.bold(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(.reservationBlueBlock)
                    }.frame(width: 290).cornerRadius(20).padding(10)
                Spacer()
            }
        }
        .onAppear {
            self.startTime = reservationDate
            self.endTime = reservationDate
        }.onChange(of: reservationDate) { newDate in
            self.startTime = newDate
            self.endTime = newDate
        }
        .background(.gray00)
    }
    
    func loadReservationData(seminarRoom: String, summary: String, startDateTimeStr: String, endDateTimeStr: String, completion: @escaping (Bool, String?) -> Void) {
        let provider = MoyaProvider<NewReservationAPI>()
        let startDateTimeStr = startDateTimeStr
        let endDateTimeStr = endDateTimeStr
        provider.request(.addReservation(location: seminarRoom, student_id: summary, startDateTimeStr: startDateTimeStr, endDateTimeStr: endDateTimeStr)) { result in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode == 200 {
                        alertMessage = "예약이 등록되었습니다."
                        completion(true, nil)
                    } else {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                        let message = json?["message"] as? String ?? "알 수 없는 오류가 발생했습니다."
                        handleServerError(message: message)
                        completion(false, message)
                    }
                } catch {
                    completion(false, "데이터 처리 중 오류가 발생했습니다.")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func convertDateString(inputString: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return outputFormatter.string(from: inputString)
    }
    
    func handleServerError(message: String?) {
        if let message = message {
            switch message {
            case "More than 2 hours":
                alertMessage = "회당 2시간 이상 예약이 불가합니다."
            case "Event Overlaps":
                alertMessage = "해당 일정에 이미 예약된 일정이 존재합니다."
            case "More than 2 appointments a week":
                alertMessage = "주당 2회만 예약이 가능합니다."
            case "Reservation can only be made for this month and the next month":
                alertMessage = "매달 1일 기준 다음달까지만 예약이 가능합니다."
            default:
                alertMessage = "예약 처리 중 오류가 발생했습니다."
            }
        }
    }

}

