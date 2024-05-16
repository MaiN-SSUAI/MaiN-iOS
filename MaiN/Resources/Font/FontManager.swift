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
    static func semiBold(size: CGFloat) -> Font {
        return .custom("Lato-SemiBold", size: size)
    }

    // MARK: Inter
    static func interRegular(size: CGFloat) -> Font {
        return .custom("Inter-Regular", size: size)
    }
    static func interSemiBold(size: CGFloat) -> Font {
        return .custom("Inter-SemiBold", size: size)
    }
    static func interBold(size: CGFloat) -> Font {
        return .custom("Inter-Bold", size: size)
    }
    static func interExtraBold(size: CGFloat) -> Font {
        return .custom("Inter-ExtraBold", size: size)
    }
}
