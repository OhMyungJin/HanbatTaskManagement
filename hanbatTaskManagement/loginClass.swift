//
//  loginClass.swift
//  hanbatTaskManagement
//
//  Created by Mjolnir on 2022/08/30.
//

import Foundation

class loginClass: NSObject {
    
    func doLogin(session: URLSession, id: String, pw: String) -> Bool{
        
        var result: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        
        let loginPage: URL = URL(string: "https://cyber.hanbat.ac.kr/User.do?cmd=loginUser")!
        
        globalVariable.shared.studentID = id
        globalVariable.shared.studentPW = pw

        var components = URLComponents(url: loginPage, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "cmd", value: "loginUser"),
            URLQueryItem(name: "userId", value: id),
            URLQueryItem(name: "password", value: pw)
        ]

        let query = components.url!.query
        var request = URLRequest(url: loginPage)
        request.httpMethod = "POST"
        request.httpBody = Data(query!.utf8)

        session.dataTask(with: request) {data, response, error in
            let dataString = String(data: data!, encoding: .utf8)
            if((dataString!.contains("처리 중 오류가 발생했습니다.")) == true) {
                result = false
            } else {
                result = true
            }
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        
        return Bool(result)
    }
}
