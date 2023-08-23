

# AddDeviceIPCamera

##### import RogoCore

### Lấy thông tin camera
```
RGCore.shared.device.getCameraInfoWithType(manufacturer: RGBCameraManufacturer, ip: String, httpPort: String, username: String, password: String, completion: RGBCompletionObject<RGBCameraInfo?>?)
```
Trong đó:
- manufacturer: hãng camera ( Vd: ***.HIKVision*** )
- ip: url của thông tin đường dẫn ***RTSP***
- httpPort: port ***HTTP***
- username: tên đăng nhập camera
- password: mật khẩu camera
- completion: response trả ra ***RGBCameraInfo***, check lỗi

### AddDeviceIPCamera
```
RGCore.shared.device.addCameraWith(deviceInfo: RGBCameraInfo, didUpdateProgessing: ((Int) -> ())?, completion: RGBCompletionObject<Void?>?)
```
Trong đó:
- deviceInfo: truyền vào ***RGBCameraInfo*** được lấy ra từ hàm trên
- didUpdateProgessing: trả ra ***completedPercent***, tiến trình add camera
- completion: check lỗi

### Get CameraStreamUrl
```
RGCore.shared.device.getCameraStreamUrlOf(manufacturer: RGBCameraManufacturer, with: String, port: Int, username: String, password: String)
```
Trong đó:
- manufacture: hãng camera
- with: truyền vào ***deviceInfo.url***
- port: truyền vào ***deviceInfo.port***
- username: truyền vào ***deviceInfo.usrId***
- password: truyền vào ***deviceInfo.pwd***
