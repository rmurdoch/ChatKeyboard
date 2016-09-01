//
//  ViewController.swift
//  ChatKeyboard
//
//  Created by Andrew Murdoch on 9/1/16.
//  Copyright © 2016 Andrew Murdoch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //ScrollView outlet for adjusting insets
    @IBOutlet weak var tableView: UITableView!
    
    
    //Custom outlet view for inputAccessoryView
    @IBOutlet var accessoryView: AccessoryView!
    
    
    //Setting max height for accoessory view
    let maxHeight = CGFloat(400)
    
    
    //Storing height for accoessory view
    var lastHeight = CGFloat(0)
    
    //Storing height for keybaord view
    var keyboardHeight = CGFloat(0)
    
    
    //Updating height for insets when view appeared
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        lastHeight = accessoryView.frame.height
        self.updateInsets()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //Pointing the inputAccessoryView to custom View
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    
    //Allow view to become first responder from textview
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}

//Observing keyboard animations
extension ViewController {
    func keyboardWillShow(notification: NSNotification) {
        self.updateViewForKeyboard(true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.updateViewForKeyboard(false, notification: notification)
    }
    
    func updateViewForKeyboard(showing: Bool, notification: NSNotification) {
        keyboardHeight = CGFloat(0)
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            keyboardHeight = keyboardSize.height
        }
        
        self.updateInsets()
    }
}


//Mark: TextView Delegate to adjust accessory view frames
extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        
        let heightDifference = (textView.superview?.frame.height)! - textView.frame.height
        let insets = textView.textContainerInset.top + textView.textContainerInset.bottom
        let newHeight = textView.contentSize.height + heightDifference + insets
        if newHeight <= maxHeight && newHeight != lastHeight && newHeight > 0 {
            lastHeight = newHeight
            UIView.animateWithDuration(0.3, animations: {
                self.accessoryView.frame.size.height = self.lastHeight
                self.updateInsets()
            })
        }
    }
    
    func updateInsets() {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
}


//MARK: Simple tableView to see dismissal of accessory view
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = "cell: \(indexPath.row)"
        
        return cell!
    }
}


//MARK: Accessory View
class AccessoryView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Allow flexible height for the view
        autoresizingMask = .FlexibleHeight
    }
    
    //Override the frame setting to update the layout contraint
    override var frame: CGRect {
        didSet {
            let constraint = constraints.filter{ $0.firstAttribute == .Height }.first
            if let constraint = constraint {
                constraint.constant = frame.size.height
            }
        }
    }
    
    //Override content size to be the frame
    override func intrinsicContentSize() -> CGSize {
        return self.frame.size
    }
}