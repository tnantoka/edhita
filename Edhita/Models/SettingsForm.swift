//
//  SettingsForm.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/9/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

public class SettingsForm: NSObject, FXForm {

    private struct Defaults {
        static let accessoryViewKey = "SettingsForm.Defaults.accessoryViewKey"
    }

    public class var sharedForm: SettingsForm {
        struct Singleton {
            static let sharedForm = SettingsForm()
        }
        return Singleton.sharedForm
    }

    override init() {
        super.init()
        
        var defaults = [String: AnyObject]()
        defaults[Defaults.accessoryViewKey] = true
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
        
        self.accessoryView = NSUserDefaults.standardUserDefaults().boolForKey(Defaults.accessoryViewKey)
    }
    
    var accessoryView: Bool = true {
        didSet {
            NSUserDefaults.standardUserDefaults().setBool(self.accessoryView, forKey: Defaults.accessoryViewKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    public func extraFields() -> [AnyObject]! {
        return [
            [
                FXFormFieldHeader : "",
                FXFormFieldType : FXFormFieldTypeLabel,
                FXFormFieldAction : "fontDidTap:",
                FXFormFieldTitle : NSLocalizedString("Font", comment: ""),
            ],
            [
                FXFormFieldHeader : "",
                FXFormFieldType : FXFormFieldTypeLabel,
                FXFormFieldAction : "acknowledgementsDidTap:",
                FXFormFieldTitle : NSLocalizedString("Acknowledgements", comment: ""),
            ],
        ]
    }
}
