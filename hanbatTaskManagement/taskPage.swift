//
//  taskPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit

class taskPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var checkTaskLabel: UILabel!
    
    let homework = globalVariable.shared.deadline[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    let subMission = globalVariable.shared.submitState[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    let workTitle = globalVariable.shared.taskName[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    let taskContent = globalVariable.shared.taskContent[globalVariable.shared.tableViewIndexPath].split(separator: "$", omittingEmptySubsequences: true)
    
    let cellIdentifier: String = "cell"
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if homework.count == 0 {
            checkTaskLabel.text = "과제가 없습니다."
        } else {
            checkTaskLabel.text = " "
        }
    }
    
    func substring(Date: String, from: Int, to: Int) -> String {
        
        let startIndex = Date.index(Date.startIndex, offsetBy: from)
        let endIndex = Date.index(Date.startIndex, offsetBy: to)
        
        return String(Date[startIndex ... endIndex])
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homework.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: taskPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! taskPageCollectionViewCell
        
        let startDate = homework[indexPath.item].split(separator: "~", omittingEmptySubsequences: true)[0].replacingOccurrences(of: "-", with: ".")
        let start = startDate.dropFirst(5)
        
        let endDate = homework[indexPath.item].split(separator: "~", omittingEmptySubsequences: true)[1].replacingOccurrences(of: "-", with: ".")
        let end = endDate.dropFirst(6)
        
        let startYear = Int(substring(Date: startDate, from: 0, to: 3))
        let startMonth = Int(substring(Date: startDate, from: 5, to: 6))
        let startDay = Int(substring(Date: startDate, from: 8, to: 9))
        let startHour = Int(substring(Date: startDate, from: 11, to: 12))
        let startMinute = Int(substring(Date: startDate, from: 14, to: 15))
        
        let endYear = Int(substring(Date: endDate, from: 1, to: 4))
        let endMonth = Int(substring(Date: endDate, from: 6, to: 7))
        let endDay = Int(substring(Date: endDate, from: 9, to: 10))
        let endHour = Int(substring(Date: endDate, from: 12, to: 13))
        let endMinute = Int(substring(Date: endDate, from: 15, to: 16))
        
        var total = 0.0
        var remainder = 0.0
        
        let startDateComponents = DateComponents(year: startYear, month: startMonth, day: startDay, hour: startHour, minute: startMinute)
        let fromDate = Calendar.current.date(from: startDateComponents)!
        
        let endDateComponents = DateComponents(year: endYear, month: endMonth, day: endDay, hour: endHour, minute: endMinute)
        let toDate = Calendar.current.date(from: endDateComponents)!
        
        let totalComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fromDate, to: toDate)
        
        let remainderComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date(), to: toDate)
        
        if case let (Y?, M?, D?, h?, m?) = (totalComps.year, totalComps.month, totalComps.day, totalComps.hour, totalComps.minute) { // 총 기간
            total = Double(M * 43200 + D * 1440 + h * 60 + m)
        }
        
        if case let (Y?, M?, D?, h?, m?) = (remainderComps.year, remainderComps.month, remainderComps.day, remainderComps.hour, remainderComps.minute) { // 남은 기간
            remainder = Double(M * 43200 + D * 1440 + h * 60 + m)
        }

        cell.taskName.text = String(workTitle[indexPath.item])
        cell.taskTermStart.text = String(start)
        cell.taskTermEnd.text = String(end)
        cell.taskState.text = String(subMission[indexPath.item])
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 0.1
        
        if (String(subMission[indexPath.item]) == "미제출"){
            cell.taskState.textColor = UIColor.red
        } else {
            cell.taskState.textColor = UIColor.lightGray
        }
        
        cell.taskTermProgressView.progress = Float(remainder/total) > 0 ? 1.0 - Float(remainder/total) : 1.0
        
        if cell.taskTermProgressView.progress == 1.0 {
            cell.taskTermProgressView.progressTintColor = .init(red: 141/255, green: 142/255, blue: 149/255, alpha: 1.0)
            cell.backgroundColor = .init(red: 233/255, green: 233/255, blue: 238/255, alpha: 1.0)
            cell.taskState.textColor = UIColor.lightGray
        } else if cell.taskTermProgressView.progress > 0.8 {
            cell.taskTermProgressView.progressTintColor = .init(red: 247/255, green: 43/255, blue: 30/255, alpha: 1.0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 1
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        
        let cellWidth = (width - widthPadding) / itemsPerRow
        
        return CGSize(width: cellWidth, height: 125)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = workTitle[indexPath.row]
        
        var content = taskContent[indexPath.row]
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
        
        globalVariable.shared.taskPartContent = String(content)
        globalVariable.shared.taskTitle = String(title)

        let vcTask = self.storyboard?.instantiateViewController(withIdentifier: "taskContentPage")
        self.navigationController?.pushViewController(vcTask!, animated: true)
    }
}
