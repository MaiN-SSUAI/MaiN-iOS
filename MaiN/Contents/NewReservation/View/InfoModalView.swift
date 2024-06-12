//
//  InfoModalView.swift
//  MaiN
//
//  Created by 김수민 on 6/13/24.
//

import SwiftUI

struct InfoModalView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            Text("세미나실 예약 수칙")
                .font(.bold(size: 20))
            VStack(alignment: .leading, spacing: 10) {
                Text("1. 회당 2시간 이상 예약이 불가합니다.").font(.normal(size: 15))
                Text("2. 주당 2회만 예약이 가능합니다.").font(.normal(size: 15))
                Text("3. 본인이 한 예약만 삭제 가능합니다").font(.normal(size: 15))
                Text("4. 매달 1일 기준 다음달까지만 예약이 가능합니다").font(.normal(size: 15))
                Text("5. 이미 예약된 일정에는 예약이 불가합니다.").font(.normal(size: 15))
                Text("6. 교수회의실은 교수님들 외에 예약이 불가합니다.").font(.normal(size: 15))
            }.padding()
            Spacer()
        }
    }
}

#Preview {
    InfoModalView()
}
