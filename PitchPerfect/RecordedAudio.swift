//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Doug Mason on 11/8/15.
//  Copyright © 2015 Doug Mason. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl:NSURL!,title:String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}