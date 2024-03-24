//
//  AddReservationButton.swift
//  MaiN
//
//  Created by 김수민 on 1/11/24.
//

import SwiftUI
import Moya
struct AddReservationButton: View {
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
            AddFirstSeminarModal(isModalPresented: $isModalPresented, reservationDate: $selectedDate, loadDataDoIt: $loadDataDoIt)
                .presentationDetents([.fraction(0.5)])
        }
    }
    func representAddModal() {
        isModalPresented.toggle()
    }

}

struct AddFirstSeminarModal: View {
    @State var startTime = Date()
    @State var endTime = Date()
    @State var wakeUp = Date()
    @Binding var isModalPresented: Bool
    @State var selectedSeminarRoom = "세미나실1"
    let studentID: String = UserDefaults.standard.string(forKey: "schoolNumber") ?? "정보 없음"
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
                    loadReservationData(seminarRoom: selectedSeminarRoom,summary: studentID, startDateTimeStr: convertDateString(inputString: startTime), endDateTimeStr: convertDateString(inputString: endTime)){ success in
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
        }
        .onChange(of: reservationDate) { newDate in
            self.startTime = newDate
            self.endTime = newDate
        }
        .background(.gray00)
    }
    
    func loadReservationData(seminarRoom: String, summary: String, startDateTimeStr: String, endDateTimeStr: String, completion: @escaping (Bool) -> Void){
        let provider = MoyaProvider<NewReservationAPI>()
        let startDateTimeStr = startDateTimeStr
        let endDateTimeStr = endDateTimeStr
        provider.request(.addReservation(location: seminarRoom, student_id: summary, startDateTimeStr: startDateTimeStr, endDateTimeStr: endDateTimeStr)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    completion(true)
                } catch {
                    completion(true)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func convertDateString(inputString: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return outputFormatter.string(from: inputString)
    }
}

