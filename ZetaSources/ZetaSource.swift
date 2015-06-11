//
//  ZetaSource.swift
//  ZetaSources
//
//  Created by Jonathan Hersh on 6/11/15.
//  Copyright © 2015 Jonathan Hersh. All rights reserved.
//

import Foundation
import UIKit

public enum CellAction {
    case Move, Edit
}

public typealias CellActionBlock = (CellAction, UIScrollView, NSIndexPath) -> Bool

public typealias CellCreationBlock = (item: AnyObject, view: AnyObject, indexPath: NSIndexPath) -> AnyObject!

public protocol ZetaSource: class, UITableViewDataSource, UICollectionViewDataSource {
    
    // MARK: Item/Section Retrieval
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
    
    func numberOfSections() -> Int!
    
    func numberOfItemsInSection(section: Int) -> Int!
    
    func indexPathForItem(item: AnyObject) -> NSIndexPath?
    
    // MARK: Cell Creation
    
    var cellClass: ReusableCell { get set }
    
    var cellCreationBlock: CellCreationBlock? { get set }
    
    // MARK: Cell Actions
    
    var cellActionHandler: CellActionBlock? { get set }
    
    // MARK: UITableView
    
    weak var tableView: UITableView? { get set }
    
    // Mark: UICollectionView
    
    weak var collectionView: UICollectionView? { get set }
}

extension ZetaSource {
    
    // MARK: UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let result = cellActionHandler?(.Edit, tableView, indexPath) else {
            return true // iOS cells are editable by default
        }
        
        return result
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let result = cellActionHandler?(.Move, tableView, indexPath) else {
            return false
        }
        
        return result
    }
    
    // MARK: UICollectionViewDataSource 
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section)
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    public func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let result = cellActionHandler?(.Move, collectionView, indexPath) else {
            return false
        }
        
        return result
    }
}
