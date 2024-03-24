//
//  FixView.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import SwiftUI

struct FixView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(){
            HStack(){
                Button(action: {self.presentationMode.wrappedValue.dismiss()}){
                    Image("ic_back")
                }.padding()
                Spacer()
            }
            Spacer()
            Text("준비중입니다..")
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FixView()
}
