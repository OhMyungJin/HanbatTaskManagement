//
//  subjectClass.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import Foundation
import SwiftSoup

struct subject {
    // 과목 코드와 제목
    var code: String
    var title: String
}

struct task {
    // 과제 제목, 기간, 제출여부와 내용
    var title: String
    var deadline: String
    var submission: String
    var content: String
}

struct notice {
    // 공지 제목과 내용
    var title: String
    var content: String
}

class subjectClass: NSObject {
    
    // 수업가져오기
    func getSubjects() -> Array<subject> {
        
        var subjectList:[subject] = []
        
        let homePageURL: URL = URL(string: "https://cyber.hanbat.ac.kr/Main.do?cmd=viewHome")!
        
        do {
            let homePageHtml = try String(contentsOf: homePageURL, encoding: .utf8)
            let homePageDoc: Document = try SwiftSoup.parse(homePageHtml)
            
            for i in 1...10 {
                let subjectTitle: Elements = try homePageDoc.select("ul.ko > li:nth-child(\(i)) > span > a")
                if (try subjectTitle.text() == "") { break }
                
                let code = subjectTitle[0].description.components(separatedBy: "'")[1]
                subjectList.append(subject(code: code, title: try subjectTitle.text()))
            }
        } catch Exception.Error(_, let message){
            print("Messege: \(message)")
        } catch {
            print("error")
        }
        return subjectList
    }
    
    // 과제가져오기
    func getTasks(code: String) -> Array<task> {
        
        var taskList:[task] = []
        
        let homeworkURL: URL = URL(string: "https://cyber.hanbat.ac.kr/Report.do?cmd=viewReportInfoPageList&boardInfoDTO.boardInfoGubun=report&courseDTO.courseId=\(code)&mainDTO.parentMenuId=menu_00104&mainDTO.menuId=menu_00063")!
        
        do{
            let homeworkkHtml = try String(contentsOf: homeworkURL, encoding: .utf8)
            let homeworkDoc: Document = try SwiftSoup.parse(homeworkkHtml)
            
            let noticeInfo: Elements = try homeworkDoc.select("#1 > ul > li:nth-child(1) > a")
            let noticeCode = noticeInfo[0].description.components(separatedBy: "&amp;")[2]
            globalVariable.shared.noticeCode.append(noticeCode)
            
            for i in 1...30 {
                let taskTitle: String = try homeworkDoc.select("#listBox > div:nth-child(\(i)) > dl > dt > h4").text()
                if (taskTitle == ""){ break }
                
                let taskDeadline: String = try homeworkDoc.select("#listBox > div:nth-child(\(i)) > dl > dd > table > tbody > tr > td:nth-child(1)").text()
                let taskSubmission: String = try homeworkDoc.select("#listBox > div:nth-child(\(i)) > dl > dd > table > tbody > tr > td:nth-child(4)").text()
                let taskContent: String = try homeworkDoc.select("#listBox > div:nth-child(\(i)) > dl > dd:nth-child(4) > div").toString()
                
                taskList.append(task(title: taskTitle, deadline: taskDeadline, submission: taskSubmission, content: taskContent))
            }
            
        } catch Exception.Error(_, let message){
            print("Messege: \(message)")
        } catch {
            print("error")
        }
        return taskList
    }
    
    // 공지가져오기
    func getNotices(code: String) -> Array<notice> {
        
        var noticeList:[notice] = []
        
        let noticeURL: URL = URL(string: "https://cyber.hanbat.ac.kr/Course.do?cmd=viewBoardContentsList&mainDTO.parentMenuId=menu_00048&mainDTO.menuId=menu_00056&courseDTO.courseId=2022101988&courseDTO.shareCourseId=&\(code)&boardInfoDTO.boardClass=notice")!
        
        do{
            let noticeHtml = try String(contentsOf: noticeURL, encoding: .utf8)
            let noticeDoc: Document = try SwiftSoup.parse(noticeHtml)
            
            for i in 1...15 {
                let noticeTitle: String = try noticeDoc.select("#listBox > div:nth-child(\(i)) > dl > dt > h4 > a").text()
                if (noticeTitle == ""){ break }
                let noticeContent: String = try noticeDoc.select("#listBox > div:nth-child(\(i)) > dl > dd:nth-child(3) > div").toString()
                
                noticeList.append(notice(title: noticeTitle , content: noticeContent))
            }
                
            
        } catch Exception.Error(_, let message){
            print("Messege: \(message)")
        } catch {
            print("error")
        }
        return noticeList
    }
    // 전공, 교양 분류
    func getClassification(code: String) -> String {
        
        var classification: String = ""
        
        let classificationURL: URL = URL(string: "https://cyber.hanbat.ac.kr/Course.do?cmd=viewCourseInfo&boardInfoDTO.boardInfoGubun=course_info&courseDTO.courseId=\(code)&mainDTO.parentMenuId=menu_00047&mainDTO.menuId=menu_00053")!
        
        do{
            let classificationHtml = try String(contentsOf: classificationURL, encoding: .utf8)
            let classificationDoc: Document = try SwiftSoup.parse(classificationHtml)
            
            classification = try classificationDoc.select("#listBox > table > tbody > tr:nth-child(3) > td:nth-child(4)").text()
            
        } catch Exception.Error(_, let message){
            print("Messege: \(message)")
        } catch {
            print("error")
        }
        
        return classification
    }
    // 이름 가져오기
    func getName(code: String) -> String {
        
        var student: String = " "
        
        let nameURL: URL = URL(string: "https://cyber.hanbat.ac.kr/Course.do?cmd=viewCourseInfo&boardInfoDTO.boardInfoGubun=course_info&courseDTO.courseId=\(code)&mainDTO.parentMenuId=menu_00047&mainDTO.menuId=menu_00053")!
        
        do{
            let nameHtml = try String(contentsOf: nameURL, encoding: .utf8)
            let nameDoc: Document = try SwiftSoup.parse(nameHtml)
            
            student += try nameDoc.select("#header > div > ul > li.w230 > dl > dt").text()
            
        } catch Exception.Error(_, let message){
            print("Messege: \(message)")
        } catch {
            print("error")
        }
        return student
    }
}
