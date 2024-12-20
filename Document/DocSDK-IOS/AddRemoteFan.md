

# Add Remote Fan

##### import RogoCore

#### Các hàm sử dụng cho add điều khiển quạt

### Phát hiện lệnh cho điều khiển quạt

Các loại lệnh điều khiển Quạt trong chế độ học lệnh quạt:

        .POWER_SWITCH: Nút nguồn
        .POWER_ON: Nút bật
        .POWER_OFF: Nút tắt
        .MODE: Nút điều chỉnh chế độ
        .FAN_SPEED: Nút tốc độ quạt
        .SWING: Nút đảo gió
        .SLEEP: Nút chế độ ngủ
        .TIMING: Nút hẹn giờ
        Ngoài ra còn 1 số nút tuỳ chỉnh như:
        Nếu trong trường hợp điều khiển quạt có những loại nút nằm ngoài các loại nút kể trên thì có thể sử dụng nút tuỳ chỉnh này
        .NUM_0: Nút 0
        .NUM_1: Nút 1
        .NUM_2: Nút 2
        .NUM_3: Nút 3
        .NUM_4: Nút 4
        .NUM_5: Nút 5

```
RGCore.shared.device.setIRLearningModeFor(deviceType: RGBProductCategoryType, hub: RGBDevice, observer: AnyObject?, isEnable: Bool, timeout: Int, completion: RGBCompletionObject<Any?>?)
```
Trong đó:

- deviceType: .FAN
- hub: truyền vào device IR được chọn làm hub
- observer: self
- isEnable: true
- timeout: set timeout
- completion: check lỗi

Sau khi gọi hàm này hướng điều khiển của bạn vào thiết bị điều khiển hồng ngoại và bấm nút bấm mà bạn muốn học lệnh, sau khi bắt được tín hiệu điều khiển response của hàm này sẽ được trả ra, sau đó gán loại nút tương ứng mà bạn vừ bấm vào cho remoteCmdType của nó Vd:
```
                // Tuỳ thuộc vào loại nút bấm mà bạn chọn mà truyền vào remoteCmdType tương ứng

                response.remoteCmdType = .POWER_SWITCH 

```

sau đó append response đó vào list có type là remoteInfos: [RGBIrRemoteRawInfo], rồi tiếp tục lặp lại công đoạn trên để add các nút còn lại, nếu không còn nút nào muốn add nữa tiến hành add remote

### Add remote Fan

```
RGCore.shared.device.addIrFanRemote(remoteInfos: [RGBIrRemoteRawInfo],
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

