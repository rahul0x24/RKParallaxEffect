//
//  RKParallaxEffect.swift
//  RKParallaxEffect
//
//  Created by Rahul Katariya on 02/02/15.
//  Copyright (c) 2015 Rahul Katariya. All rights reserved.
//

import UIKit

public class RKParallaxEffect: NSObject {
    
    var tableView:UITableView!
    var tableHeaderView:UIView?
    var tableViewTopInset: CGFloat = 0
    var tableHeaderViewIntitalFrame:CGRect!
    var isFullScreenModeEnabled = false
    var isAnimating = false
    var isFullScreen = false
    var initialContentSize: CGSize!
    
    var newFrame: CGRect {
        get {
            if isFullScreen {
                return tableHeaderViewIntitalFrame
            } else {
                return CGRectMake(tableView.frame.origin.x, -(tableView.frame.size.height-tableViewTopInset), tableView.frame.size.width, tableView.frame.size.height-tableViewTopInset);
            }
        }
    }
    
    public var isFullScreenTapGestureRecognizerEnabled: Bool = false {
        didSet {
            if isFullScreenTapGestureRecognizerEnabled {
                if !isFullScreenModeEnabled {
                    isFullScreenModeEnabled = true
                }
                tableHeaderView?.userInteractionEnabled = true
                tableHeaderView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTap:")))
            }
        }
    }
    
    public var isParallaxEffectEnabled: Bool = false {
        didSet {
            if isParallaxEffectEnabled {
                self.addObservers()
            }
        }
    }
    
    init(tableView:UITableView) {
        super.init()
        self.tableView = tableView
        self.tableHeaderView = tableView.tableHeaderView
        self.setupTableHeaderView()
    }
    
    func setupTableHeaderView() {
        if let thv = tableHeaderView {
            tableView.tableHeaderView = tableView.tableHeaderView
            tableView.tableHeaderView = nil
            tableView.addSubview(thv)
            
            thv.clipsToBounds = true
            
            var frame = thv.frame
            frame.origin.y = -(thv.frame.size.height)
            thv.frame = frame
            tableHeaderViewIntitalFrame = frame
            
            setupTableView()
        }
    }
    
    func setupTableView() {
        
        tableViewTopInset = tableView.contentInset.top
        
        var contentInset = tableView.contentInset
        contentInset.top = tableViewTopInset + tableHeaderViewIntitalFrame.size.height
        tableView.contentInset = contentInset
        
        tableView.setContentOffset(CGPointMake(tableView.contentOffset.x, -(tableHeaderViewIntitalFrame.size.height+tableViewTopInset)), animated:false)
        
    }
    
    func addObservers() {
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        tableHeaderView?.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    
    func removeObservers() {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
        tableHeaderView?.removeObserver(self, forKeyPath: "frame")
    }
    
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            adjustParallaxEffectOnTableHeaderViewWithContentOffset(change[NSKeyValueChangeNewKey]!.CGPointValue())
        } else if keyPath == "frame" {
            tableView.layoutIfNeeded()
        }
    }
    
    func adjustParallaxEffectOnTableHeaderViewWithContentOffset(contentOffset:CGPoint) {
        if let thv = tableHeaderView {
            var yOffset = -1*(contentOffset.y+tableViewTopInset)
            if yOffset > 0 {
                if isParallaxEffectEnabled {
                    thv.frame = CGRectMake(0, -yOffset, CGRectGetWidth(thv.frame), yOffset)
                }
            }
        }
    }
    
    func enterFullScreen() {
        if !isFullScreen {
            handleTap(nil)
        }
    }
    
    func exitFullScreen() {
        if isFullScreen {
            handleTap(nil)
        }
    }
    
    func handleTap(sender:AnyObject?) {
        self.willChangeFullScreenMode()
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut | .BeginFromCurrentState | .BeginFromCurrentState, animations: { () -> Void in
            self.adjustTableViewContentInset()
            self.tableHeaderView!.frame = self.newFrame
            }) { (completed: Bool) -> Void in
                self.didChangeFullScreenMode()
        }
    }
    
    
    func adjustTableViewContentInset() {
        //Adjust ContentOffset
        tableView.setContentOffset(CGPointMake(tableView.contentOffset.x,-(self.newFrame.size.height+self.tableViewTopInset)), animated: false)
        
        //Adjust ContentInset
        var contentInset = tableView.contentInset
        contentInset.top = newFrame.size.height+tableViewTopInset
        tableView.contentInset = contentInset
    }
    
    func willChangeFullScreenMode() {
        isAnimating = true
        tableView.scrollEnabled = false
        if isFullScreen {
            
        } else {
            initialContentSize = tableView.contentSize
        }
    }
    
    func didChangeFullScreenMode() {
        isFullScreen = !isFullScreen
        isAnimating = false
        tableView.scrollEnabled = true;
        if isFullScreen {
            tableView.contentSize = CGSizeMake(initialContentSize.width, 0)
        } else {
            tableView.contentSize = initialContentSize
        }
    }
    
}
