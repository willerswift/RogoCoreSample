
# Login

##### import RogoCore

### Tạo file AuthenHandler sau đó implement RGBiAuth:

Vd:
```
import Foundation
import RogoCore

public let RG_ACCESS_TOKEN_KEY = "rg_remember_rogo_access_token"
class AuthenHandler: RGBiAuth {
    func isAuthenticated(_ method: RGBAuthMethod) -> Bool {
        
    }
    
    func getAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
        
        
    }
    
    func refreshAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
    
    }
}
```
Trong đó:

- isAuthenticated: kiểm tra xem người dùng đã đăng nhập hay chưa

- getAccessToken: cần trả về cho SDK 1 giá trị Rogo Token

- refreshAccessToken: khi token đã quá hạn, đùng để gia hạn cho token

### Set custom authen:
```
RGCore.shared.setCustomAuthenticate(customAuth: AuthenHandler.shared)
```

