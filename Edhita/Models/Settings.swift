//
//  Settings.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/02.
//

import SwiftUI
import UIKit

class Settings {
    static let shared = Settings()

    private init() {}

    struct Keys {
        static let keyboardAccessory = "keyboardAccessory"
        static let fontName = "fontName"
        static let fontSize = "fontSize"
        static let textColor = "textColor"
        static let backgroundColor = "backgroundColor"
    }

    var keyboardAccessory: Bool {
        get {
            if let _ = UserDefaults.standard.value(forKey: Keys.keyboardAccessory) {
                return UserDefaults.standard.bool(forKey: Keys.keyboardAccessory)
            } else {
                return true
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.keyboardAccessory)
        }
    }

    var fontName: String {
        get {
            UserDefaults.standard.string(forKey: Keys.fontName) ?? FontManager.defaultFontName
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.fontName)
        }
    }

    var fontSize: CGFloat {
        get {
            if let _ = UserDefaults.standard.value(forKey: Keys.fontSize) {
                return CGFloat(UserDefaults.standard.float(forKey: Keys.fontSize))
            } else {
                return FontManager.defaultFontSize
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.fontSize)
        }
    }

    var textColor: Color {
        get {
            guard
                let components = UserDefaults.standard.array(forKey: Keys.textColor) as? [CGFloat],
                let cgColor = CGColor(
                    colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: components)
            else {
                return FontManager.defaultTextColor
            }
            return Color(cgColor: cgColor)
        }
        set {
            UserDefaults.standard.set(newValue.cgColor?.components ?? [], forKey: Keys.textColor)
        }
    }

    var backgroundColor: Color {
        get {
            guard
                let components = UserDefaults.standard.array(forKey: Keys.backgroundColor)
                    as? [CGFloat],
                let cgColor = CGColor(
                    colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: components)
            else {
                return FontManager.defaultBackgroundColor
            }
            return Color(cgColor: cgColor)
        }
        set {
            UserDefaults.standard.set(
                newValue.cgColor?.components ?? [], forKey: Keys.backgroundColor)
        }
    }
}
