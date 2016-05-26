//
//  RKParallaxEffect.swift
//  RKParallaxEffect
//
//  Created by Rahul Katariya on 02/02/15.
//  Copyright (c) 2015 Rahul Katariya. All rights reserved.
//

import UIKit

public class RKParallaxEffect: NSObject {
    
    var tableView: UITableView!
    var tableHeaderView: UIView?
    var tableViewTopInset: CGFloat = 0
    
    public var isParallaxEffectEnabled: Bool = false {
        didSet {
            if isParallaxEffectEnabled {
                self.setupTableHeaderView()
                self.addObservers()
            }
        }
    }
    
    //FullScreen Tap
    var tableHeaderViewIntitalFrame:CGRect!
    var isFullScreenModeEnabled = false
    var isAnimating = false
    var isFullScreen = false
    var initialContentSize: CGSize!
    
    public var isFullScreenTapGestureRecognizerEnabled: Bool = false {
        didSet {
            if isFullScreenTapGestureRecognizerEnabled {
                if !isFullScreenModeEnabled {
                    isFullScreenModeEnabled = true
                }
                tableHeaderView?.userInteractionEnabled = true
                tableHeaderView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RKParallaxEffect.handleTap(_:))))
            }
        }
    }
    
    deinit {
        removeObservers()
    }
    
    var newFrame: CGRect {
        get {
            if isFullScreen {
                return tableHeaderViewIntitalFrame
            } else {
                return CGRectMake(tableView.frame.origin.x, -(tableView.frame.size.height-tableViewTopInset), tableView.frame.size.width, tableView.frame.size.height-tableViewTopInset)
            }
        }
    }
    
    //FullScreen Pan
    public var thresholdValue: CGFloat = 100.0
    
    public var isFullScreenPanGestureRecognizerEnabled: Bool = false {
        didSet {
            if isFullScreenPanGestureRecognizerEnabled {
                if !isFullScreenModeEnabled {
                    isFullScreenModeEnabled = true
                }
                if !isParallaxEffectEnabled {
                    isParallaxEffectEnabled = true
                }
                tableHeaderView?.userInteractionEnabled = true
            }
        }
    }
    
    public init(tableView:UITableView) {
        self.tableView = tableView
        self.tableHeaderView = tableView.tableHeaderView
        super.init()
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
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            adjustParallaxEffectOnTableHeaderViewWithContentOffset(change![NSKeyValueChangeNewKey]!.CGPointValue)
        } else if keyPath == "frame" {
            tableView.layoutIfNeeded()
        }
    }
    
    func adjustParallaxEffectOnTableHeaderViewWithContentOffset(contentOffset:CGPoint) {
        if let thv = tableHeaderView {
            let yOffset = -1*(contentOffset.y+tableViewTopInset)
            if yOffset > 0 {
                if isParallaxEffectEnabled {
                    thv.frame = CGRectMake(0, -yOffset, CGRectGetWidth(thv.frame), yOffset)
                }
                if isFullScreenModeEnabled && !isAnimating {
                    if isFullScreenPanGestureRecognizerEnabled {
                        if !isFullScreen && yOffset > tableHeaderViewIntitalFrame.size.height + thresholdValue {
                            tableView.scrollEnabled = false
                            var frame = tableHeaderViewIntitalFrame
                            frame.size.height = yOffset
                            thv.frame = frame
                            tableView.layoutIfNeeded()
                            enterFullScreen()
                        } else if isFullScreen && yOffset < tableView.frame.size.height-tableViewTopInset-thresholdValue {
                            tableView.scrollEnabled = false
                            var frame = CGRectMake(tableView.frame.origin.x, -(tableView.frame.size.height-tableViewTopInset), tableView.frame.size.width, tableView.frame.size.height-tableViewTopInset)
                            frame.size.height -= thresholdValue
                            thv.frame = frame
                            tableView.layoutIfNeeded()
                            exitFullScreen()
                        }
                    }
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
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState, .BeginFromCurrentState], animations: { () -> Void in
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
        if isFullScreen {
            
        } else {
            initialContentSize = tableView.contentSize
        }
    }
    
    func didChangeFullScreenMode() {
        isFullScreen = !isFullScreen
        isAnimating = false
        tableView.scrollEnabled = true
        if isFullScreen {
            tableView.contentSize = CGSizeMake(initialContentSize.width, 0)
        } else {
            tableView.contentSize = initialContentSize
        }
    }
    
}