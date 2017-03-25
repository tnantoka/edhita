//
//  SettingsViewController.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/9/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

class SettingsViewController: FXFormViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Settings", comment: "")
        self.formController.form = SettingsForm.sharedForm

        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneItemDidTap))
        self.navigationItem.rightBarButtonItem = doneItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    func fontDidTap(_ sender: AnyObject) {
        let fontController = EDHFontSelector.shared().settingsViewController()
        self.navigationController?.pushViewController(fontController!, animated: true)
    }

    func acknowledgementsDidTap(_ sender: AnyObject) {
        let acknowledgementsController = VTAcknowledgementsViewController(
            acknowledgementsPlistPath: Bundle.main.path(forResource: "Pods-acknowledgements", ofType: "plist")
        )
        //let acknowledgementsController = VTAcknowledgementsViewController() // Doesn't work
        self.navigationController?.pushViewController(acknowledgementsController!, animated: true)
    }

    func doneItemDidTap(_ sender: AnyObject) {
        self.close()
    }

    // MARK: - Utilities

    func close() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
