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
    let purpose: String
    let studentNo: [String]
    let buttonColor: ButtonColor
    let reservId: Int
    let startPixel: CGFloat
    let endPixel: CGFloat
    let startTime: String
    let endTime: String
    let isMini: Bool = UserDefaults.standard.bool(forKey: "mini")
    
    init(vm: ReservationViewModel, reservation: Reservation, color: ButtonColor) {
        self.vm = vm
        self.date = reservation.start.toDate()
        if vm.dayOrWeek == "day" {
            self.time = "\(DayReservationButton.dayFormatTime(reservation.start)) ~ \(DayReservationButton.dayFormatTime(reservation.end))"
        } else {
            self.time = "\(DayReservationButton.weekFormatTime(reservation.start)) ~ \(DayReservationButton.weekFormatTime(reservation.end))"
        }
        self.purpose = reservation.purpose
        self.studentNo = reservation.studentNo
        self.reservId = reservation.reservId
        self.buttonColor = color
        self.startPixel = CGFloat(Double(reservation.start_pixel) ?? 0)
        self.endPixel = CGFloat(Double(reservation.end_pixel) ?? 0)
        self.startTime = DayReservationButton.dayFormatTime(reservation.start)
        self.endTime = DayReservationButton.dayFormatTime(reservation.end)
    }

    var body: some View {
        VStack() {
            Spacer()
                .frame(height: startPixel)
            Button(action: {
                vm.selectedDetailReservInfo = ReservDetailInfo(reservId: reservId, studentIds: studentNo, purpose: purpose, time: time, startTime: startTime, endTime: endTime)
                vm.isDetailModalPresented = true
            }, label: {
                ZStack(alignment: .leading) {
                    
                    if vm.dayOrWeek == "day" {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(time)")
                                .foregroundColor(buttonColor.pointColor)
                                .font(.bold(size: 12))
                            Text(studentNo.joined(separator: ", "))
                                .foregroundColor(buttonColor.pointColor)
                                .font(.interRegular(size: 12))
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .frame(height: (endPixel - startPixel))
                        .background(buttonColor.backgroundColor)
                        .cornerRadius(4)
                    } else {
                        VStack(alignment: .center, spacing: 0) {
                            Text(studentNo.joined(separator: "\n"))
                                .foregroundColor(buttonColor.pointColor)
                                .font(.bold(size: isMini ? 7 : 8))
                            Spacer()
                        }
                        .padding(.top, 5)
//                        .padding(.horizontal, isMini ? 7 : 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: (endPixel - startPixel))
                        .background(buttonColor.backgroundColor)
                    }
                    
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
                    .presentationDetents(isMini ? [.fraction(0.6)] : [.fraction(0.5)])
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
        outputFormatterHour.dateFormat = "h:"
        outputFormatterHour.locale = Locale(identifier: "ko_KR")
        
        let outputFormatterMinute = DateFormatter()
        outputFormatterMinute.dateFormat = "mm"
        outputFormatterMinute.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateTimeString) {
            let hourString = outputFormatterHour.string(from: date)
            let minuteString = outputFormatterMinute.string(from: date)
                return "\(hourString)\(minuteString)"
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
    let startTime: String
    let endTime: String
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
