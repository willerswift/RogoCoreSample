## Rogo-SDK-IOS

#SetFileRogoCocoapodAndLogin

import RogoCore

###Các bước cài file RogoCore vào project sử dụng cocoapods và Login Tk

B1: Để tích hợp RogoCore vào dự án Xcode bằng CocoaPods, thêm nó vào Podfile

pod 'RogoCore'

B2: Thêm module RogoCore vào AppDelegate

B3: Trong hàm application(_:didFinishLaunchingWithOptions:)

Thêm vào:

        RGCore.shared.config(appKey: "ecde7b0323af44eb890e27c4b5a9d0a8",
                             appSecret: "3e9e598e8a17789e3af931b9b0f8cf6f4670e2a48e38") { response, error in
            guard response == true, error == nil else {
                return
            }
        }
B4: Tạo file AuthenHandler sau đó implement RGBiAuth:

Vd:
import Foundation
import RogoCore

public let RG_ACCESS_TOKEN_KEY = "rg_remember_rogo_access_token"
class AuthenHandler: RGBiAuth {
    func isAuthenticated(_ method: RGBAuthMethod) -> Bool {
        return UserDefaults.standard.string(forKey: RG_ACCESS_TOKEN_KEY) != nil
    }
    func getAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
        completion(UserDefaults.standard.string(forKey: RG_ACCESS_TOKEN_KEY), nil)
    }
    func refreshAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
    }
}

Trong đó:

-isAuthenticated: kiểm tra xem người dùng đã đăng nhập hay chưa, nếu đã có Token thì lưu lại vào local

-getAccessToken: cần trả về hàm này 1 giá trị token <rogo Token>

-refreshAccessToken: khi token đã quá hạn, đùng để gia hạn cho token

