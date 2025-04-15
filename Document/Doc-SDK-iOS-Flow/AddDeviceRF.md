

# AddDeviceRF

##### import RogoCore

### Luồng thêm thiết bị RF

![addDeviceRF](https://github.com/user-attachments/assets/9a5ef94d-75a9-4b30-9bcb-448ad451bdad)

### Kiểm tra trạng thái thiết bị hub RF

```
RGCore.shared.device.getRFHubStatus(at: RGBLocation,
                                    observer: AnyObject?,
                                    timeout: Int,
                                    completion: (_ response: RGBRFHubStatus?, (any Error)?) -> Void)
```

Trong đó:
- at: truyền vào 1 location <RGBLocation>
Vd truyền vào location hiện tại:

```
let currentLocation = RGcore.share.user.selectedLocation
```
- observer: self
- timeout: set thời gian timeout Vd: 5 (5 giây)
- completion: check lỗi

### Scan device RF

```
RGCore.shared.device.startScanRFDevice(deviceType: RGBProductType,
                                       gateWay: RGBDevice,
                                       timeout: Int,
                                       observer: AnyObject?,
                                       completion: <RGBMeshScannedDevice?>?)
```
Trong đó:
- deviceType: truyền vào loại thiết bị Vd: .BM_SmokeSensor, thiết bị cảm biến khói
- gateWay: truyền vào thiết bị hub <hay còn gọi là thiết bị gateWay - RGBDevice>
- timeout: set thời gian timeout Vd: 60 (60 giây)
- observer: self
- completion: check lỗi, trả ra 1 RGBMeshScannedDevice là thiết bị RF quét được

### Add device RF vừa scan được
```
RGCore.shared.device.addRFDevice(device: RGBMeshScannedDevice,
                                 toHub: RGBDevice,
                                 didUpdateProgessing: (_ completedPercent: Int) -> (),
                                 completion: (_ response: RGBDevice?, (any Error)?) -> Void)
```
Trong đó:
- device: truyền vào loại thiết bị RF vừa mới scan được
- toHub: truyền vào thiết bị hub <hay còn gọi là thiết bị gateWay - RGBDevice>
- didUpdateProgessing: trả ra completedPercent để hiển thị tiến trình add thiết bị
- completion: check lỗi, trả ra 1 RGBDevice chính là thiết bị sau khi add thành công
Vd:
```
RGCore.shared.device.addRFDevice(device: device, toHub: deviceHub) { completedPercent in
        
            // Hiển thị phần trăm
            lbPercent.text = completedPercent
            
        } completion: { response, error in
        
        if error == nil {
        
        // Thêm thiết bị thành công
        
        }
        
        // Thêm thiết bị thất bại
            print(error)
            
        }

```
#### Dừng scan thiết bị RF
```
RGCore.shared.device.stopScanRFDevice(gateWay: RGBDevice)
```
Trong đó:
- gateWay: truyền vào device hub được chọn để add <RGBDevice>

#### Sử dụng hàm test cho thiết bị RF

##### Sử dụng hàm test cho tất cả thiết bị RF
```
RGCore.shared.device.sendRFSelfTestCommandToAllDevices(inGatewayUuid: String, completion: (_ response: Bool, (any Error)?) -> Void)
```
Trong đó:
- inGatewayUuid: truyền vào uuid của device gateWay

##### Sử dụng hàm test cho 1 thiết bị RF
```
RGCore.shared.device.sendRFSelfTestCommandToDevice(deviceUuid: String, completion: (_ response: Bool, (any Error)?) -> Void)
```
Trong đó:
- deviceUuid: truyền vào uuid của thiết bị cảm biến

#### Sử dụng hàm locate cho thiết bị RF
```
RGCore.shared.device.sendRFDeviceLocateLocationCommand(rootUuid: String, isLocate: Bool, completion: (_ response: Bool, (any Error)?) -> Void)
```
Trong đó:
- rootUuid: truyền vào uuid của device gateWay
- isLocate: truyền true

#### Sử dụng hàm test network cho thiết bị RF
```
RGCore.shared.device.sendRFSelfTestNetworkCommand(rootUuid: String, timeOut: Int?, completion: (_ response: [String : Bool]?, (any Error)?) -> Void)
```
Trong đó:
- rootUuid: truyền vào uuid của device gateWay
- timeOut: truyền vào thời gian timeOut

#### Lấy ra tất cả các thiết bị cảm biến khói đang được gắn với Gateway

```
self.listDeviceSmokeSensor = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter {$0.rootUUID == gatewayUuid} ?? []

```
Trong đó:
- gatewayUuid: truyền vào uuid của device gateWay, sau đó count listDeviceSmokeSensor là đã có thể lấy được số lượng cảm biến đang được gắn vào Gateway
