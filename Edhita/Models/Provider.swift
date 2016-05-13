//
//  Provider.swift
//  Edhita
//
//  Created by Abubakr Dar on 12/13/15.
//  Copyright © 2015 tnantoka. All rights reserved.
//

import Foundation

class ProviderFactory {
    static func providerWithType(type:String) -> Provider? {
        if type == "Dropbox" {
            return DropboxProvider(appKey: "1o0v45g3kjk37j1", appSecret: "rkgdgm382m7sjko")
        }
        return nil
    }
}

protocol Provider {
    var appKey : String { get }
    
    //func setupProviderWithAppKey(appKey: String, appSecret: String, rootFolder: String)
    func canOpenUrl(url: NSURL) -> Bool
    
    func isConnected() -> Bool
    func connectViaController(controller: UIViewController)
    
    func setup()
   // typealias Callback = ;
    func uploadFile(fileName fileName:String, path:String, onCompletion:(uploaded:Bool, error:NSError?) -> (Void));
}

