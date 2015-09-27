//
//  ManagedDocumentHandler.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/31/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit


protocol ManagedDocumentCoordinatorDelegate: class {
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument)
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError)
}

class ManagedDocumentCoordinator {
    
    private var documentURL: NSURL!
    var document: UIManagedDocument?
    weak var delegate: ManagedDocumentCoordinatorDelegate?
    
    init() {
        
    }
    
    func setupDocument(documentName: String) {
        if let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first {
            self.documentURL = documentsDirectory.URLByAppendingPathComponent(documentName)
            self.document = UIManagedDocument(fileURL: documentURL)
            open()
        }
    }
    
    private func open() {
        if let path = self.documentURL.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                document?.openWithCompletionHandler(openOrCreateCompletionHandler)
            } else {
                document?.saveToURL(self.documentURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: openOrCreateCompletionHandler)
            }
        }
        
    }
    
    private func openOrCreateCompletionHandler(success: Bool) {
        if success {
            documentIsReady()
        } else {
            let userInfo = [NSLocalizedDescriptionKey: "Couldn't create document at: \(self.documentURL)"]
            let error = NSError(domain: "ManagedDocumentCoordinator", code: 100, userInfo: userInfo)
            delegate?.managedDocumentCoordinator(self, didFailWithError: error)
        }
    }
    
    private func documentIsReady() {
        if let document = self.document where document.documentState == UIDocumentState.Normal {
            delegate?.managedDocumentCoordinator(self, didOpenDocument: document)
        } else {
            // Try to open it again
            open()
        }
    }
}
