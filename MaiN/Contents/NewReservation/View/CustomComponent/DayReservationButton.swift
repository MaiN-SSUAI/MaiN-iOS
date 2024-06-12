//
//  DayReservationButton.swift
//  MaiN
//
//  Created by 김수민 on 5/22/24.
//

import SwiftUI

struct DayReservationButton: View {
    @ObservedObject var vm: ReservationViewModel
    let date: Date
    let time: String
    let studentNo: [String]
    let buttonColor: ButtonColor
    let reservId: Int
    let startPixel: CGFloat
    let endPixel: CGFloat

    init(vm: ReservationViewModel, reservation: Reservation, color: ButtonColor) {
        self.vm = vm
        self.date = reservation.start.toDate()
        if vm.dayOrWeek == "day" {
            self.time = "\(DayReservationButton.dayFormatTime(reservation.start)) ~ \(DayReservationButton.dayFormatTime(reservation.end))"
        } else {
            self.time = "\(DayReservationButton.weekFormatTime(reservation.start)) ~ \(DayReservationButton.weekFormatTime(reservation.end))"
        }
        self.studentNo = reservation.studentNo
        self.reservId = reservation.reservId
        self.buttonColor = color
        self.startPixel = CGFloat(Double(reservation.start_pixel) ?? 0)
        self.endPixel = CGFloat(Double(reservation.end_pixel) ?? 0)
    }

    var body: some View {
        VStack() {
            Spacer()
                .frame(height: startPixel)
            Button(action: {
                if vm.dayOrWeek == "day" {
                    vm.selectedDetailReservInfo = ReservDetailInfo(reservId: reservId, studentIds: studentNo, purpose: "", time: time)
                    vm.isDetailModalPresented = true
                } else {
                    vm.dayOrWeek = "day"
                    vm.selectedDate = self.date
                }
            }, label: {
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        if vm.dayOrWeek == "day" {
                            Text("\(time)")
                                .foregroundColor(buttonColor.pointColor)
                            //                            .font(.interSemiBold(size: 12))
                                .font(.bold(size: 12))
                            Text(studentNo[0])
                                .foregroundColor(buttonColor.pointColor)
                                .font(.interRegular(size: 12))
                        } else {
                            Text(studentNo[0].trimmingCharacters(in: .whitespaces))
                                .foregroundColor(buttonColor.pointColor)
                            //                            .font(.interSemiBold(size: 12))
                                .font(.bold(size: 9))
                        }
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, vm.dayOrWeek == "day" ? 15 : 3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                    .frame(height: (endPixel - startPixel))
                    .background(buttonColor.backgroundColor)
                    .cornerRadius(4)
                    
                    if vm.dayOrWeek == "day" {
                        RoundedCornerRectangle(cornerRadius: 4, corners: [.topLeft, .bottomLeft])
                            .frame(maxHeight: .infinity)
                            .frame(maxWidth: 5)
                            .foregroundColor(buttonColor.pointColor)
                    }
                }
            })
            .sheet(isPresented: $vm.isDetailModalPresented) {
                DetailReservModalView(vm: vm)
                    .presentationDetents([.fraction(0.3)])
            }
        }.frame(height: endPixel)
    }

    static func dayFormatTime(_ dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatterHour = DateFormatter()
        outputFormatterHour.dateFormat = "a h시"
        outputFormatterHour.locale = Locale(identifier: "ko_KR")
        
        let outputFormatterMinute = DateFormatter()
        outputFormatterMinute.dateFormat = "mm분"
        outputFormatterMinute.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateTimeString) {
            let hourString = outputFormatterHour.string(from: date)
            let minuteString = outputFormatterMinute.string(from: date)

            if minuteString == "00분" {
                return hourString
            } else {
                return "\(hourString) \(minuteString)"
            }
        } else {
            return dateTimeString
        }
    }
    
    static func weekFormatTime(_ dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatterHour = DateFormatter()
        outputFormatterHour.dateFormat = "h : "
        outputFormatterHour.locale = Locale(identifier: "ko_KR")
        
        let outputFormatterMinute = DateFormatter()
        outputFormatterMinute.dateFormat = "mm"
        outputFormatterMinute.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateTimeString) {
            let hourString = outputFormatterHour.string(from: date)
            let minuteString = outputFormatterMinute.string(from: date)

//            if minuteString == "00" {
//                return hourString
//            } else {
                return "\(hourString) \(minuteString)"
//            }
        } else {
            return dateTimeString
        }
    }
}

struct ReservDetailInfo: Codable {
    let reservId: Int
    let studentIds: [String]
    let purpose: String
    let time: String
}

enum ButtonColor {
    case green
    case orange
    case red
    case purple
    case blue

    var pointColor: Color {
        switch self {
        case .green:
            return .color0
        case .orange:
            return .color1
        case .red:
            return .color2
        case .purple:
            return .color3
        case .blue:
            return .color4
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .green:
            return .color01
        case .orange:
            return .color02
        case .red:
            return .color03
        case .purple:
            return .color04
        case .blue:
            return .color05
        }
    }
}

struct RoundedCornerRectangle: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
