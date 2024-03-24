//
//  FontManager.swift
//  MaiN
//
//  Created by 김수민 on 1/9/24.
//

import SwiftUI

extension Font {
    static func normal(size: CGFloat) -> Font {
        return .custom("Lato-Regular", size: size)
    }
    static func bold(size: CGFloat) -> Font {
        return .custom("Lato-Bold", size: size)
    }
    static func light(size: CGFloat) -> Font {
        return .custom("Lato-Light", size: size)
    }
}
