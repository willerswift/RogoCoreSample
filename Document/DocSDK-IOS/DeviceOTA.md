# Device OTA

##### import RogoCore

### Kiểm tra firmware của thiết bị xem phải firmware mới nhất chưa
```
    RGCore.shared.device.checkFirmwareIsLatestWith(deviceId: String, completion: (isLastestVersion: Bool?, currentVersion: String?, latestVersion: String?)?, (any Error)?) -> Void)
```
 Trong đó: 
 - deviceId: truyền vào uuid của device
 - completion: check lỗi, response.isLastestVersion : true (đang ở ver mới nhất, false: chưa phải ver mới nhất)
response.currentVersion : trả ra ver hiện tại của thiết bị
response.latestVersion : trả ra ver mới nhất của thiết bị có thể OTA lên

### Sau khi kiểm tra ver đang không phải là ver mới nhất thì tiến hành gửi request Update
```
                                        
    RGCore.shared.device.requestUpdateFirmwareForDeviceWith(deviceId: String, completion: (_ response: Bool?, (any Error)?) -> Void)
```

Trong đó:
- deviceId: Truyền vào deviceId của thiết bị
- completion: true - gửi request thành công, ngược lại với trường hợp false - có in ra lỗi print(error) để xem thêm thông tin về lỗi
