//
//  settingPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import UserNotifications

class settingPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userNotificationCentor = UNUserNotificationCenter.current()
    var taskDate = Calendar.current.date(from: DateComponents(month: 0, day: 0, hour: 0, minute: 0))! // 임의 설정
    
    let cellIdentifier = "cell"
    
    var settingAlarm : Bool = false
    var settingText = ["알림 설정"]
    var settingTime = ["시간 설정"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        requestNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "설정"
        
        settingAlarm = globalVariable.shared.settingAlarm
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCentor.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let image = UIImage(named: "arrow")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        
        let settingImage = ["student", "alarm", "version"]
        let settingTitle = [globalVariable.shared.studentName, "알림 설정", "서비스 정보"]
        let settingDetail = ["로그아웃", settingAlarm ? "ON" : "OFF", " "]
        
        checkmark.image = image
        
        cell.tintColor = UIColor.white
        cell.accessoryView = checkmark
        cell.imageView?.image = UIImage(named: settingImage[indexPath.row])
        cell.textLabel?.text = settingTitle[indexPath.row]
        cell.detailTextLabel?.text = settingDetail[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(false, forKey: "setAlarm")
            UserDefaults.standard.removeObject(forKey: "hour")
            UserDefaults.standard.removeObject(forKey: "min")
            UserDefaults.standard.removeObject(forKey: "time")
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "pwd")
            
            globalVariable.shared.timeLabel = "설정"
            globalVariable.shared.settingAlarm = false
            
            userNotificationCentor.removeAllPendingNotificationRequests()
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingAlarmPage")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingServicePage")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
