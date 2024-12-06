# AddDeviceWile

##### import RogoCore

### Luồng thêm thiết bị Wile

![addDeviceWileFlow](https://github.com/user-attachments/assets/e8f3a58f-b20d-48f6-82d2-c2e18c293a84)

### Scan Wile device
```
 RGCore.shared.device.scanAvailableWileDevice(timeout: Int, completion: RGBCompletionObject<RGBMeshScannedDevice?>?)
 ```
 Trong đó: 
 - timeout: set thời gian time out
 - completion: check lỗi

### Add Wile device
```
                                        
RGCore.shared.device.startConfigWileDevice(device: RGBMeshScannedDevice,
                                           didUpdateProgessing: ((Int) -> ())?,
                                           wifiScanCompletedHandler: (([RGBWifiInfo]) -> ())?,
                                           wifiSelectionHandler: &((String, String) -> ())?,
                                           wifiConnectErrorHandler: ((String?, String?,
                                           RGBWifiConnectionErrorType) -> ())?,
                                           didCompletedHandler: ((RGBDevice?) -> ()))
```

Trong đó:
- device: Truyền vào wile device đã scan ra được
- didUpdateProgessing : trả ra ***completedPercent*** hiển thị phần trăm tiến trình add thiết bị
- wifiScanCompletedHandler: lấy ra được list RGBWifiInfo, bên trong nó có các trường ssid: tên Wifi, rssi: độ mạnh yếu của tín hiệu, authType: kiểu bảo mật, khi nó thuộc kiểu .WIFI_AUTH_OPEN là wifi không pass
- wifiSelectionHandler : lấy được ***SSID***
- wifiConnectErrorHandler : hiển thị phần ***thông báo lỗi*** cho wifi
- didCompletedHandler : trả ra ***device*** vừa được add

### Add Wile device sử dụng Delegate

thêm RGBWileDelegate vào class của bạn. Việc này đảm bảo rằng class có thể xử lý các sự kiện hoặc thông báo liên quan đến các thiết bị RGB khi giao thức này yêu cầu.

```
RGCore.shared.device.wileDelegate = self                        
RGCore.shared.device.startConfigWileDevice(device: RGBMeshScannedDevice)
```
Trong đó:
- device: Truyền vào wile device đã scan ra được
Trong trường hợp này, việc gán self cho wileDelegate có nghĩa là lớp hiện tại sẽ là delegate của device, chịu trách nhiệm xử lý các sự kiện hoặc hành động từ thiết bị, tiếp theo gọi startConfigWileDevice để bắt đầu quá trình cấu hình thiết bị
Thêm RGBWileDelegate vào class của bạn. Việc này đảm bảo rằng class có thể xử lý các sự kiện hoặc thông báo liên quan đến các thiết bị khi giao thức này yêu cầu, sau khi thêm xong sẽ có 5 hàm này:
```
    func didConnectDeviceSuccess(setDeviceInfoHandler: ((String?, String?) -> ())?) {
        
    }
    
    func didScannedWifiInfo(_ listWifiInfos: [RogoCore.RGBWifiInfo], wifiSelectionHandler: ((String, String) -> ())?) {
        
    }
    
    func didUpdateProgessing(percent: Int) {
        
    }
    
    func didFailedToConnectWifi(_ ssid: String?, _ password: String?, _ wifiConnectionState: RogoCore.RGBWifiConnectionErrorType) {
        
    }
    
    func didFinishAddWileDevice(response: RogoCore.RGBDevice?, error: (any Error)?) {
        
    }
```
Trong đó:
- didConnectDeviceSuccess: trong setDeviceInfoHandler sẽ có 2 String truyền vào (tên thiết bị mà bạn muốn đặt tên, uuid của nhóm phòng bạn muốn thêm thiết bị vào)
- didScannedWifiInfo: hàm này sẽ trả ra danh sách các wifi mà nó quét được xung quanh ở bên trong listWifiInfos trong đó có authType là kiểu bảo mật, ssid của wifi và rssi là cường độ tín hiệu
trong wifiSelectionHandler sẽ có 2 String truyền vào (SSID mà bạn chọn kể thiết bị kết nối, mật khẩu)
- didUpdateProgessing: hiển thị phần trăm tiến trình thêm thiết bị
- didFailedToConnectWifi: hàm này sẽ trả ra được mã lỗi khi có vấn đề trong quá trình kết nối tới wifi
Vd:

```
    func didFailedToConnectWifi(_ ssid: String?, _ password: String?, _ wifiConnectionState: RogoCore.RGBWifiConnectionErrorType) {
        
        switch wifiConnectionState {
            
        case .PASSWORD_WRONG:
            setupWifiPopup.lbNoti.isHidden = false
            setupWifiPopup.lbNoti.text = "Sai mật khẩu".localize()
        case .SSID_NOTFOUND:
            setupWifiPopup.lbNoti.isHidden = false
            setupWifiPopup.lbNoti.text = "Không tìm thấy SSID".localize()
        case .SOMETHING_WENT_WRONG:
            setupWifiPopup.lbNoti.isHidden = false
            setupWifiPopup.lbNoti.text = "Tên Wifi không tồn tại".localize()
        default:
            break
        }
        
        RGUIPopup.showPopupWith(contentView: setupWifiPopup)
        
    }
```
- didFinishAddWileDevice: hàm này sẽ có response trả ra kiểu RGBDevice khi hoàn thành quá trình add
### Huỷ quá trình config Wile
```
RGCore.shared.device.cancelWileConfig()
```
