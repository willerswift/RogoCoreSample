

# Spotify Linking

##### import RogoCore

### Link web view Login Spotify
```
https://accounts.spotify.com/en/authorize?scope=user-read-private+user-read-email+streaming+app-remote-control&response_type=code&flow_ctx=e6aaf236-8a2d-42d3-909a-26ab4787f464:1704892552&redirect_uri=fpt-life://fptsmarthome.vn/spotify&state=58749648-4da7-459e-ac0f-a5d6cc45932c&client_id=5eb7f8db95c546518faba801730ab589
```

### Link tài khoản Spotify
```
RGCore.shared.linking?.addLinking(service: RGBLinkingServiceType,
                                  authenCode: String,
                                  completion: (_ response: RGBLinkingInfo?, Error?) -> Void)
```
Trong đó:
- service: .Spotify
- authenCode: Vd lấy ra authenCode
```
let redirectUrl = "fpt-life://fptsmarthome.vn/spotify"

    extension SpotifyOAuthenVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let redirectUrl = navigationAction.request.url,
           let host = redirectUrl.host,
           host == URL(string: self.redirectUrl)?.host,
           let authenCode = redirectUrl.valueOf("code") {...}
           
```
- completion: check lỗi

### Unlink tài khoản Spotify
```
RGCore.shared.linking?.deletedLinking(uuid: String, completion: (_ response: Bool, Error?) -> Void)
```
Trong đó:
- uuid: uuid của linking 
###### Vd: 
```
let uuidLinking = RGCore.shared.user.linkings.first(where: {$0.linkingType == .Spotify})?.uuid
```
- completion: check lỗi

### Check tài khoản đã được link hay chưa
######Vd:
```
        RGCore.shared.user.linkings.first(where: {$0.linkingType == .Spotify}) == true
```
Trong đó:
- true là đã link và false là chưa link

### Link box với Spotify

#### Trường hợp check : credential = RGCore.shared.user.linkings.first(where: {$0.linkingType == .Spotify})?.extraInfo?.credentials, credential.count > 0
```
RGCore.shared.linking?.linkingDeviceToSpotifyWith(device: RGBDevice, spotifyAccountPassword: String?, creadential: String?, observer: AnyObject?, completion: (_ response: Bool?, Error?) -> Void)
```

Trong đó:
- device: truyền vào device muốn link
- spotifyAccountPassword: nil
- creadential: credential
- observer: nil
- completion: check lỗi

#### Trường hợp chưa có credential
```
RGCore.shared.linking?.linkingDeviceToSpotifyWith(device: RGBDevice, spotifyAccountPassword: String?, creadential: String?, observer: AnyObject?, completion: (_ response: Bool?, Error?) -> Void)
```

Trong đó:
- device: truyền vào device muốn link
- spotifyAccountPassword: Nhập mật khẩu Spotify
- creadential: nil
- observer: nil
- completion: check lỗi

### Check device đã link với Spotify hay chưa
###### Vd:
```
RGCore.shared.linking?.checkDeviceIsLinkingSpotify(deviceUUID: deviceID) == false
```

Trong đó:
- true là đã link và false là chưa link

### Unlink device
```
RGCore.shared.linking?.unlinkDeviceToSpotifyWith(deviceUUID: String, spotifyAccountPassword: String?, observer: AnyObject?, completion: (_ response: Bool?, Error?) -> Void)
```
Trong đó:
- deviceUUID: truyền vào uuid của device muốn unlink
- spotifyAccountPassword: truyền vào mật khẩu Spotify
- observer; nil
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
