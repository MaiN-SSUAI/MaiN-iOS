//
//  NewCalendarView.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import SwiftUI

struct NewCalendarView: View {
    
    @State private var selectedDate: Date = Date()
    @State var loadDataDoIt = false
    @State var isModalPresented = false
    @State var alertMessage = ""
    @State var alertShow = false
    var reservationModelData: NewReservationModelData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        return NewReservationModelData(selectedDate: dateString)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(){
                Text("세미나실 예약").font(.bold(size: 30)).foregroundColor(.black)
                Spacer()
            }.padding(.top, 50).padding(.leading, 40)
                .padding(.bottom, 10)
            HStack() {
                NewMonthView(selectedDate: $selectedDate)
                    .frame(width:130,height:28).padding(.leading, 7)
                Spacer()
                AddReservationButton(alertMessage: $alertMessage, alertShow: $alertShow, loadDataDoIt: $loadDataDoIt, selectedDate: $selectedDate, isModalPresented: $isModalPresented)
                    .frame(width: 66, height: 35)
                    .cornerRadius(6)
            }.padding()
            VStack(spacing: 0){
                HStack(){
                    Spacer().frame(width: 40)
                    WeekView(selectedDate: $selectedDate)
                    Spacer()
                    
                }.frame(height: 61)
            }.padding(3).background(.white)
            Spacer()
            NewClassroomScheduleView(alertMessage: $alertMessage, alertShow: $alertShow, selectedDate: $selectedDate, loadDataDoIt: $loadDataDoIt)
            Spacer()
        }.background(.white)
        .onChange(of: loadDataDoIt) {
            print("loadDataDoIt 바뀜")
        }
    }
}

#Preview {
    NewCalendarView()
    
}
