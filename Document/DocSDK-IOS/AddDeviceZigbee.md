## Rogo-SDK-IOS

#AddDeviceZigbee

import RogoCore

B1: Scan device Zigbee

RGCore.shared.device.startScanZigbeeDevice(deviceType: <#T##RGBProductType#>, gateWay: <#T##RGBDevice#>, timeout: <#T##Int#>, completion: <#T##RGBCompletionObject<[RGBMeshScannedDevice]?>?##RGBCompletionObject<[RGBMeshScannedDevice]?>?##(_ response: [RGBMeshScannedDevice]?, (Error)?) -> Void#>)

<Scan các thiết bị Zigbee khả dụng>

Trong đó:
-deviceType: lựa chọn kiểu thiết bị Zigbee muốn add
<Vd: .Zigbee_Plug: ổ cắm, .Zigbee_Switch: công tắc, .Zigbee_Motor: động cơ rèm cửa,...>
-gateWay:
-timeout: set thời gian timeout nếu scan không thành công Vd: 300 -> 300 giây
-completion: check lỗi

B2:

#Dừng scan thiết bị Zigbee

RGCore.shared.device.stopScanZigbeeDevice(gateWay: <#T##RGBDevice#>)

Trong đó:
-gateWay: truyền vào device USBZigbee được chọn để add

