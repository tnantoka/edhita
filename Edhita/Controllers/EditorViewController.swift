//
//  EditorViewController.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/7/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, EDHFinderListViewControllerDelegate, MFMailComposeViewControllerDelegate {

    let kToolbarIconSize: CGFloat = 30.0

    var fullscreenItem: UIBarButtonItem!
    var reloadItem: UIBarButtonItem!
    var shareItem: UIBarButtonItem!
    var modeControl: UISegmentedControl!
    var editorView: EditorView!

    var finderItem: EDHFinderItem? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.editorView = EditorView(frame: self.view.bounds)
        self.view.addSubview(self.editorView)
        
        // Toolbar
        self.fullscreenItem = UIBarButtonItem(image: nil, style: .Plain, target: self, action: "fullscreenItemDidTap:")
        self.reloadItem = self.barButtonItem(icon: FAKIonIcons.refreshbeforeionRefreshingIconWithSize(self.kToolbarIconSize), action: "reloadItemDidTap:")
        self.shareItem = self.barButtonItem(icon: FAKIonIcons.shareIconWithSize(self.kToolbarIconSize), action: "shareItemDidTap:")
        let settingsItem = self.barButtonItem(icon: FAKIonIcons.gearAIconWithSize(self.kToolbarIconSize), action: "settingsItemDidTap:")
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)

        self.toolbarItems = [
            self.fullscreenItem,
            flexibleItem,
            self.reloadItem,
            flexibleItem,
            shareItem,
            flexibleItem,
            settingsItem
        ]
        
        // Right
        self.modeControl = UISegmentedControl(items: [
            NSLocalizedString("Editor", comment: ""),
            NSLocalizedString("Browser", comment: ""),
            NSLocalizedString("Dual", comment: ""),
            ])
        self.modeControl.addTarget(self, action: "modeControlDidChange:", forControlEvents: .ValueChanged)
        self.modeControl.selectedSegmentIndex = 0

        let modeItem = UIBarButtonItem(customView: self.modeControl)
        self.navigationItem.rightBarButtonItem = modeItem

        // Init
        self.finderItem = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)

        self.modeControlDidChange(self.modeControl)
        self.updateFullscreenItem()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        // TODO: Should use UISplitViewControllerDelegate
        self.splitViewController?.preferredDisplayMode = .Automatic
        self.updateFullscreenItem()
    }
    
    // MARK: - Actions
    
    func fullscreenItemDidTap(sender: AnyObject) {
        if self.splitViewController?.preferredDisplayMode == UISplitViewControllerDisplayMode.Automatic {
            if self.splitViewController?.displayMode == UISplitViewControllerDisplayMode.AllVisible {
                self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
            } else {
                self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            }
        } else {
            self.splitViewController?.preferredDisplayMode = .Automatic
        }
        self.updateFullscreenItem()
    }

    func reloadItemDidTap(sender: AnyObject) {
        self.editorView.reload()
    }

    func shareItemDidTap(sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Share", comment: ""),
            message: "",
            preferredStyle: .ActionSheet)

        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("E-mail", comment: ""),
            style: .Default,
            handler: { (action: UIAlertAction!) in
                if !MFMailComposeViewController.canSendMail() {
                    // FIXME: Please configure an e-mail account in the settings app.
                    return
                }
                
                let mailController = MFMailComposeViewController()
                mailController.mailComposeDelegate = self
                
                if let item = self.finderItem {
                    mailController.setSubject(item.name)
                    
                    if item.isEditable() {
                        mailController.setMessageBody(item.content(), isHTML: false)
                    } else {
                        let data = NSData(contentsOfURL: item.fileURL())
                        mailController.addAttachmentData(data, mimeType: item.mimeType, fileName: item.name)
                    }
                }
                
                self.presentViewController(mailController, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .Cancel,
            handler: nil))
        
        alertController.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func settingsItemDidTap(sender: AnyObject) {
        let formController = SettingsViewController()
        let navController = UINavigationController(rootViewController: formController)
        navController.modalPresentationStyle = .FormSheet
        self.presentViewController(navController, animated: true, completion: nil)
    }

    func modeControlDidChange(sender: AnyObject) {
        switch self.modeControl.selectedSegmentIndex {
        case 0:
            self.editorView.mode = .Edit
            self.reloadItem.enabled = false
        case 1:
            self.editorView.mode = .Preview
            self.reloadItem.enabled = true
        case 2:
            self.editorView.mode = .Split
            self.reloadItem.enabled = true
        default:
            break
        }
    }

    // MARK: - EDHFinderListViewControllerDelegate

    func listViewController(controller: EDHFinderListViewController!, didMoveToDirectory item: EDHFinderItem!) {
        self.finderItem = nil
    }
    
    func listViewController(controller: EDHFinderListViewController!, didBackToDirectory item: EDHFinderItem!) {
        self.listViewController(controller, didMoveToDirectory: item)
    }
    
    func listViewController(controller: EDHFinderListViewController!, didSelectFile item: EDHFinderItem!) {
        self.finderItem = item
        
        // Show editor controller on compact devise
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.splitController.collapsed {
            // FIXME: Unbalanced calls to begin/end appearance transitions for <UINavigationController: >.
            appDelegate.splitController.showDetailViewController(self.navigationController, sender: nil)

            // Need navigation controller for landscape on iPhone 6 Plus
            // appDelegate.splitController.showDetailViewController(self, sender: nil)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if error != nil {
            // FIXME: Show error
            return
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Keyboard notification
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var viewHeight = CGRectGetHeight(self.view.bounds)
        if showsKeyboard {
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let keyboardHeight = CGRectGetHeight(keyboardEndFrame)
            viewHeight = viewHeight + CGRectGetHeight(self.navigationController!.toolbar!.bounds) - keyboardHeight
        }
        
        UIView.animateWithDuration(
            animationDuration,
            delay: 0.0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: {
                self.editorView.frame.size.height = viewHeight
            }, completion: nil)
    }

    // MARK: - Utilities

    func configureView() {
        if let item = self.finderItem {
            self.title = item.name

            self.shareItem.enabled = true
        } else {
            self.title = NSLocalizedString("Edhita", comment: "")

            self.shareItem.enabled = false
        }
        self.editorView.finderItem = self.finderItem
        self.modeControlDidChange(self.modeControl)
    }
    
    func updateFullscreenItem() {
        var icon: FAKIcon
        if self.splitViewController?.displayMode == UISplitViewControllerDisplayMode.AllVisible {
            // FIXME: Does not show back button label after rotation to portrait
            self.navigationItem.leftBarButtonItem = nil // Don't show default exapnd item on portrail
            icon = FAKIonIcons.arrowExpandIconWithSize(self.kToolbarIconSize)
        } else {
            self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            icon = FAKIonIcons.arrowShrinkIconWithSize(self.kToolbarIconSize)
        }
        self.fullscreenItem.image = icon.imageWithSize(CGSize(width: icon.iconFontSize, height: icon.iconFontSize))

        if self.splitViewController?.collapsed == true {
            self.fullscreenItem.enabled = false
        }
    }
    
    func barButtonItem(#icon: FAKIcon, action: Selector) -> UIBarButtonItem {
        let image = self.iconImage(icon)
        let item = UIBarButtonItem(image: image, style: .Plain, target: self, action: action)
        return item
    }
    
    func iconImage(icon: FAKIcon) -> UIImage {
        return icon.imageWithSize(CGSize(width: icon.iconFontSize, height: icon.iconFontSize))
    }
}
