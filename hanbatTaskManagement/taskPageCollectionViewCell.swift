//
//  taskPageCollectionViewCell.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit

class taskPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var taskName: UILabel!
    
    @IBOutlet var taskTermStart: UILabel!
    @IBOutlet var taskTermEnd: UILabel!
    
    @IBOutlet var taskState: UILabel!
    
    @IBOutlet var taskTermProgressView: UIProgressView!
}
