

# AddDeviceBLE

##### import RogoCore

### B1: Scan device BLE
```
RGCore.shared.device.scanAvailableBleDevice(timeout: Int, completion: RGBCompletionObject<RGBMeshScannedDevice?>?)
```

- Scan các thiết bị BLE khả dụng

Trong đó:
- timeout: set thời gian timeout Vd: 60 -> 60 giây
- completion: check lỗi

Vd: 
```
RGCore.shared.device.scanAvailableBleDevice(timeout: Int) { response, (Error)? in
            //code
        }
 ```       
- respose sẽ trả ra device BLE mà nó vừa scan được
        
### B2: Add thiết bị BLE vừa scan được

#### Cách 1:

```
RGCore.shared.device.addMeshDevice(device: RGBMeshScannedDevice, toHub: RGBDevice, didUpdateProgessing: ((Int) -> ())?, completion: RGBCompletionObject<Void?>?)
```
Trong đó:
- device: truyền vào respone <device vừa scan được>
- toHub: truyền vào device hub dùng để add BLE
- didUpdateProgressing: sẽ trả completedPercent hiển thị tiến trình % add thiết bị BLE
- completion: check lỗi

#### Cách 2:

##### B1: Thêm RGBMeshDelegate vào class

Vd: 
```
extension AddDeviceViewController: RGBMeshDelegate {...
```

#### B2:

```
RGCore.shared.device.meshDelegate = self
```
##### B3:

```
RGCore.shared.device.addMeshDevice(device: RGBMeshScannedDevice, toHub: RGBDevice, didUpdateProgessing: ((Int) -> ())?, completion: RGBCompletionObject<Void?>?)
```

Trong đó:

- device: truyền vào respone <device vừa scan được>
- toHub: truyền vào device hub dùng để add BLE
- didUpdateProgressing: <truyền vào nil>
- completion: <truyền vào nil>

##### B4: Add protocol 

```
    func didProvisioningSuccess(setDeviceInfoHandler: ((String?, String?) -> ())?) {
        code
    }
    
    func didUpdateProgessing(percent: Int) {
        code
    }
    
    func didFinishAddMeshDevice(response: RogoCore.RGBDevice?, error: (Error)?) {
        code
    }
```
Trong đó:

- setDeviceInfoHandler: truyền vào 2 String tương ứng là <tên thiết bị> và <uuid của group> muốn add thiết bị vào
- didUpdateProgessing: percent hiển thị <phần trăm> tiến trình khi add device, ở percent là <48%> đẩy lên UI add nhóm phòng cho thiết bị
- didFinishAddMeshDevice: trả ra <RGBDevice> khi hoàn thành việc add thiết bị

### Dừng scan thiết bị BLE
```
RGCore.shared.device.stopScanBleDevice()
```
### Trường hợp khi thêm thiết bị là .MOTOR_CONTROLLER

Trong trường hợp thiết bị được quét ra có kiểu là 

```
device.productType?.productCategoryType == .MOTOR_CONTROLLER
```
Trong đó:
- nếu muốn add device có loại là rèm thì trước khi add truyền device.productType = .Motor_Curtain
- còn nếy muốn add device có loại là cổng thì truyền device.productType = .Motor_Gate
sau đó gọi hàm addDevice và truyền device đã được gán productType vào
