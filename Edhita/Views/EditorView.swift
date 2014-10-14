//
//  EditorView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/8/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

class EditorView: UIView, UITextViewDelegate {

    let kBorderWidth : CGFloat = 1.0
    
    enum EditorViewMode {
        case None, Edit, Preview, Split
    }
    
    var textView: UITextView!
    var webView: UIWebView! // TODO: Use WKWebView
    var finderItem: EDHFinderItem? {
        didSet {
            self.configureView()
        }
    }
    var mode: EditorViewMode = .None {
        didSet {
            if oldValue != self.mode {
                self.updateControls()                
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = .FlexibleHeight | .FlexibleWidth

        self.textView = UITextView(frame: self.bounds)
        self.textView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.textView.delegate = self
        self.addSubview(self.textView)

        self.webView = UIWebView(frame: self.bounds)
        self.webView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.webView.scalesPageToFit = true
        self.addSubview(self.webView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
        switch self.mode {
        case .Edit:
            self.textView.frame = self.bounds
            self.webView.frame = self.bounds
        case .Preview:
            self.textView.frame = self.bounds
            self.webView.frame = self.bounds
        case .Split:
            self.textView.frame = CGRect(x: 0.0, y: 0.0, width: CGRectGetMidX(self.bounds), height: CGRectGetHeight(self.bounds))
            self.webView.frame = CGRect(x: CGRectGetMidX(self.bounds) + kBorderWidth, y: 0.0, width: CGRectGetMidX(self.bounds) - kBorderWidth, height: CGRectGetHeight(self.bounds))
        default:
            break
        }
    }
    
    func updateControls() {
        self.updateFrame()
        
        switch self.mode {
        case .Edit:
            self.textView.hidden = false
            self.webView.hidden = true

            self.textView.becomeFirstResponder()
            self.loadBlank()
        case .Preview:
            self.textView.hidden = true
            self.webView.hidden = false
            
            self.textView.resignFirstResponder()
            self.preview()
        case .Split:
            self.textView.hidden = false
            self.webView.hidden = false
            self.preview()
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
        
        if self.textView.isFirstResponder() {
            let selectedRange = self.textView.selectedRange
            self.textView.scrollRangeToVisible(selectedRange)
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        self.finderItem?.updateContent(textView.text)
        self.preview()
    }
    
    // MARK: - Utilities
    
    func configureView() {
        if let item = self.finderItem {
            if item.isEditable() {
                self.textView.editable = true
                self.textView.text = item.content()
                
                if SettingsForm.sharedForm.accessoryView {
                    self.textView.inputAccessoryView = EDHInputAccessoryView(textView: self.textView)
                } else {
                    self.textView.inputAccessoryView = nil
                }
            } else {
                self.textView.editable = false
                self.textView.text = ""

                self.textView.inputAccessoryView = nil
            }
            self.preview()
        } else {
            self.textView.editable = false
            self.textView.text = ""
            self.loadBlank()
        }
        
        EDHFontSelector.sharedSelector().applyToTextView(self.textView)
    }
    
    func loadBlank() {
        self.loadURL(NSURL(string: "about:blank"))
    }
    
    func preview() {
        if let item = self.finderItem {
            if item.mimeType? == "text/markdown" {
                let parser = GHMarkdownParser()
                parser.options = kGHMarkdownAutoLink
                parser.githubFlavored = true
                self.loadHTML(parser.HTMLStringFromMarkdownString(item.content()), baseURL: item.parent().fileURL())
            } else {
//                let indexPath = item.path.stringByDeletingLastPathComponent.stringByAppendingPathComponent("index.html")
//                let indexItem = EDHFinderItem(path: indexPath)
//                if indexItem.isFile {
//                    self.loadURL(indexItem.fileURL())
//                } else {
//                    self.loadURL(item.fileURL())
//                }
                self.loadURL(item.fileURL())
            }
        }
    }
    
    func loadURL(url: NSURL!) {
        self.webView.loadRequest(NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 0.0))
    }
    
    func loadHTML(html: String!, baseURL: NSURL!) {
        self.webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    func reload() {
        self.webView.reload()
    }
}
