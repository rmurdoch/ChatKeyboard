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
    
    
    //Setting max height for accoessory view
    var lastHeight = CGFloat(0)
    
    
    //Updating height for insets when view appeared
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        lastHeight = accessoryView.frame.height
        self.updateInsets()
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


//Mark: TextView Delegate to adjust accessory view frames
extension ViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        
        let heightDifference = (textView.superview?.frame.height)! - textView.frame.height
        let insets = textView.textContainerInset.top + textView.textContainerInset.bottom
        let newHeight = textView.contentSize.height + heightDifference + insets
        if newHeight <= maxHeight && newHeight > lastHeight {
            lastHeight = newHeight
            UIView.animateWithDuration(0.3, animations: {
                self.accessoryView.frame.size.height = self.lastHeight
                self.updateInsets()
            })
        }
    }
    
    func updateInsets() {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.lastHeight, right: 0)
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