//
//  loginPage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit
import SwiftSoup

class loginPage: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var autoLogin: UIButton!
    
    var isAutoLogin : Bool = false
    
    let session: URLSession = URLSession.shared
    
    let userNotificationCentor = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId.layer.borderWidth = 1.0
        userId.layer.cornerRadius = 10
        userId.layer.borderColor = UIColor.lightGray.cgColor
        userId.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        userId.leftViewMode = .always

        password.layer.borderWidth = 1.0
        password.layer.cornerRadius = 10
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        password.leftViewMode = .always
        
        autoLogin.layer.borderWidth = 1.0
        autoLogin.layer.cornerRadius = 5
        autoLogin.layer.borderColor = UIColor.lightGray.cgColor
        
        login.layer.cornerRadius = 10
        
        logo.image = UIImage(named: "hanbat_logo")
        
        if let Id = UserDefaults.standard.string(forKey: "id") {
            let pw = UserDefaults.standard.string(forKey: "pwd")
            userId.text = Id
            password.text = pw
            isAutoLogin = true
            login.sendActions(for: .touchUpInside)
          
            if let time = UserDefaults.standard.string(forKey: "time") {
                globalVariable.shared.timeLabel = time
                let alarm = UserDefaults.standard.bool(forKey: "setAlarm")
                globalVariable.shared.settingAlarm = alarm
            }
        }
    }
    
    @IBAction func setAutoLoginState(_ sender: UIButton){
        if (isAutoLogin == true){
            isAutoLogin = false
            sender.isSelected = false
            autoLogin.setValue(UIColor.clear, forKey: "backgroundColor")
        } else {
            isAutoLogin = true
            sender.isSelected = true
            autoLogin.setValue(UIColor.init(red: 0, green: 134/255, blue: 170/255, alpha: 1.0), forKey: "backgroundColor")
        }
    }
    
    func showLoginFailAlert(style: UIAlertController.Style){
        let alertController: UIAlertController
        alertController = UIAlertController(title: "로그인 오류", message: "로그인 정보가 잘못되었습니다.", preferredStyle: style)
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: {
            print("Alert controller shown")
        })
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func touchLogin(_ sender: UIButton){
        
        let loginClass = loginClass()
        let isLogin = loginClass.doLogin(session: session, id: userId.text ?? "", pw: password.text ?? "")
        
        if(isLogin) {
            
            var subjectList : [String] = []
            var classificationList : [String] = []
            var taskList = [String](repeating: "", count: 10)
            var deadlineList = [String](repeating: "", count: 10)
            var submissionList = [String](repeating: "", count: 10)
            var taskContentList = [String](repeating: "", count: 10)
            var noticeList = [String](repeating: "", count: 10)
            var noticeContentList = [String](repeating: "", count: 10)
            
            if (self.isAutoLogin == true) {
                UserDefaults.standard.set(self.userId.text, forKey: "id")
                UserDefaults.standard.set(self.password.text, forKey: "pwd")
            } else {
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "pwd")
            }
            
            DispatchQueue.global().async {
                let subjectClass = subjectClass()
                let subjects = subjectClass.getSubjects()
                
                let student = subjectClass.getName(code: subjects[0].code)
                
                for i in 0..<subjects.count {
                    subjectList.append(subjects[i].title)
                    let classification = subjectClass.getClassification(code: subjects[i].code)
                    
                    classificationList.append(classification)
                }
                
                for i in 0..<subjects.count {
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
                globalVariable.shared.classification = classificationList
                globalVariable.shared.deadline = deadlineList
                globalVariable.shared.submitState = submissionList
                globalVariable.shared.taskContent = taskContentList
                globalVariable.shared.taskName = taskList
                globalVariable.shared.noticeName = noticeList
                globalVariable.shared.noticeContent = noticeContentList
                
                DispatchQueue.main.async {
                    let vcName = self.storyboard?.instantiateViewController(withIdentifier: "classPage")
                    self.navigationController?.pushViewController(vcName!, animated: true)
                }
            }
        } else {
            showLoginFailAlert(style: UIAlertController.Style.alert)
        }
    }
}
