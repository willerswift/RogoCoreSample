

# Add Remote Fan

##### import RogoCore

#### Các hàm sử dụng cho add điều khiển quạt

### Phát hiện lệnh cho điều khiển quạt
```
RGCore.shared.device.setIRRemoteLearningModeFor(deviceType: RGBProductCategoryType, hub: RGBDevice, observer: AnyObject?, isEnable: Bool, timeout: Int, completion: RGBCompletionObject<Any?>?)
```
Trong đó:

- deviceType: .FAN
- hub: truyền vào device IR được chọn làm hub
- observer: self
- isEnable: true
- timeout: set timeout
- completion: check lỗi

Khi bắt được res trả ra append nó vào list có type là [RGBIrFanRemoteInfoMessage] để tiếp tục tiến hành add remote

### Add remote Fan

```
RGCore.shared.device.addIrFanRemote(remoteInfos: [RGBIrFanRemoteInfoMessage],
                                    label: String,
                                    group: RGBGroup?,
                                    toHub: RGBDevice,
                                    completion: RGBCompletionObject<RGBDevice?>?)
```
- remoteInfos: truyền vào list vừa được append ở bên trên
- label: tên điều khiển
- group: truyền vào group để add điều khiển vào nó
- toHub; truyền vào device IR được chọn làm hub
- completion: check lỗi

