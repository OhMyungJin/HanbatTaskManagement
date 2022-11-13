//
//  settingTimePage.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import UIKit

class settingTimePage: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var confirmbtn: UIButton!
    
    var timeInt: Int = Int()
    var tableView: UITableView?
    var timetext: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timePicker.countDownDuration = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.setValue(UIColor.black, forKeyPath: "textColor")
        timePicker.subviews[0].subviews[1].backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.timeLabel.text = "제출 마감 00 : 10 전에 알람이 울립니다."
    }
    
    @IBAction func timePickerValueChange(_ sender: UIDatePicker){
        timeInt = Int(timePicker.countDownDuration) / 60
        
        if timeInt >= 60{
            let hour: Int = timeInt / 60
            let minute: Int = timeInt % 60
            
            if hour < 10 {
                self.timeLabel.text = "제출 마감 0\(hour) : \(minute) 전에 알람이 울립니다."
                self.timetext = "마감 0\(hour)시간 \(minute)분 전"
            }else{
                self.timeLabel.text = "제출 마감 \(hour) : \(minute) 전에 알람이 울립니다."
                self.timetext = "마감 \(hour)시간 \(minute)분 전"
            }
            
            if minute == 0{
                if hour < 10 {
                    self.timeLabel.text = "제출 마감 0\(hour) : 00 전에 알람이 울립니다."
                    self.timetext = "마감 0\(hour)시간 00분 전"
                }else{
                    self.timeLabel.text = "제출 마감 \(hour) : 00 전에 알람이 울립니다."
                    self.timetext = "마감 \(hour)시간 00분 전"
                }
            }
        }else{
            self.timeLabel.text = "제출 마감 00 : \(timeInt) 전에 알람이 울립니다."
            self.timetext = "마감 00시간 \(timeInt)분 전"
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: UIButton){
        
        if timeInt == 0 {
            timetext = "마감 00시간 10분 전"
            timeInt = 10
        }
        
        globalVariable.shared.timeLabel = timetext
        globalVariable.shared.timeHour = timeInt / 60
        globalVariable.shared.timeMinute = timeInt % 60
        
        UserDefaults.standard.set(self.timeInt / 60, forKey: "hour")
        UserDefaults.standard.set(self.timeInt % 60, forKey: "min")
        UserDefaults.standard.set(self.timetext, forKey: "time")
        
        dismiss(animated: true, completion: {self.tableView?.reloadData()})
    }
}
