//
//  EditorViewController.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/7/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit
import MessageUI

class EditorViewController: UIViewController, EDHFinderListViewControllerDelegate, MFMailComposeViewControllerDelegate {

    let toolbarIconSize: CGFloat = 30.0

    var fullscreenItem: UIBarButtonItem!
    var reloadItem: UIBarButtonItem!
    var shareItem: UIBarButtonItem!
    var countItem: UIBarButtonItem!
    var modeControl: UISegmentedControl!
    var editorView: EditorView!

    var finderItem: EDHFinderItem? {
        didSet {
            self.configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()

        self.editorView = EditorView(frame: self.view.bounds)
        editorView.onChangeText = updateCountItem
        self.view.addSubview(self.editorView)

        // Toolbar
        self.fullscreenItem = UIBarButtonItem(image: nil, style: .plain, target: self,
                                              action: #selector(fullscreenItemDidTap))
        self.reloadItem = Utility.barButtonItem(target: self,
                                                icon: FAKIonIcons.refreshIcon(withSize: self.toolbarIconSize),
                                                action: #selector(reloadItemDidTap))
        self.shareItem = Utility.barButtonItem(target: self,
                                               icon: FAKIonIcons.shareIcon(withSize: self.toolbarIconSize),
                                               action: #selector(shareItemDidTap))
        self.countItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        self.toolbarItems = [
            self.fullscreenItem,
            flexibleItem,
            self.reloadItem,
            flexibleItem,
            shareItem,
            flexibleItem,
            countItem
        ]

        // Right
        self.modeControl = UISegmentedControl(items: [
            NSLocalizedString("Editor", comment: ""),
            NSLocalizedString("Browser", comment: ""),
            NSLocalizedString("Dual", comment: "")
            ])
        self.modeControl.addTarget(self, action: #selector(modeControlDidChange), for: .valueChanged)
        self.modeControl.selectedSegmentIndex = 0

        let modeItem = UIBarButtonItem(customView: self.modeControl)
        self.navigationItem.rightBarButtonItem = modeItem

        // Init
        self.finderItem = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(false, animated: true)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShowNotification),
                                       name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHideNotification),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)

        self.modeControlDidChange(self.modeControl)
        self.updateFullscreenItem()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // TODO: Should use UISplitViewControllerDelegate
        self.splitViewController?.preferredDisplayMode = .automatic
        self.updateFullscreenItem()
    }

    // MARK: - Actions

    @objc func fullscreenItemDidTap(_ sender: AnyObject) {
        if self.splitViewController?.preferredDisplayMode == UISplitViewController.DisplayMode.automatic {
            if self.splitViewController?.displayMode == UISplitViewController.DisplayMode.allVisible {
                self.splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.primaryHidden
            } else {
                self.splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.allVisible
            }
        } else {
            self.splitViewController?.preferredDisplayMode = .automatic
        }
        self.updateFullscreenItem()
    }

    @objc func reloadItemDidTap(_ sender: AnyObject) {
        self.editorView.reload()
    }

    @objc func shareItemDidTap(_ sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Share", comment: ""),
            message: "",
            preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("E-mail", comment: ""),
            style: .default,
            handler: { (_: UIAlertAction!) in
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
                        if let data = try? Data(contentsOf: item.fileURL()) {
                            mailController.addAttachmentData(data, mimeType: item.mimeType, fileName: item.name)
                        }
                    }
                }

                self.present(mailController, animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Open in Another App", comment: ""),
            style: .default,
            handler: { (_: UIAlertAction!) in
                guard let item = self.finderItem else { return }

                var items: [Any] = [item.fileURL()]

                if item.isEditable() {
                    items.append(item.content())
                }

                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
                self.present(activityController, animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel,
            handler: nil))

        alertController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func settingsItemDidTap(_ sender: AnyObject) {
        let formController = SettingsViewController()
        let navController = UINavigationController(rootViewController: formController)
        navController.modalPresentationStyle = .formSheet
        self.present(navController, animated: true, completion: nil)
    }

    @objc func modeControlDidChange(_ sender: AnyObject) {
        switch self.modeControl.selectedSegmentIndex {
        case 0:
            self.editorView.mode = .edit
            self.reloadItem.isEnabled = false
        case 1:
            self.editorView.mode = .preview
            self.reloadItem.isEnabled = true
        case 2:
            self.editorView.mode = .split
            self.reloadItem.isEnabled = true
        default:
            break
        }
    }

    // MARK: - EDHFinderListViewControllerDelegate

    func listViewController(_ controller: EDHFinderListViewController!, didMoveToDirectory item: EDHFinderItem!) {
        self.finderItem = nil
    }

    func listViewController(_ controller: EDHFinderListViewController!, didBackToDirectory item: EDHFinderItem!) {
        self.listViewController(controller, didMoveToDirectory: item)
    }

    func listViewController(_ controller: EDHFinderListViewController!, didSelectFile item: EDHFinderItem!) {
        self.finderItem = item

        // Show editor controller on compact devise
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.splitController.isCollapsed {
            // FIXME: Unbalanced calls to begin/end appearance transitions for <UINavigationController: >.
            if let navigationController = self.navigationController {
                appDelegate.splitController.showDetailViewController(navigationController, sender: nil)
            }

            // Need navigation controller for landscape on iPhone 6 Plus
            // appDelegate.splitController.showDetailViewController(self, sender: nil)
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            // FIXME: Show error
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Keyboard notification

    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }

    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }

    func keyboardWillChangeFrameWithNotification(_ notification: Notification, showsKeyboard: Bool) {
        let userInfo = (notification as NSNotification).userInfo!
        let durationInfo = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) ?? NSNumber()
        let animationDuration: TimeInterval = durationInfo.doubleValue
        var viewHeight = view.bounds.height
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? CGRect.zero
        let withHardwareKeyboard = keyboardEndFrame.maxY > navigationController!.view.bounds.height
        if showsKeyboard {
            let toolBarHeight = navigationController!.toolbar!.bounds.height
            if withHardwareKeyboard {
                viewHeight -= toolBarHeight
            } else {
                let keyboardHeight = keyboardEndFrame.height
                viewHeight += toolBarHeight - keyboardHeight
            }
        }

        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: UIView.AnimationOptions.beginFromCurrentState,
            animations: { [weak self] in
                self?.editorView.frame.size.height = viewHeight
            }, completion: nil)
    }

    // MARK: - Utilities

    func configureView() {
        if let item = self.finderItem {
            self.title = item.name

            self.shareItem.isEnabled = true
        } else {
            self.title = NSLocalizedString("Edhita", comment: "")

            self.shareItem.isEnabled = false
        }
        self.editorView.finderItem = self.finderItem
        self.modeControlDidChange(self.modeControl)
        updateCountItem()
    }

    func updateFullscreenItem() {
        var icon: FAKIcon
        if self.splitViewController?.displayMode == UISplitViewController.DisplayMode.allVisible {
            // FIXME: Does not show back button label after rotation to portrait
            self.navigationItem.leftBarButtonItem = nil // Don't show default exapnd item on portrail
            icon = FAKIonIcons.arrowExpandIcon(withSize: toolbarIconSize)
        } else {
            self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            icon = FAKIonIcons.arrowShrinkIcon(withSize: toolbarIconSize)
        }
        self.fullscreenItem.image = icon.image(with: CGSize(width: icon.iconFontSize, height: icon.iconFontSize))

        if self.splitViewController?.isCollapsed == true {
            self.fullscreenItem.isEnabled = false
        }
    }

    func updateCountItem() {
        countItem.title = String(format: NSLocalizedString("Chars: %d", comment: ""), editorView.count)
    }
}
