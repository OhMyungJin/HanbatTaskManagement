//
//  noticePage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit

class noticePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkNoticeLabel: UILabel!
    
    let noticeTitle = globalVariable.shared.noticeName[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    let noticeContent = globalVariable.shared.noticeContent[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    
    let cellIdentifier: String = "cell2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if noticeTitle.count == 0 {
            checkNoticeLabel.text = "공지가 없습니다."
        } else {
            checkNoticeLabel.text = " "
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let image = UIImage(named: "arrow")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        
        let text: String = String(noticeTitle[indexPath.row])
        
        checkmark.image = image
        
        cell.tintColor = UIColor.white
        cell.accessoryView = checkmark
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = ""
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = noticeTitle[indexPath.row]
        
        var content = noticeContent[indexPath.row]
        var firstIndex: Int = 0
        var lastIndex: Int = 2
        
        while(true) {
            if let index = content.range(of: "style=") {
                firstIndex = content.distance(from: content.startIndex, to: content[index].startIndex)
                
            } else { break }
            
            if let index = content.range(of: ";\">") {
                lastIndex = content.distance(from: content.startIndex, to: content[index].endIndex)
            }
            
            let start = content.index(content.startIndex, offsetBy: firstIndex)
            let end = content.index(content.startIndex, offsetBy: lastIndex-2)
            
            content.removeSubrange(start...end)
        }
        
        globalVariable.shared.noticePartContent = String(content)
        globalVariable.shared.noticeTitle = String(title)
        
        let vcNotice = self.storyboard?.instantiateViewController(withIdentifier: "noticeContentPage")
        self.navigationController?.pushViewController(vcNotice!, animated: true)
    }
    
}
