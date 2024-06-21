//
//  TimeView.swift
//  MaiN
//
//  Created by 김수민 on 6/22/24.
//

import SwiftUI

struct TimeView: View {
    private let timeArray: [String] = (0...23).map {
        let hour = $0 % 12
        let period = $0 < 12 ? "오전" : "오후"
        return String(format: "%@ %d시", period, hour == 0 ? 12 : hour)
    }

    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(timeArray.enumerated()), id: \.element) { index, time in
                Text(time)
                    .font(.interRegular(size: 12))
                    .foregroundColor(.gray01)
                    .frame(width: 50)
                    .padding(.top, CGFloat(36 * index))
            }
        }
    }
}

#Preview {
    TimeView()
}
