

# Lấy trạng thái của USB Dongle & Hub

import RogoCore

### Lấy trạng thái của Hub

```
RGCore.shared.device.getHubsStatus(hubs: [RGBDevice], observer: AnyObject?, timeout: Int, completion: RGBCompletionObject<RGBNetworkStatusMessage?>?)
```
Trong đó:
- hubs: truyền vào list device Hub
- observer: self
- timeout: set thời gian timeout
- completion: respone lấy được trạng thái device hub trả ra kiểu RGBNetworkStatusMessage?, check lỗi

### Lấy trạng thái của USBDongle

```
RGCore.shared.device.getZigbeeDongleStatus(at: RGBLocation, observer: AnyObject?, timeout: Int, completion: RGBCompletionObject<RGBUsbZigbeeStatus?>?)
```
Trong đó:
- at: truyền location đã chọn và chứa USB Zigbee muốn lấy trạng thái
- observer: self
- timeout: set thời gian timeout
- completion: respone trả ra trạng thái của USBDonggle có kiểu RGBUsbZigbeeStatus?, check lỗi
