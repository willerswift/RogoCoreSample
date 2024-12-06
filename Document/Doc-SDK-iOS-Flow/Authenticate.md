
# Authenticate

##### import RogoCore

### Luồng cài đặt môi trường và cấu hình partner

![configApp](https://github.com/user-attachments/assets/7215510d-2483-4a8d-93cf-75316a5c2d4d)

Trong hàm application(_:didFinishLaunchingWithOptions:) của AppDelegate gọi hàm set môi trường sau đó gọi hàm cofig 

#### Hàm gọi set môi trường:

```
RGCore.shared.setTargetEnviroment(environment: <RGBNetworkEnvironment)
```

Trong đó:
- environment: truyền vào .development hoặc .production

#### Hàm config appKey và appSecret của Partner:

```
    RGCore.shared.config(appKey: String,
                         appSecret: String) { response, error in
        guard response == true, error == nil else {
            return
        }
    }
```

Trong đó:
- appKey, appSecret: truyền vào appKey, appSecret được cung cấp

### Luồng đăng ký tài khoản

![signup](https://github.com/user-attachments/assets/90b7c5f6-9b35-4723-a9e6-ed8310650922)

```
RGCore.shared.auth.signUp(email: String,
                          username: String,
                          phone: String,
                          password: String,
                          completion: RGBCompletionObject<RGBAuthResponse>)
```
Trong đó:
- email: truyền vào email dùng để đăng ký tài khoản
- username: truyền vào tên đăng nhập dùng để đăng ký tài khoản (tối thiểu 6 ký tự)
- phone: truyền vào số điện thoại (trong trường hợp không cần sử dụng có thể truyền vào là nil)
- password: truyền voà mật khẩu đăng ký tài khoản
- completion: check lỗi, bên dưới là ví dụ về các ví dụ về các mã lỗi được trả ra để hiển thị

  ```
  RGCore.shared.auth.signUp(email,
                            username: username,
                            phone: nil,
                            password: password) { response, error in
                if error == nil {
                    self.state.send(.success)
                } else {
                    if let rgErrr = error as? RGBError {
                        if rgErrr.errorCode == .username_is_already_existed {
                            self.state.send(.usernameExisted)
                        } else if rgErrr.errorCode == .email_is_already_existed {
                            self.state.send(.emailExisted)
                        }
                    }
                    self.state.send(.fail(error: error))
                }
  
  ```
  #### Hàm verify Email

  ```
  RGCore.shared.auth.verifyAuthenCode(code: String, completion: RGBCompletionObject<RGBAuthResponse>)
  ```

Trong đó:
- code: truyền vào mã verify code mà bạn đã truyền vào khi sử dụng hàm đăng ký tài khoản
- completion: dùng để check error, trong trường hợp hợp verify không thành công người dùng vẫn có thể sử dụng username để đăng nhập tài khoản nhưng nếu muốn sử dụng tính năng đăng nhập bằng email, quên mật khẩu hoặc đổi mật khẩu tài khoản thì cần verify thành công email

### Luồng đăng nhập

![signin](https://github.com/user-attachments/assets/a1f3f324-0654-4856-81cb-c5c1b0cbb7d0)

#### Hàm đăng nhập

##### Hàm kiểm tra người dùng đã đăng nhập hay chưa, nếu đã đăng nhập trước đó rồi thì không yêu cầu người dùng đăng nhập lại nữa
```
if RGCore.shared.auth.isAuthenticated() == false {
//Chưa đăng nhập
} else {
//Đã được đăng nhập
}
```

##### Hàm đăng nhập bằng username

```
RGCore.shared.auth.signInWithUsername(username: String,
                                      password: String,
                                      completion: RGBCompletionObject<RGBAuthResponse>)
```

Trong đó:
- username: truyền vào tên đăng nhập của người dùng
- password: truyền vào mật khẩu tài khoản của người dùng
- completion: phần check lỗi xem đăng nhập thành công hay thất bại, nếu error == nil thì đã đăng nhập tài khoản thành công

##### Hàm đăng nhập bằng email

```
RGCore.shared.auth.signInWithEmail(email: String,
                                   password: String,
                                   completion: RGBCompletionObject<RGBAuthResponse>)

```
Trong đó:
- email: truyền vào tên email của người dùng
- password: truyền vào mật khẩu tài khoản của người dùng
- completion: phần check lỗi xem đăng nhập thành công hay thất bại, nếu error == nil thì đã đăng nhập tài khoản thành công

Khi đã đăng nhập tài khoản thành công bằng tên người dùng hoặc email tiếp theo ta cần kiểm tra xem đã có location nào được chọn chưa bằng cách check selectedLocation

```
RGCore.shared.user.selectedLocation

```
Trong đó:
- nếu selectedLocation = nil thì chuyển view list Location và cho phép người dùng chọn 1 location để truyền vào hàm setSelectedLocation còn nếu !nil thì cho phép chuyển thẳng sang Home view

```
RGCore.shared.user.setSelectedLocation(locationId: String)

```
Trong đó:
- locationId: truyền vào uuid của location mà người dùng chọn (Vd: selectLocation.uuid)

##### Hàm lấy ra danh sách các location trong tài khoản
```
RGCore.shared.user.locations
```

### Luồng quên mật khẩu tài khoản

![forgotpass](https://github.com/user-attachments/assets/10a83e3d-e5c4-4330-8d80-f0107ae06d77)

#### Hàm gửi mã xác thực tới email

```
RGCore.shared.auth.requestVerifyCode(email: String,
                                     completion: RGBCompletionObject<RGBAuthResponse>)
```
Trong đó:
- email: truyền vào email để yêu cầu gửi mã xác thực
- completion: nếu trong trường hợp error != nil, đẩy popUp Fail, còn nếu trường hợp không có lỗi sẽ chuyển thằng sang view nhâp code và đổi mật khẩu

```
RGCore.shared.auth.resetPasswordWith(code: String,
                                     newPassword: String,
                                     completion: RGBCompletionObject<RGBAuthResponse>)
```
Trong đó:
- code: truyền vào code được gửi tới email
- newPassword: truyền vào password mới
- completion: check lỗi để đẩy popUp phù hợp
