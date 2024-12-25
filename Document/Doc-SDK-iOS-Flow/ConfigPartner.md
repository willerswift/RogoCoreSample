
# Cấu hình Partner

### import RogoCore vào AppDelegate để sử dụng hàm config trong SDK Rogo

### Gọi hàm config trong application(_:didFinishLaunchingWithOptions:) của AppDelegate

```
// Cài đặt môi trường
RGCore.shared.setTargetEnviroment(environment: .production)
// Config Partner
RGCore.shared.config(appKey: String,
                     appSecret: String) { response, error in
        guard response == true, error == nil else {
            return
        }
    }

```
Trong đó: appKey và appSecret sẽ được bên phía Rogo cung cấp tương ứng với môi trường .production hoặc .development
