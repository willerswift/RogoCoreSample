## Rogo-SDK-IOS

#AddDeviceBLE

import RogoCore

B1: Scan device BLE

RGCore.shared.device.scanAvailableBleDevice(timeout: <#T##Int#>, completion: <#T##RGBCompletionObject<RGBMeshScannedDevice?>?##RGBCompletionObject<RGBMeshScannedDevice?>?##(_ response: RGBMeshScannedDevice?, (Error)?) -> Void#>)

<Scan các thiết bị BLE khả dụng>

Trong đó:
-timeout: set thời gian timeout Vd: 60 -> 60 giây
-completion: check lỗi

Vd: RGCore.shared.device.scanAvailableBleDevice(timeout: <#T##Int#>) { response, <#(Error)?#> in
            <#code#>
        }
        
<respose sẽ trả ra device BLE mà nó vừa scan được>
        
B2: add thiết bị BLE vừa scan được

RGCore.shared.device.addMeshDevice(device: <#T##RGBMeshScannedDevice#>, toHub: <#T##RGBDevice#>, didUpdateProgessing: <#T##((Int) -> ())?##((Int) -> ())?##(_ completedPercent: Int) -> ()#>, completion: <#T##RGBCompletionObject<Void?>?##RGBCompletionObject<Void?>?##(_ response: Void?, (Error)?) -> Void#>)

Trong đó:
-device: truyền vào respone <device vừa scan được>
-toHub: truyền vào device hub dùng để add BLE
-didUpdateProgressing: sẽ trả completedPercent hiển thị tiến trình % add thiết bị BLE
-completion: check lỗi

#Dừng scan thiết bị BLE

RGCore.shared.device.stopScanBleDevice()

