//
//  FileSystemHelper.swift
//  HitList
//
//  Created by Catalin David on 30/06/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import Foundation

class FileSystemHelper {
  
  func pathForDocumentFile(fileName: String) -> NSURL {
    let fm = NSFileManager.defaultManager()
    let directories = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                        inDomains: NSSearchPathDomainMask.UserDomainMask) as NSArray
    let documentPath = directories.objectAtIndex(0)
    
    return documentPath.URLByAppendingPathComponent(fileName)
  }
  
}
