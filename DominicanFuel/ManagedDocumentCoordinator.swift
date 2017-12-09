//
//  ManagedDocumentHandler.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/31/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit


protocol ManagedDocumentCoordinatorDelegate: class {
    func managedDocumentCoordinator(_ coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument)
    func managedDocumentCoordinator(_ coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError)
}

class ManagedDocumentCoordinator {
    
    fileprivate var documentURL: URL!
    var document: UIManagedDocument?
    weak var delegate: ManagedDocumentCoordinatorDelegate?
    
    init() {
        
    }
    
    func setupDocument(_ documentName: String) {
        if let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            self.documentURL = documentsDirectory.appendingPathComponent(documentName)
            self.document = UIManagedDocument(fileURL: documentURL)
            open()
        }
    }
    
    fileprivate func open() {
        if FileManager.default.fileExists(atPath: self.documentURL.path) {
            document?.open(completionHandler: openOrCreateCompletionHandler)
        } else {
            document?.save(to: self.documentURL, for: UIDocumentSaveOperation.forCreating, completionHandler: openOrCreateCompletionHandler)
        }
    }
    
    fileprivate func openOrCreateCompletionHandler(_ success: Bool) {
        if success {
            documentIsReady()
        } else {
            let userInfo = [NSLocalizedDescriptionKey: "Couldn't create document at: \(self.documentURL)"]
            let error = NSError(domain: "ManagedDocumentCoordinator", code: 100, userInfo: userInfo)
            delegate?.managedDocumentCoordinator(self, didFailWithError: error)
        }
    }
    
    fileprivate func documentIsReady() {
        if let document = self.document, document.documentState == UIDocumentState() {
            delegate?.managedDocumentCoordinator(self, didOpenDocument: document)
        } else {
            // Try to open it again
            open()
        }
    }
}
