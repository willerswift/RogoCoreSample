

# AddDeviceZigbee

import RogoCore

### Scan device Zigbee
```
RGCore.shared.device.startScanZigbeeDevice(deviceType: RGBProductType, gateWay: RGBDevice, timeout: Int, completion: RGBCompletionObject<[RGBMeshScannedDevice]?>?)
```
- Scan các thiết bị Zigbee khả dụng

Trong đó:
- deviceType: lựa chọn kiểu thiết bị Zigbee muốn add
- gateWay: truyền vào device USBZigbee được chọn để add
- timeout: set thời gian timeout nếu scan không thành công Vd: 300 -> 300 giây
- completion: check lỗi
###### Vd: .Zigbee_Plug: ổ cắm, .Zigbee_Switch: công tắc, .Zigbee_Motor: động cơ rèm cửa,...

### Add device Zigbee vừa scan được
```
RGCore.shared.device.addZigbeeDevice(device: RGBMeshScannedDevice, toHub: RGBDevice, didUpdateProgessing: ((Int) -> ())?, completion: RGBCompletionObject<Void?>?)
```

#### Dừng scan thiết bị Zigbee
```
RGCore.shared.device.stopScanZigbeeDevice(gateWay: RGBDevice)
```
Trong đó:
- gateWay: truyền vào device USBZigbee được chọn để add
