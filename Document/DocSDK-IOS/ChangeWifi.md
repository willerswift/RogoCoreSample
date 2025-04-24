
# Change Wifi for Device Wile

##### import RogoCore

### Gửi yêu cầu scan Wifi từ thiết bị

Lưu ý: có thể dùng hàm sendRequestSetupWifiWith độc lập mà không cần dùng đến hàm sendRequestScanWifiOnDeviceWith miễn là truyền đủ các thông tin vào trong hàm sendRequestSetupWifiWith

```
RGCore.shared.device.sendRequestScanWifiOnDeviceWith(deviceId: String,
                                                     timeOut: Int?,
                                                     completion: RGBCompletionObject<[RGBWifiInfo]?>?)
```
Trong đó:
- deviceId: truyền vào uuid của thiết bị Wile cần đổi kết nối Wifi
- timeOut: cài đặt thời gian timeOut VD: 10 (10 giây)
- response: trả ra 1 mảng có kiểu [RGBWifiInfo], RGBWifiInfo chứa các trường ssid: tên Wifi, 
                                                                             authType: Kiểu bảo mật của Wifi (WIFI_AUTH_OPEN, WIFI_AUTH_WEP, WIFI_AUTH_WPA_PSK, WIFI_AUTH_WPA2_PSK, WIFI_AUTH_WPA_WPA2_PSK, WIFI_AUTH_WPA2_ENTERPRISE, WIFI_AUTH_WPA3_PSK, WIFI_AUTH_WPA2_WPA3_PSK, WIFI_AUTH_WAPI_PSK, WIFI_AUTH_MAX), 
                                                                             rssi: Cường độ tín hiệu của Wifi
Vd về lấy ra listSSID:
```
self.listSSID = self.listWifiInfos.filter{ $0.ssid != nil }.map{ $0.ssid!}
```
### Gửi yêu cầu cập nhật Wifi
```
RGCore.shared.device.sendRequestSetupWifiWith(deviceId: String,
                                              wifiSsid: String,
                                              wifiPassword: String,
                                              timeOut: Int?, 
                                              completion: TRGBCompletionObject<Bool?>?(_ response: Bool?, (any Error)?) -> Void)
```

Trong đó:
- deviceId: truyền vào uuid của device Wile muốn đổi kết nối Wifi
- wifiSsid: truyền vào 1 SSID của Wifi trong listSSID scan được
- wifiPassword: truyền vào mật khẩu Wifi
- timeOut: Set thời gian timeOut (VD: 10)
- completion: check lỗi
