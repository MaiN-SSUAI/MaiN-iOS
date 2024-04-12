//
//  NewDeleteHalfModalView.swift
//  MaiN
//
//  Created by 김수민 on 1/27/24.
//

import SwiftUI
import Moya

struct NewDeleteHalfModalView: View {

    @State private var isDeleteConfirmationPresented = false
    @Binding var loadDataDoIt: Bool
    @Binding var isPresented: Bool
    
    var summary: String
    var eventID: String
    var start: String
    var end: String
    let studentId: String = UserDefaults.standard.string(forKey: "schoolNumber") ?? "정보없음"
    
    func timeStringToTime(isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoDateString) else {
            print("Invalid date string")
            exit(1)
        }
        // Date 객체를 원하는 시간 형식으로 변환
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)
        return timeString
    }
    
    func timeStringToDate(isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoDateString) else {
            print("Invalid date string")
            return "Invalid date"
        }
        // Date 객체를 원하는 날짜 형식으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 5){
                Spacer().frame(height: 15)
                Text("세부 정보").font(.normal(size: 15)).foregroundColor(.black)
                HStack(){
                    Spacer()
                    Button(action: {isPresented.toggle()}){
                        Image(systemName: "xmark").foregroundColor(.black).padding()
                    }
                }
            }.background(.white)
            HStack(){
                VStack(alignment: .leading) {
                    Text(self.summary).font(.normal(size: 15)).foregroundColor(.black)
                    Text(timeStringToDate(isoDateString: self.start)).font(.normal(size: 13)).foregroundColor(.gray02)
                    Text("\(timeStringToTime(isoDateString: self.start)) ~ \(timeStringToTime(isoDateString: self.end))").font(.normal(size: 13)).foregroundColor(.gray02)
                }
                .padding()
                .padding(.leading, 18)
                
                Spacer()
                Button(action: {
                    isDeleteConfirmationPresented = true
                }) {
                    Text("삭제").font(.normal(size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(.red00)
                        .cornerRadius(6)
                }.padding(.trailing, 20)
                .confirmationDialog("정말로 삭제하겠습니까?", isPresented: $isDeleteConfirmationPresented, actions: {
                    Button("삭제", role: .destructive) {
                        isPresented = false
                        deleteReservationData(eventID: self.eventID) { success in
                            loadDataDoIt.toggle()
                        }
                    }
                    Button("취소", role: .cancel) { }
                })
            }.background(.white)
            Spacer().background(.white)
        }.background(.white)
    }
        
    func deleteReservationData(eventID: String,  completion: @escaping(Bool) -> Void){
        let provider = MoyaProvider<NewReservationAPI>()
        provider.request(.deleteReservation(eventId: eventID)) { result in
            switch result {
            case .success(let response):
                completion(true)
            case .failure(let error):
                completion(true)
            }
        }
    }
}
