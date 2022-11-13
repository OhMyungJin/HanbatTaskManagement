//
//  classPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import SwiftSoup
import UserNotifications

class classPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier: String = "cell"
    
    let refreshControl = UIRefreshControl()
    
    let userNotificationCentor = UNUserNotificationCenter.current()
    let session: URLSession = URLSession.shared
    
    let label = UILabel()
    
    var taskDate = Calendar.current.date(from: DateComponents(month: 0, day: 0, hour: 0, minute: 0))! // 임의 설정
    
    var taskAlarmList: [String] = []
    var taskNameList: [String] = []
    
    var timer = Timer()
    
    func setnotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.testend), name: NSNotification.Name("will"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tteesstt(_:)), name: NSNotification.Name("test"), object: nil)
    }
    
    @objc func tteesstt(_ notification: Notification) {
        print("did")
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(self.refresh(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func testend() {
        print("end")
        self.timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setnotification()
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.tintColor = UIColor.black
        
        tableView.addSubview(refreshControl)
        requestNotificationAuthorization()
        
        label.text = globalVariable.shared.studentName
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNormalMagnitude + 8.0))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "강의목록"
    }
    
    @objc func refresh(_ sender: AnyObject){
        print(Date())
        
        var subjectList : [String] = []
        var taskList = [String](repeating: "", count: 10)
        var deadlineList = [String](repeating: "", count: 10)
        var submissionList = [String](repeating: "", count: 10)
        var taskContentList = [String](repeating: "", count: 10)
        var noticeList = [String](repeating: "", count: 10)
        var noticeContentList = [String](repeating: "", count: 10)
        
        let subjectClass = subjectClass()
        let subjects = subjectClass.getSubjects()
        
        let student = subjectClass.getName(code: subjects[0].code)
        
        for i in 0..<subjects.count {
            subjectList.append(subjects[i].title)
            let tasks = subjectClass.getTasks(code: subjects[i].code)
            
            for j in 0..<tasks.count {
                taskList[i].append(tasks[j].title + "$")
                deadlineList[i].append(tasks[j].deadline + "$")
                submissionList[i].append(tasks[j].submission + "$")
                taskContentList[i].append(tasks[j].content + "$")
            }
        }
        
        for i in 0..<subjects.count {
            let notices = subjectClass.getNotices(code: globalVariable.shared.noticeCode[i])
            
            for j in 0..<notices.count {
                noticeList[i].append(notices[j].title + "$")
                noticeContentList[i].append(notices[j].content + "$")
            }
        }
        
        globalVariable.shared.studentName = student
        globalVariable.shared.className = subjectList
        globalVariable.shared.deadline = deadlineList
        globalVariable.shared.submitState = submissionList
        globalVariable.shared.taskContent = taskContentList
        globalVariable.shared.taskName = taskList
        globalVariable.shared.noticeName = noticeList
        globalVariable.shared.noticeContent = noticeContentList
        
        taskNameList = []
        taskAlarmList = []
    
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
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
    
    func currentMonth() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let current_date_string = formatter.string(from: Date())
        return current_date_string
    }
    
    func currentDay() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let current_date_string = formatter.string(from: Date())
        return current_date_string
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVariable.shared.tableViewIndexPath = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVariable.shared.className.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskName = globalVariable.shared.taskName[indexPath.row].split(separator: "$", omittingEmptySubsequences: true)
        let submitCheck = globalVariable.shared.submitState[indexPath.row].split(separator: "$", omittingEmptySubsequences: true)
        let deadlineCheck1 = globalVariable.shared.deadline[indexPath.row].split(separator: "$", omittingEmptySubsequences: true)
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let icon: String = globalVariable.shared.classification[indexPath.row]
        
        let text: String = globalVariable.shared.className[indexPath.row]
        
        if icon.contains("전공"){
            cell.imageView?.image = UIImage(named: "major")
        } else if icon.contains("교양"){
            cell.imageView?.image = UIImage(named: "refinement")
        } else {
            cell.imageView?.image = UIImage(named: "undetermined")
        }
        
        cell.textLabel?.text = text.replacingOccurrences(of: "(학부)", with: "")
        cell.detailTextLabel?.text = ""
        
        for i in 0..<submitCheck.count{
            if (submitCheck[i] == "미제출"){
                let deadlineCheck2 = deadlineCheck1[i].split(separator: "~", omittingEmptySubsequences: true)
                let deadlineCheck3 = deadlineCheck2[1].split(separator: " ", omittingEmptySubsequences: true)
                let deadlineCheck4 = deadlineCheck3[0].split(separator: "-", omittingEmptySubsequences: true)
                let deadlineCheck5 = deadlineCheck3[1].split(separator: ":", omittingEmptySubsequences: true)
                
            
                if(currentMonth() <= deadlineCheck4[1] && currentDay() <= deadlineCheck4[2]) {
                    self.taskNameList.append("확인이 필요한 과제 : \(taskName[i])")
                    self.taskAlarmList.append("\(deadlineCheck4[1])$\(deadlineCheck4[2])$\(deadlineCheck5[0])$\(deadlineCheck5[1])")
                    
                    cell.detailTextLabel?.text = "미제출"
                }
            }
        }
        globalVariable.shared.taskAlarm = self.taskAlarmList
        globalVariable.shared.taskAlarmName = self.taskNameList
        
        if (indexPath.row + 1 == globalVariable.shared.className.count){
            if (globalVariable.shared.settingAlarm == true){
                if (globalVariable.shared.timeLabel != "설정"){
                    let hour = UserDefaults.standard.integer(forKey: "hour")
                    let min = UserDefaults.standard.integer(forKey: "min")
                    globalVariable.shared.timeHour = hour
                    globalVariable.shared.timeMinute = min
                    setAlarm()
                }
            }
        }
        
        return cell
    }
}

