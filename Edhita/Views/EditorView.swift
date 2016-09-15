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
        case none, edit, preview, split
    }
    
    var textView: UITextView!
    var webView: UIWebView! // TODO: Use WKWebView
    var finderItem: EDHFinderItem? {
        didSet {
            self.configureView()
        }
    }
    var mode: EditorViewMode = .none {
        didSet {
            if oldValue != self.mode {
                self.updateControls()                
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.textView = UITextView(frame: self.bounds)
        self.textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.textView.delegate = self
        self.addSubview(self.textView)

        self.webView = UIWebView(frame: self.bounds)
        //self.webView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        //self.webView.scalesPageToFit = true
        self.addSubview(self.webView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
        switch self.mode {
        case .edit:
            self.textView.frame = self.bounds
            //self.webView.frame = self.bounds
            self.updateWebViewFrame(self.bounds)
        case .preview:
            self.textView.frame = self.bounds
            // self.webView.frame = self.bounds
            self.updateWebViewFrame(self.bounds)
        case .split:
            self.textView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.midX, height: self.bounds.height)
            //self.webView.frame = CGRect(x: CGRectGetMidX(self.bounds) + kBorderWidth, y: 0.0, width: CGRectGetMidX(self.bounds) - kBorderWidth, height: CGRectGetHeight(self.bounds))
            self.updateWebViewFrame(CGRect(x: self.bounds.midX + kBorderWidth, y: 0.0, width: self.bounds.midX - kBorderWidth, height: self.bounds.height))
        default:
            break
        }
    }
    
    // Web view gets smaller and smaller with decimal fraction?
    func updateWebViewFrame(_ frame: CGRect) {
        var newFrame = frame
        newFrame.size.width = ceil(frame.width)
        self.webView.frame = newFrame
    }
    
    func updateControls() {
        self.updateFrame()
        
        switch self.mode {
        case .edit:
            self.textView.isHidden = false
            self.webView.isHidden = true

            //self.textView.becomeFirstResponder()
            self.loadBlank()
        case .preview:
            self.textView.isHidden = true
            self.webView.isHidden = false
            
            self.textView.resignFirstResponder()
            self.preview()
        case .split:
            self.textView.isHidden = false
            self.webView.isHidden = false
            self.preview()
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
        
        if self.textView.isFirstResponder {
            let selectedRange = self.textView.selectedRange
            self.textView.scrollRangeToVisible(selectedRange)
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.finderItem?.updateContent(textView.text)
        self.preview()
    }
    
    // MARK: - Utilities
    
    func configureView() {
        if let item = self.finderItem {
            if item.isEditable() {
                self.textView.isEditable = true
                self.textView.text = item.content()
                
                if SettingsForm.sharedForm.accessoryView {
                    self.textView.inputAccessoryView = EDHInputAccessoryView(textView: self.textView)
                } else {
                    self.textView.inputAccessoryView = nil
                }
            } else {
                self.textView.isEditable = false
                self.textView.text = ""

                self.textView.inputAccessoryView = nil
            }
            self.preview()
        } else {
            self.textView.isEditable = false
            self.textView.text = ""
            self.loadBlank()
        }
        
        EDHFontSelector.shared().apply(to: self.textView)
    }
    
    func loadBlank() {
        self.loadURL(URL(string: "about:blank"))
    }
    
    func preview() {
        if let item = self.finderItem {
            if item.mimeType != nil && item.mimeType == "text/markdown" {
                self.loadHTML(self.renderMarkdown(item.content() as NSString) as String, baseURL: item.parent().fileURL())
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
    
    func loadURL(_ url: URL!) {
        self.webView.loadRequest(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 0.0))
    }
    
    func loadHTML(_ html: String!, baseURL: URL!) {
        self.webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    func reload() {
        self.webView.reload()
    }
    
    func renderMarkdown(_ content: NSString) -> NSString {
        let parser = GHMarkdownParser()
        parser.options = kGHMarkdownAutoLink
        parser.githubFlavored = true
        let rendered = parser.htmlString(fromMarkdownString: content as String)
        let body = "<article class=\"markdown-body\">\(rendered)</article>"
        let path = Bundle.main.path(forResource: "github-markdown", ofType: "css")
        let url = URL(fileURLWithPath: path!)
        let style = "<link rel=\"stylesheet\" href=\"\(url.absoluteString)\">"
        return "\(style)\(body)" as NSString
    }
}
