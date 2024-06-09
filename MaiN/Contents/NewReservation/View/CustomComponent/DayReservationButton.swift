//
//  DayReservationButton.swift
//  MaiN
//
//  Created by 김수민 on 5/22/24.
//

import SwiftUI

struct DayReservationButton: View {
    @ObservedObject var vm: ReservationViewModel
    let time: String
    let studentNo: [String]
    let buttonColor: ButtonColor
    let reservId: Int
    let startPixel: CGFloat
    let endPixel: CGFloat

    init(vm: ReservationViewModel, reservation: Reservation, color: ButtonColor) {
        self.vm = vm
        self.time = "\(DayReservationButton.formatTime(reservation.start)) ~ \(DayReservationButton.formatTime(reservation.end))"
        self.studentNo = reservation.studentNo
        self.reservId = reservation.reservId
        self.buttonColor = color
        self.startPixel = CGFloat(Double(reservation.start_pixel) ?? 0)
        self.endPixel = CGFloat(Double(reservation.end_pixel) ?? 0)
    }

    var body: some View {
        VStack() {
            Spacer()
                .frame(height: startPixel+12)
            Button(action: {
                vm.isDetailModalPresented = true
            }, label: {
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(time)")
                            .foregroundColor(buttonColor.pointColor).font(.interSemiBold(size: 12))
                        Text(studentNo[0])
                            .foregroundColor(buttonColor.pointColor)
                            .font(.interRegular(size: 12))
                    }
                    .padding(.top, 5)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                    .frame(height: (endPixel - startPixel))
                    .background(buttonColor.backgroundColor)
                    .cornerRadius(4)
                    
                    RoundedCornerRectangle(cornerRadius: 4, corners: [.topLeft, .bottomLeft])
                        .frame(maxHeight: .infinity)
                        .frame(maxWidth: 5)
                        .foregroundColor(buttonColor.pointColor)
                }
            })
        }.frame(height: endPixel)
    }

    static func formatTime(_ dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h시"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateTimeString) {
            return outputFormatter.string(from: date)
        } else {
            return dateTimeString
        }
    }
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
