////
////  NewCalendarView.swift
////  MaiN
////
////  Created by 김수민 on 1/23/24.
////
//
//import SwiftUI
//
//struct NewCalendarView: View {
//    
//    // 상태 프로퍼티
//    @State private var selectedDate: Date = Date()
//    @State var loadDataDoIt = false
//    @State var isModalPresented = false
//    @State var alertMessage = ""
//    @State var alertShow = false
//    @State var infoModalPresented = false
//    var reservationModelData: NewReservationModelData {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: selectedDate)
//        return NewReservationModelData(selectedDate: dateString)
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            VStack(alignment: .leading){
//                HStack(){
//                    Text("세미나실 예약").font(.interRegular(size: 24)).foregroundColor(.black)
//                    Spacer()
//                    Button(action: presentInfo) {Image("info").frame(width: 30, height: 30)}
//                }
//                HStack() {
//                    MonthPicker(selectedDate: selectedDate)
//                    Spacer()
//                    DayWeekPicker().frame(width: 200, height: 28)
////                    AddReservationButton(alertMessage: $alertMessage, alertShow: $alertShow, loadDataDoIt: $loadDataDoIt, selectedDate: $selectedDate, isModalPresented: $isModalPresented)
////                        .frame(width: 66, height: 35)
////                        .cornerRadius(6)
//                }
//                WeekView(selectedDate: $selectedDate)
//                
//            }.padding(.horizontal, 28)
//                .padding(.top, 15)
//            
////            VStack(spacing: 0){
////                HStack(){
////                    Spacer().frame(width: 40)
//                
////                    Spacer()
////                    
////                }.frame(height: 61)
////            }.padding(3).background(.white)
////            Spacer()
//            NewClassroomScheduleView(alertMessage: $alertMessage, alertShow: $alertShow, selectedDate: $selectedDate, loadDataDoIt: $loadDataDoIt)
//            Spacer()
//        }.background(.white)
//        .sheet(isPresented: $infoModalPresented) {
//            InfoModalView()
//                .presentationDetents([.fraction(0.4)])
//        }
//    }
//
//    func presentInfo() {
//        infoModalPresented = true
//    }
//}
//
//struct InfoModalView: View {
//    var body: some View {
//        VStack {
//            Spacer().frame(height: 20)
//            Text("세미나실 예약 수칙")
//                .font(.bold(size: 20))
//            VStack(alignment: .leading, spacing: 10) {
//                Text("1. 회당 2시간 이상 예약이 불가합니다.").font(.normal(size: 15))
//                Text("2. 주당 2회만 예약이 가능합니다.").font(.normal(size: 15))
//                Text("3. 본인이 한 예약만 삭제 가능합니다").font(.normal(size: 15))
//                Text("4. 매달 1일 기준 다음달까지만 예약이 가능합니다").font(.normal(size: 15))
//                Text("5. 이미 예약된 일정에는 예약이 불가합니다.").font(.normal(size: 15))
//                Text("6. 교수회의실은 교수님들 외에 예약이 불가합니다.").font(.normal(size: 15))
//            }.padding()
//            Spacer()
//        }
//    }
//}
//
//#Preview {
//    NewCalendarView()
//    
//}
