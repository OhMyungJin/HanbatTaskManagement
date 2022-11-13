//
//  globalVariable.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import Foundation

class globalVariable {
    static let shared: globalVariable = globalVariable()
    
    var studentID: String?
    var studentPW: String?
    var studentName: String?
    var className: [String] = []
    var classification: [String] = []
    var taskName = [String](repeating: "", count: 10)
    var deadline = [String](repeating: "", count: 10)
    var submitState = [String](repeating: "", count: 10)
    var taskContent = [String](repeating: "", count: 10)
    var noticeName = [String](repeating: "", count: 10)
    var noticeContent = [String](repeating: "", count: 10)
    var noticeCode: [String] = []
    var taskTitle: String?
    var noticeTitle: String?
    var taskPartContent: String?
    var noticePartContent: String?
    var tableViewIndexPath = 0
    var timeHour = 0
    var timeMinute = 0
    var timeLabel: String? = "시간 설정"
    var taskAlarm: [String] = []
    var taskAlarmName: [String] = []
    var settingAlarm: Bool = false
}
