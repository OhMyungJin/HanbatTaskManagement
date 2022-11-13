//
//  noticeModal.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import WebKit

class noticeContentPage: UIViewController {
    
    @IBOutlet weak var noticeWebView: WKWebView!
    @IBOutlet weak var noticeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeWebView.loadHTMLString("<style> div{font-size: 25pt;} p{font-size: 25pt;} </style>"+(globalVariable.shared.noticePartContent ?? " "), baseURL: nil)
        noticeTitle.text = globalVariable.shared.noticeTitle
        noticeTitle.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "공지 내용"
    }
}
