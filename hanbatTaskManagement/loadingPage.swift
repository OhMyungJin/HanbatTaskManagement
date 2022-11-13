//
//  loadingPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import Foundation
import UIKit

class loadingPage: UIViewController{
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = UIImage(named: "hanbat_logo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
}
