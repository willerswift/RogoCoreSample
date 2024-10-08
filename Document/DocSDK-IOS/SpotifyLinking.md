

# Spotify Linking

##### import RogoCore

### Kiểm tra thiết bị đã được liên kết với Spotify hay chưa

```
RGCore.shared.linking?.checkDeviceIsLinkingSpotify(deviceUUID: String)

```
Trong đó:

- deviceUUID: uuid của thiết bị
- nếu RGCore.shared.linking?.checkDeviceIsLinkingSpotify(deviceUUID: uuid) == true thiết bị đã được link với tài khoản Spotify và ngược lại

### Link thiết bị vào tài khoản Spotify

```
RGCore.shared.linking?.linkingDeviceToSpotifyWith(deviceUUID: String,
                                                  timeout: Int?,
                                                  observer: AnyObject?,
                                                  completion: RGBCompletionObject<Bool?>?(_ response: Bool?, (any Error)?) -> Void)
```
Trong đó:

- deviceUUID: uuid của thiết bị
- timeout: set thời gian timeout (Vd: 120) đơn vị giây
- observer: self
- completion: check lỗi
- Sau khi gọi linkingDeviceToSpotifyWith vào app Spotify và tìm thiết bị có mã code giống với mã code được tạo ra từ hàm và tiến hành chọn thiết bị đó trên app Spotify, sau khi tiến trình link hoàn tất tên thiết bị sẽ được hiển thị bên trên app Spotify

Vd:

```
let code = RGCore.shared.linking?.linkingDeviceToSpotifyWith(deviceUUID: String,
                                                  timeout: Int?,
                                                  observer: AnyObject?,
                                                  completion: RGBCompletionObject<Bool?>?(_ response: Bool?, (any Error)?) -> Void)
sau khi hàm được gọi sẽ lấy được mã code
```

### Huỷ quá trình link thiết bị vào Spotify

```
RGCore.shared.linking?.cancelLinkingDeviceToSpotifyWith(deviceUUID: String,
                                                        timeout: Int?,
                                                        observer: AnyObject?,
                                                        completion: RGBCompletionObject<Bool?>?(_ response: Bool?, (any Error)?) -> Void)
```

Trong đó:

- deviceUUID: uuid của thiết bị
- timeout: set thời gian timeout (Vd: 120) đơn vị giây
- observer: self
- completion: check lỗi

### Unlink thiết bị ra khỏi tài khoản Spotify

```
RGCore.shared.linking?.unlinkDeviceToSpotifyWith(deviceUUID: String,
                                                 timeout: Int?, 
                                                 observer: AnyObject?, 
                                                 completion: RGBCompletionObject<Bool?>?(_ response: Bool?, (any Error)?) -> Void)
```
Trong đó:

- deviceUUID: uuid của thiết bị
- timeout: set thời gian timeout (Vd: 120) đơn vị giây
- observer: self
- completion: check lỗi

### Lấy ra tên người dùng và email

#### Tên người dùng
```
RGCore.shared.user.linkings.first(where: {$0.linkingType == .Spotify})?.info?.displayName
```
#### Email
```
RGCore.shared.user.linkings.first(where: {$0.linkingType == .Spotify})?.info?.email
```
