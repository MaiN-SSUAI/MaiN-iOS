//import SwiftUI
//
//struct NewClassroomScheduleView: View {
//    @Binding var alertMessage: String
//    @Binding var alertShow: Bool
//    @Binding var selectedDate: Date
//    // 모달뷰 관련
//    @Binding var loadDataDoIt: Bool
//    @State var selectedBlock: Bool = false
//    
//    @ObservedObject var reservationModelData: NewReservationModelData
//    @ObservedObject var selectedReservationData: NewSelectedReservationData = NewSelectedReservationData()
//    
//    init(alertMessage: Binding<String>, alertShow: Binding<Bool>, selectedDate: Binding<Date>, loadDataDoIt: Binding<Bool>) {
//        self._alertMessage = alertMessage
//        self._alertShow = alertShow
//        self._selectedDate = selectedDate
//        self._loadDataDoIt = loadDataDoIt
//        self.reservationModelData = NewReservationModelData(selectedDate: selectedDate.wrappedValue.toDateString())
//        self.reservationModelData.setAPIValue()
//    }
//    func extractNumber(from input: String) -> String? {
//        let parts = input.components(separatedBy: "/")
//        if let lastPart = parts.last, let _ = Int(lastPart) {
//            return lastPart
//        }
//        return nil
//    }
//    var body: some View {
////        if reservationModelData.isLoading {
////            ProgressView()
////        } else {
//            ScrollView(){
//                HStack(spacing: 0){
//                    TimeView().padding(.top, 5).padding(.trailing, 7)
//                    FirstSeminarView(firstSeminarInfo: reservationModelData.firstSeminarRoom, selectedReservationData: selectedReservationData, selectedBlock: $selectedBlock)
//                    SecondSeminarView(secondSeminarInfo: reservationModelData.secondSeminarRoom, selectedReservationData: selectedReservationData,selectedBlock: $selectedBlock)
//                    ThirdSeminarView(thirdSeminarInfo: reservationModelData.thirdSeminarRoom, selectedReservationData: selectedReservationData, selectedBlock: $selectedBlock)
//                }.padding()
//            }.sheet(isPresented: $selectedBlock, content: {
//                NewDeleteHalfModalView(alertMessage: $alertMessage, alertShow: $alertShow, loadDataDoIt: $loadDataDoIt, isPresented: $selectedBlock, summary: selectedReservationData.summary, eventID: selectedReservationData.eventID, start: selectedReservationData.start, end: selectedReservationData.end, resStudentId: extractNumber(from: selectedReservationData.summary) ?? "학번 오류").presentationDetents([.fraction(0.2)]).cornerRadius(20)
//            })
//            .alert(isPresented: $alertShow) {
//                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인"), action: {
////                    isModalPresented = false
////                    loadDataDoIt.toggle() // 모달이 닫힌 후에 데이터 로딩 상태를 업데이트
//                }))
//            }
////        }
//    }
//}
//
//
//
//struct TimeView: View {
//    // 24시간 형식의 시간 배열
//    private let timeArray: [String] = (0...23).map { String(format: "%02d:00", $0) }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(timeArray, id: \.self) { time in
//                Text(time)
//                    .font(.normal(size: 10))
//                    .foregroundColor(.gray01)
//                    .padding(.bottom, 23)
//            }
//        }.frame(width: 30)
//    }
//}
//
//struct FirstSeminarView: View {
//    var vm: ReservationViewModel
//    var firstSeminarInfo: [NewReservation]
//    var selectedReservationData: NewSelectedReservationData
//    @Binding var selectedBlock: Bool
//    
//    var body: some View {
//        VStack(spacing: 0){
//            if (firstSeminarInfo.count != 0) {
//                ForEach(Array(zip(firstSeminarInfo.indices, firstSeminarInfo)), id: \.1.self) { (index, time) in
//                    if (index == 0){
//                        Spacer().frame(height: CGFloat(Int(time.start_pixel) ?? 0))
//                    } else {
//                        let previousEndPixel = Int(firstSeminarInfo[index - 1].end_pixel) ?? 0
//                        let currentStartPixel = Int(time.start_pixel) ?? 0
//                        let spacerHeight = max(0, currentStartPixel - previousEndPixel-1)
//                        Spacer().frame(height: CGFloat(spacerHeight))
//                    }
//                    Button(action: {selectedBlock = true
//                        selectedReservationData.start =  time.start
//                        selectedReservationData.end =  time.end
//                        selectedReservationData.summary =  time.summary
//                        selectedReservationData.eventID =  time.eventid
//                        print(time.eventid)}){
//                        VStack(alignment: .leading, spacing: 0){
//                            Spacer().frame(height: 8)
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(timeStringToDate(isoDateString: time.start)) ~ \(timeStringToDate(isoDateString: time.end))").font(.bold(size: 12)).foregroundColor(.white)
//                                Spacer()
//                            }
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(time.summary)").font(.normal(size: 9))
//                                    .foregroundColor(.white)
//                                Spacer()
//                            }
//                            Spacer()
//                        }.frame(width: 110, height: frameHeight(for: time)).background(.reservationBlueBlock)
//                                .overlay(
//                            RoundedRectangle(cornerRadius: 0)
//                                .stroke(Color.white, lineWidth: 3)
//                        )
//                    }
//                }
//            } else {
//                Rectangle().fill(.white).frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            Spacer()
//        }
//    }
//    private func frameHeight(for reservation: NewReservation) -> CGFloat {
//        let startPixel = Int(reservation.start_pixel) ?? 0
//        let endPixel = Int(reservation.end_pixel) ?? 0
//        return CGFloat(max(0, endPixel - startPixel-5))
//    }
//    func timeStringToDate(isoDateString: String) -> String {
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        guard let date = isoFormatter.date(from: isoDateString) else {
//            print("Invalid date string")
//            exit(1)
//        }
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm"
//        let timeString = timeFormatter.string(from: date)
//        return timeString
//    }
//    
//}
//
//struct SecondSeminarView: View {
//    var secondSeminarInfo: [NewReservation]
//    var selectedReservationData: NewSelectedReservationData
//    @Binding var selectedBlock: Bool
//    private func frameHeight(for reservation: NewReservation) -> CGFloat {
//        let startPixel = Int(reservation.start_pixel) ?? 0
//        let endPixel = Int(reservation.end_pixel) ?? 0
//        return CGFloat(max(0, endPixel - startPixel - 5))
//    }
//    func timeStringToDate(isoDateString: String) -> String {
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        guard let date = isoFormatter.date(from: isoDateString) else {
//            print("Invalid date string")
//            exit(1)
//        }
//        // Date 객체를 원하는 시간 형식으로 변환
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm"
//        let timeString = timeFormatter.string(from: date)
//        return timeString
//    }
//    var body: some View {
//        VStack(spacing: 0){
//            if (secondSeminarInfo.count != 0){
//                ForEach(Array(zip(secondSeminarInfo.indices, secondSeminarInfo)), id: \.1.self) { (index, time) in
//                    if (index == 0){
//                        Spacer().frame(height: CGFloat(Int(time.start_pixel) ?? 0)).onAppear(perform: {print("\(time.start_pixel)")})
//                    } else {
//                        let previousEndPixel = Int(secondSeminarInfo[index - 1].end_pixel) ?? 0
//                        let currentStartPixel = Int(time.start_pixel) ?? 0
//                        let spacerHeight = max(0, currentStartPixel - previousEndPixel - 1)
//                        Spacer().frame(height: CGFloat(spacerHeight))
//                    }
//                    Button(action: {selectedBlock = true
//                        selectedReservationData.start =  time.start
//                        selectedReservationData.end =  time.end
//                        selectedReservationData.summary =  time.summary
//                        selectedReservationData.eventID =  time.eventid}){
//                        VStack(alignment: .leading, spacing: 0){
//                            Spacer().frame(height: 8)
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(timeStringToDate(isoDateString: time.start)) ~ \(timeStringToDate(isoDateString: time.end))").font(.bold(size: 12)).foregroundColor(.white)
//                                Spacer()
//                            }
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(time.summary)").font(.normal(size: 9))
//                                    .foregroundColor(.white)
//                                Spacer()
//                            }
//                            Spacer()
//                        }.frame(width: 110, height: frameHeight(for: time)).background(.reservationRedBlock).overlay(
//                            RoundedRectangle(cornerRadius: 0)
//                                .stroke(Color.white, lineWidth: 3)
//                        )
//                    }
//                }
//            } else {
//                Rectangle().fill(.white).frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            Spacer()
//        }
//    }
//}
//
//struct ThirdSeminarView: View {
//    var thirdSeminarInfo: [NewReservation]
//    var selectedReservationData: NewSelectedReservationData
//    @Binding var selectedBlock: Bool
//    private func frameHeight(for reservation: NewReservation) -> CGFloat {
//            let startPixel = Int(reservation.start_pixel) ?? 0
//            let endPixel = Int(reservation.end_pixel) ?? 0
//            return CGFloat(max(0, endPixel - startPixel - 5))
//    }
//    func timeStringToDate(isoDateString: String) -> String {
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        guard let date = isoFormatter.date(from: isoDateString) else {
//            print("Invalid date string")
//            exit(1)
//        }
//        // Date 객체를 원하는 시간 형식으로 변환
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm"
//        let timeString = timeFormatter.string(from: date)
//        return timeString
//    }
//    var body: some View {
//        VStack(spacing: 0){
//            if (thirdSeminarInfo.count != 0){
//                ForEach(Array(zip(thirdSeminarInfo.indices, thirdSeminarInfo)), id: \.1.self) { (index, time) in
//                    if (index == 0){
//                        Spacer().frame(height: CGFloat(Int(time.start_pixel) ?? 0)).onAppear(perform: {print("\(time.start_pixel)")})
//                    } else {
//                        let previousEndPixel = Int(thirdSeminarInfo[index - 1].end_pixel) ?? 0
//                        let currentStartPixel = Int(time.start_pixel) ?? 0
//                        let spacerHeight = max(0, currentStartPixel - previousEndPixel)
//                        
//                        Spacer().frame(height: CGFloat(spacerHeight))
//                    }
//                    Button(action: {selectedBlock = true
//                        selectedReservationData.start =  time.start
//                        selectedReservationData.end =  time.end
//                        selectedReservationData.summary =  time.summary
//                        selectedReservationData.eventID =  time.eventid}){
//                        VStack(alignment: .leading, spacing: 0){
//                            Spacer().frame(height: 8)
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(timeStringToDate(isoDateString: time.start)) ~ \(timeStringToDate(isoDateString: time.end))").font(.bold(size: 12)).foregroundColor(.white)
//                                Spacer()
//                            }
//                            HStack(spacing: 0){
//                                Spacer().frame(width: 8)
//                                Text("\(time.summary)").font(.normal(size: 9))
//                                    .foregroundColor(.white)
//                                Spacer()
//                            }
//                            Spacer()
//                        }.frame(width: 110, height: frameHeight(for: time)).background(.reservationYellowBlock).overlay(
//                            RoundedRectangle(cornerRadius: 0)
//                                .stroke(Color.white, lineWidth: 3)
//                        )
//                    }
//                }
//            } else {
//                Rectangle().fill(.white).frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            Spacer()
//        }
//    }
//}
//
