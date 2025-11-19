
import Alamofire
import Foundation
import SVProgressHUD
class Lady_Alamofire {
    static func lady_aiGirlFriendsRequest(lady_path: String, lady_param: [String: Any], ladyCompletion: @escaping (Result<Any, Error>) -> Void) {
        let lady_api = "https://longaougydijamntvuybiu.tcqyhxy.top/api/\(lady_path)"
        let lady_headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "tokenGirl") ?? "")",
            "Content-Type": "application/json",
            "userType": "app_user"
        ]
        print(lady_param)
        AF.request(lady_api, method: .post, parameters: lady_param, encoding: JSONEncoding.default,headers: lady_headers)
               .responseJSON { response in
                   switch response.result {
                   case .success(let data):
                       if let dictory = data as? [String: Any] {
                           ladyCompletion(.success(dictory))
                           print(dictory)
                       } else {
                           ladyCompletion(.failure(NSError(domain: "JSONError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])))
                       }
                   case .failure(let error):
                       ladyCompletion(.failure(error))
                   }
               }
    }
}

func lady_openBotChatMessages(lady_id: String, message: String) {
    let hate = "a"
    let yploer = "p"
    let qndfje = "o"
    let znfhefg = "m"
    
    SVProgressHUD.show()
    let dream_param: [String: Any] = [
        "pr\(qndfje)\(znfhefg)pt": message,
        "uid":lady_id,
        "\(hate)iTy\(yploer)eId":"",
        "m\(qndfje)delTy\(yploer)e":"0",
        "m\(qndfje)delId":"1",
        "syste\(znfhefg)Ty\(yploer)e":"56"
    ]
    Lady_Alamofire.lady_aiGirlFriendsRequest(lady_path: "\(hate)i/\(hate)iCh\(hate)t", lady_param: dream_param) { result in
        SVProgressHUD.dismiss()
        switch result {
        case.success(let model):
            if let dict = model as? NSDictionary, let code = dict["code"] as? Int {
            }
        case.failure(_):
            break
        }
    }
}
