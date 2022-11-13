//
//  settingAlarmPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import UserNotifications

class settingAlarmPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userNotificationCentor = UNUserNotificationCenter.current()
    var taskDate = Calendar.current.date(from: DateComponents(month: 0, day: 0, hour: 0, minute: 0))! // 임의 설정
    
    let cellIdentifier = "cell2"
    let switchView = UISwitch(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
        self.navigationItem.title = "알람"
        
        switchView.onTintColor = UIColor(red: 0, green: 0.5255, blue: 0.6667, alpha: 1.0)
        switchView.isOn = UserDefaults.standard.bool(forKey: "setAlarm")
        
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCentor.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func setAlarm(){
        userNotificationCentor.removeAllPendingNotificationRequests()
        
        let setHour = globalVariable.shared.timeHour
        let setMinute = globalVariable.shared.timeMinute
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.default
        notificationContent.title = "한밭 과제"
        
        func sendNotification() {
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: taskDate), repeats: false)
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: notificationContent,
                trigger: trigger
            )

            userNotificationCentor.add(request) { (error) in
                print(#function, error as Any)
            }
        }
        
        for i in 0..<globalVariable.shared.taskAlarm.count{
            
            let homework = globalVariable.shared.taskAlarm[i].split(separator: "$", omittingEmptySubsequences: true).map({(value) in Int(value)!})
            
            notificationContent.body = globalVariable.shared.taskAlarmName[i]
            self.taskDate = Calendar.current.date(from: DateComponents(month: homework[0], day: homework[1], hour: homework[2] - setHour, minute: homework[3] - setMinute))!
            sendNotification()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as UITableViewHeaderFooterView?
        
        if section == 1 {
            if switchView.isOn == false {
                cell?.textLabel?.text = ""
            } else {
                cell?.textLabel?.text = "알람 설정"
                cell?.textLabel?.textColor = UIColor.black
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingTimePage") as! settingTimePage
            vc.tableView = tableView
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let image = UIImage(named: "arrow")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
                
        let text: String = indexPath.section == 0 ? "시스템 알람 설정" : "시간 설정"
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        cell.textLabel?.text = text
        
        if (indexPath.section == 0) {
            cell.accessoryView = switchView
            cell.detailTextLabel?.text = .none
            cell.selectionStyle = .none
            cell.accessoryType = .none
        }else{
            checkmark.image = image
            
            cell.tintColor = UIColor.white
            cell.accessoryView = checkmark
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = globalVariable.shared.timeLabel
        }
        
        if (switchView.isOn == false){
            if(indexPath.section == 1){
                cell.isHidden = true
            }
        }else{
            if(indexPath.section == 1){
                setAlarm()
            }
        }
        
        return cell

    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        
        UserDefaults.standard.set(sender.isOn, forKey: "setAlarm")
        
        if (sender.isOn == true){
            globalVariable.shared.settingAlarm = true
        }else{
            globalVariable.shared.settingAlarm = false
            userNotificationCentor.removeAllPendingNotificationRequests()
        }
        
        self.tableView.reloadData()
    }
    
}
