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
                Text("1.   학부생은 세미나실2 만 사용 가능합니다.").font(.normal(size: 15))
                Text("2.   2인 이상부터 예약 가능합니다.").font(.normal(size: 15))
                Text("3.   회당 2시간 이상 예약이 불가합니다.").font(.normal(size: 15))
                Text("4.   주당 2회만 예약이 가능합니다.").font(.normal(size: 15))
                Text("5.   본인이 등록한 예약만 삭제 가능합니다.").font(.normal(size: 15))
                Text("6.   매달 1일 기준 다음달까지만 예약이 가능합니다.").font(.normal(size: 15))
                Text("7.   이미 예약된 일정에는 예약이 불가합니다.").font(.normal(size: 15))
                Text("8.   세미나실 사용 후 깨끗한 뒷정리 부탁드립니다.").font(.normal(size: 15))
            }.padding()
            Spacer()
        }
    }
}

#Preview {
    InfoModalView()
}
