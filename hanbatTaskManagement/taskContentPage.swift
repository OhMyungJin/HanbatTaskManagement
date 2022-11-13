//
//  taskModal.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import WebKit

class taskContentPage: UIViewController {
    
    @IBOutlet weak var taskWebview: WKWebView!
    @IBOutlet weak var taskTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskWebview.loadHTMLString("<style> div{font-size: 25pt;} p{font-size: 25pt;} </style>"+(globalVariable.shared.taskPartContent ?? " "), baseURL: nil)
        taskTitle.text = globalVariable.shared.taskTitle
        taskTitle.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "과제 내용"
    }
    
}
