//
//  RKParallaxEffect.swift
//  RKParallaxEffect
//
//  Created by Rahul Katariya on 02/02/15.
//  Copyright (c) 2015 Rahul Katariya. All rights reserved.
//

import UIKit

open class RKParallaxEffect: NSObject {
    
    var tableView: UITableView!
    var tableHeaderView: UIView?
    var tableViewTopInset: CGFloat = 0
    
    open var isParallaxEffectEnabled: Bool = false {
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
    
    open var isFullScreenTapGestureRecognizerEnabled: Bool = false {
        didSet {
            if isFullScreenTapGestureRecognizerEnabled {
                if !isFullScreenModeEnabled {
                    isFullScreenModeEnabled = true
                }
                tableHeaderView?.isUserInteractionEnabled = true
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
                return CGRect(x: tableView.frame.origin.x, y: -(tableView.frame.size.height-tableViewTopInset), width: tableView.frame.size.width, height: tableView.frame.size.height-tableViewTopInset)
            }
        }
    }
    
    //FullScreen Pan
    open var thresholdValue: CGFloat = 100.0
    
    open var isFullScreenPanGestureRecognizerEnabled: Bool = false {
        didSet {
            if isFullScreenPanGestureRecognizerEnabled {
                if !isFullScreenModeEnabled {
                    isFullScreenModeEnabled = true
                }
                if !isParallaxEffectEnabled {
                    isParallaxEffectEnabled = true
                }
                tableHeaderView?.isUserInteractionEnabled = true
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
        
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: -(tableHeaderViewIntitalFrame.size.height+tableViewTopInset)), animated:false)
        
    }
    
    func addObservers() {
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        tableHeaderView?.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    func removeObservers() {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
        tableHeaderView?.removeObserver(self, forKeyPath: "frame")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            adjustParallaxEffectOnTableHeaderViewWithContentOffset((change![NSKeyValueChangeKey.newKey]! as AnyObject).cgPointValue)
        } else if keyPath == "frame" {
            tableView.layoutIfNeeded()
        }
    }
    
    func adjustParallaxEffectOnTableHeaderViewWithContentOffset(_ contentOffset:CGPoint) {
        if let thv = tableHeaderView {
            let yOffset = -1*(contentOffset.y+tableViewTopInset)
            if yOffset > 0 {
                if isParallaxEffectEnabled {
                    thv.frame = CGRect(x: 0, y: -yOffset, width: thv.frame.width, height: yOffset)
                }
                if isFullScreenModeEnabled && !isAnimating {
                    if isFullScreenPanGestureRecognizerEnabled {
                        if !isFullScreen && yOffset > tableHeaderViewIntitalFrame.size.height + thresholdValue {
                            tableView.isScrollEnabled = false
                            var frame = tableHeaderViewIntitalFrame
                            frame?.size.height = yOffset
                            thv.frame = frame!
                            tableView.layoutIfNeeded()
                            enterFullScreen()
                        } else if isFullScreen && yOffset < tableView.frame.size.height-tableViewTopInset-thresholdValue {
                            tableView.isScrollEnabled = false
                            var frame = CGRect(x: tableView.frame.origin.x, y: -(tableView.frame.size.height-tableViewTopInset), width: tableView.frame.size.width, height: tableView.frame.size.height-tableViewTopInset)
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
    
    @objc func handleTap(_ sender:AnyObject?) {
        self.willChangeFullScreenMode()
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .beginFromCurrentState], animations: { () -> Void in
            self.adjustTableViewContentInset()
            self.tableHeaderView!.frame = self.newFrame
            }) { (completed: Bool) -> Void in
                self.didChangeFullScreenMode()
        }
    }
    
    
    func adjustTableViewContentInset() {
        //Adjust ContentOffset
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x,y: -(self.newFrame.size.height+self.tableViewTopInset)), animated: false)
        
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
        tableView.isScrollEnabled = true
        if isFullScreen {
            tableView.contentSize = CGSize(width: initialContentSize.width, height: 0)
        } else {
            tableView.contentSize = initialContentSize
        }
    }
    
}
