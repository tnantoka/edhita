//
//  SettingsViewController.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/9/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

class SettingsViewController: FXFormViewController {

    override init() {
        super.init()
        
        self.title = NSLocalizedString("Settings", comment: "")
        self.formController.form = SettingsForm.sharedForm
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneItemDidTap:")
        self.navigationItem.rightBarButtonItem = doneItem
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actioins
    
    func fontDidTap(sender: AnyObject) {
        let fontController = EDHFontSelector.sharedSelector().settingsViewController()
        self.navigationController?.pushViewController(fontController, animated: true)
    }

    func acknowledgementsDidTap(sender: AnyObject) {
        let acknowledgementsController = VTAcknowledgementsViewController(acknowledgementsPlistPath: NSBundle.mainBundle().pathForResource("Pods-acknowledgements", ofType: "plist"))
        //let acknowledgementsController = VTAcknowledgementsViewController() // Doesn't work
        self.navigationController?.pushViewController(acknowledgementsController, animated: true)
    }

    func doneItemDidTap(sender: AnyObject) {
        self.close()
    }
    
    // MARK: - Utilities
    
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
