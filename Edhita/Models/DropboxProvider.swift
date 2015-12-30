//
//  DropboxProvider.swift
//  Edhita
//
//  Created by Abubakr Dar on 12/23/15.
//  Copyright © 2015 tnantoka. All rights reserved.
//

import Foundation

class DropboxProvider : NSObject {
    
    private (set) var privateAppKey: String
    private (set) var privateAppSecret: String
    
    typealias Callback = (uploaded:Bool, error:NSError?) -> (Void)
    private (set) var onCompletion: Callback?
    
    lazy var restClient: DBRestClient = {
        let client = DBRestClient(session: DBSession.sharedSession())
        client.delegate = self;
        return client
    }()
    
    init(appKey:String, appSecret:String) {
        self.privateAppKey = appKey
        self.privateAppSecret = appSecret
        
        super.init()
    }
}

extension DropboxProvider : DBRestClientDelegate {
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!) {
        self.onCompletion?(uploaded: true, error: nil)
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        self.onCompletion?(uploaded: false, error: error)
    }
}

extension DropboxProvider : Provider {
    
    var appKey : String { get {
        return self.privateAppKey
        }
    }
    
    func setup() {
        DBSession.setSharedSession(DBSession(appKey: self.appKey, appSecret: self.privateAppSecret, root: kDBRootAppFolder))
    }
    
    func canOpenUrl(url: NSURL) -> Bool {
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
            }
        }
        return true
    }
    
    func isConnected() -> Bool {
        return DBSession.sharedSession().isLinked()
    }
    
    func connectViaController(controller: UIViewController) {
        DBSession.sharedSession().linkFromController(controller)
    }
    
    func uploadFile(fileName fileName:String, path:String, onCompletion:(uploaded:Bool, error:NSError?) -> (Void)) {
        self.onCompletion = onCompletion
        self.restClient.uploadFile(fileName, toPath: "/", withParentRev: nil, fromPath: path)
    }
    
    
}