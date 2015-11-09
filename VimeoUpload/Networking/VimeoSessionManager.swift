//
//  VimeoSessionManager.swift
//  VimeoUpload
//
//  Created by Alfred Hanssen on 10/17/15.
//  Copyright © 2015 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
//import AFNetworking

typealias AuthTokenBlock = () -> String

class VimeoSessionManager: AFHTTPSessionManager
{    
    // MARK: Initialization
    
    static let DocumentsURL = NSURL(string: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])!

    convenience init(authToken: String)
    {
        self.init(authTokenBlock: { () -> String in
            return "Bearer \(authToken)"
        })
    }
    
    init(authTokenBlock: AuthTokenBlock)
    {
        let sessionConfiguration: NSURLSessionConfiguration
        
        if #available(iOS 8.0, OSX 10.10, *)
        {
            sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.vimeo.upload")
        }
        else
        {
            sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfiguration("com.vimeo.upload")
        }
        
        super.init(baseURL: VimeoBaseURLString, sessionConfiguration: sessionConfiguration)
        
        self.requestSerializer = VimeoRequestSerializer(authTokenBlock: authTokenBlock)
        self.responseSerializer = VimeoResponseSerializer()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }    
}
