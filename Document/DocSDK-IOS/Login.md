## Rogo-SDK-IOS

# Login


### Tạo file AuthenHandler sau đó implement RGBiAuth:

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

