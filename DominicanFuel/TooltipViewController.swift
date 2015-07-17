//
//  TooltipViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 7/13/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class TooltipViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    var text: String?
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: super.preferredContentSize.width, height: 44)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
