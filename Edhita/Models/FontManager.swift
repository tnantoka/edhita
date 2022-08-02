//
//  FontManager.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/02.
//

import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()

    private init() {}

    static let defaultFontName = "CourierNewPSMT"
    static let defaultFontSize = UIFont.systemFontSize
    static let defaultTextColor = Color.black
    static let defaultBackgroundColor = Color.white

    lazy var fontNames: [String] = {
        Array(
            UIFont.familyNames.map { familyName in
                UIFont.fontNames(forFamilyName: familyName).map { $0 }
            }.joined()
        )
    }()

    var fontSizes: [CGFloat] {
        Array(8...32).map { CGFloat($0) }
    }

    static func font(for name: String) -> Font {
        Font.custom(name, size: UIFont.systemFontSize)
    }
}
