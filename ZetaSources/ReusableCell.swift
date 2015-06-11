//
//  ReusableCell.swift
//  ZetaSources
//
//  Created by Jonathan Hersh on 6/11/15.
//  Copyright © 2015 Jonathan Hersh. All rights reserved.
//

import Foundation
import UIKit

// A reusable cell for a table or collection view.
public protocol ReusableCell: class {
    
    // Reuse identifier for this cell.
    static func reuseIdentifier() -> String!
    
    // Optional function to perform one-time setup, like creating subviews.
    // Called once at cell creation time.
    func configureCell()
}

extension ReusableCell {
    public static func reuseIdentifier() -> String! {
        return _stdlib_getDemangledTypeName(Self)
    }
    
    public func configureCell() {}
}

public class ReusableTableCell: UITableViewCell, ReusableCell {
    
    static var tableCellStyle: UITableViewCellStyle {
        get {
            return .Default
        }
    }
    
    class func cellForTableView(tableView: UITableView, indexPath: NSIndexPath) -> ReusableTableCell {
        
        let identifier = self.reuseIdentifier()
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ReusableTableCell else {
            let cell = ReusableTableCell(style: tableCellStyle, reuseIdentifier: identifier)
            cell.configureCell()
            return cell
        }
        
        return cell
    }
}

class ReusableCollectionCell: UICollectionViewCell, ReusableCell {

    class func cellForCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) -> ReusableCollectionCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier(),
            forIndexPath: indexPath) as? ReusableCollectionCell else {
        
            fatalError("Failed to dequeue a collection cell")
        }
        
        return cell
    }
}
