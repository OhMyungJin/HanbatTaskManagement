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
        var token: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        if let tokenGetUrl: URL = URL(string: "https://eclass.hanbat.ac.kr/xn-sso/login.php?auto_login=&sso_only=&cvs_lgn=&site=&return_url=https%3A%2F%2Feclass.hanbat.ac.kr%2Fxn-sso%2Fgw-cb.php%3Ffrom%3D%26site%3D%26login_type%3Dstandalone%26return_url%3D") {
            
            let task = session.dataTask(with: tokenGetUrl) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let headers = httpResponse.allHeaderFields
                    for (key, value) in headers {
                        if key as! String == "Set-Cookie" {
                            let value = value as! String
                            let startIndex = value.index(value.startIndex, offsetBy: 33)
                            let endIndex = value.index(startIndex, offsetBy: 64)
                            
                            token = String(value[startIndex..<endIndex])
                            print(token)
                        }
                    }
                } else {
                    print("응답이 HTTP 형식이 아닙니다.")
                }
            }
            
            task.resume()
        } else {
            print("유효하지 않은 URL입니다.")
        }
        
//        let loginPage: URL = URL(string: "https://cyber.hanbat.ac.kr/User.do?cmd=loginUser")!
        let loginPage: URL = URL(string: "https://eclass.hanbat.ac.kr/xn-sso/gw-cb.php?from=&site=&login_type=standalone&return_url=")!
        
        globalVariable.shared.studentID = id
        globalVariable.shared.studentPW = pw

        var components = URLComponents(url: loginPage, resolvingAgainstBaseURL: false)!

        components.queryItems = [
//            URLQueryItem(name: "cmd", value: "loginUser"),
//            URLQueryItem(name: "userId", value: id),
//            URLQueryItem(name: "password", value: pw)
            URLQueryItem(name: "csrf_token", value: token),
            URLQueryItem(name: "user_login_gubun", value: "S"),
            URLQueryItem(name: "login_user_id", value: id),
            URLQueryItem(name: "login_user_password", value: pw)
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
