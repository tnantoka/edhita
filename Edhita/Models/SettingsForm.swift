//
//  SettingsForm.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/9/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

open class SettingsForm: NSObject, FXForm {

    fileprivate struct Defaults {
        static let accessoryViewKey = "SettingsForm.Defaults.accessoryViewKey"
    }

    open class var sharedForm: SettingsForm {
        struct Singleton {
            static let sharedForm = SettingsForm()
        }
        return Singleton.sharedForm
    }

    override init() {
        super.init()

        var defaults = [String: AnyObject]()
        defaults[Defaults.accessoryViewKey] = true as AnyObject?
        UserDefaults.standard.register(defaults: defaults)

        self.accessoryView = UserDefaults.standard.bool(forKey: Defaults.accessoryViewKey)
    }

    var accessoryView: Bool = true {
        didSet {
            UserDefaults.standard.set(self.accessoryView, forKey: Defaults.accessoryViewKey)
            UserDefaults.standard.synchronize()
        }
    }

    @nonobjc open func extraFields() -> [Any]! {
        return [
            [
                FXFormFieldHeader: "",
                FXFormFieldType: FXFormFieldTypeLabel,
                FXFormFieldAction: "fontDidTap:",
                FXFormFieldTitle: NSLocalizedString("Font", comment: "")
            ],
            [
                FXFormFieldHeader: "",
                FXFormFieldType: FXFormFieldTypeLabel,
                FXFormFieldAction: "acknowledgementsDidTap:",
                FXFormFieldTitle: NSLocalizedString("Acknowledgements", comment: "")
            ]
        ]
    }
}
