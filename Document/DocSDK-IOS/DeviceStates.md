

# DeviceStates

##### import RogoCore

### Lấy trạng thái của thiết bị

B1: 

#### Trường hợp lấy state của 1 thiết bị :

```
RGCore.shared.device.subscribeStateChangeOfDeviceWith(deviceUUID: String, observer: AnyObject?, statusChangedHandler: RGBCompletionObject<RGBDeviceState?>?)
```

- Truyền vào 1 id của device dể đăng ký lấy trạng thái của device đó

#### Trường hợp lấy state của 1 danh sách thiết bị :
```
RGCore.shared.device.subscribeStateChangeOf(devices: [RGBDevice], observer: AnyObject?, statusChangedHandler: RGBCompletionObject<RGBDeviceState?>?)
```
- Truyền vào 1 danh sách các device dể đăng ký lấy trạng thái của các device đó

B2: 

- Lấy trạng thái của của thiết bị mỗi khi trạng thái của thiết bị có sự thay đổi
```
RGCore.shared.device.requestStateOf(device: RGBDevice)
```

Vd: 
```
RGCore.shared.device.subscribeStateChangeOf(device: device, observer: self) {[weak self] res , error in
            guard let self = self,
                  res != nil,
                  res!.deviceUUID?.uppercased() == device.uuid?.uppercased(),
                  let states = res?.stateValues,
                  states.count > 0 else {
                      return
                  }

            self.updateElementWith(states: states)
            
            self.getLog()
        }
```
- Trong đó sẽ trả về res viết tắt của respone sẽ lấy được trạng thái của thiết bị ở đòng 
<let states = res?.stateValues>

B3: Ép kiểu để hiển thị
Vd:
```
    func updateDeviceState(states: [RGBDeviceElementState], cell: ListLightCell ) {
        for state in states {
            if let stateValue = state.commandValues.first(where: {$0.type == .ONOFF}) as? RGBValueOnOff {
                
                cell.swOnOff.isOn = stateValue.on == 1
            }
        }
    }
```
- Trong đó:
 
RGBValueOnOff : bật / tắt (biến: on)
RGBValueBrightness : độ sáng (biến: b)
RGBValueKelvin : độ ấm (biến: k)
RGBValueBrightnessKelvin: cả độ sáng và độ ấm
RGBValueOpenClose : đóng / mở

### Một số kiểu trạng thái thường xuyên sử dụng

            .BATTERY: trạng thái pin
            .BRIGHTNESS_KELVIN: độ sáng, tông màu
            .EVENT_DOOR: sự kiện đóng mở <cảm biến cửa>
            .OPEN_CLOSE: đóng mở <rèm cửa>
            .ONOFF: bật tắt
            .COLOR_HSV: màu đèn

### Đây là 1 ví dụ lấy được trạng thái đóng mở cửa của cảm biến cửa sau khi lấy được state đóng/mở:
###### Vd:
```
for state in states {
            
            if let currentState = state.commandValues.first(where: {$0.type == .EVENT_DOOR}) as? RGBValueOpenClose {
                if currentState.open == 1 {
                //Mở
                } else {
                //Đóng
                }
            }
        }
```
### Còn đây là ví dụ cho lấy được trạng thái bật/tắt và tông màu/độ sáng của đèn:
```
        for state in states {
            if let stateValue = state.commandValues.first(where: {$0.type == .ONOFF}) as? RGBValueOnOff {
                swOnOffState.isOn = stateValue.on == 1
            }
            if let stateBrightnessKelvin = state.commandValues.first(where: {$0.type == .BRIGHTNESS_KELVIN}) as? RGBValueBrightnessKelvin {
                -stateBrightnessKelvin.b 
                <.b là brightness>
                -stateBrightnessKelvin.k 
                <.k là kelvin>
            }
        }
```
### Đối với các thiết bị có log, vd về lấy log thiết bị cảm biến cửa:

        RGCore.shared.device.getSensorLogOf(device: RGBDevice, dayToGetLog: Date, completion: RGBCompletionObject<RGBDeviceLogResponse?>?)

###### Vd:     
```
var date = Date()
        
        date = Calendar.current.date(byAdding: .day, value: 0, to: date)!
        
        RGCore.shared.device.getSensorLogOf(device: RGBDevice,
                                            dayToGetLog: date) { [weak self] response, error in
            
          // Lấy được list log của thiết bị như sau:
           
                let logs = response?.deviceLogParts.flatMap({$0.logs}),
                self.listLogs = logs
                
        }
 ```
Trong đó:
- device: truyền vào thiết bị muốn lấy log
- date: giá trị về thời gian

### Đối với các thiết bị có hỗ trợ khoá cảm ứng:

Được chia làm 2 loại:

1. Đối với các thiết bị sử dụng bản tin setting cũ nhưng chưa update firm bao gồm:

```
        if self.productID == "000128104C0C009B"
            || self.productID == "RDMTBM1301010001"
            || self.productID == "DQMTZB01000102"

```

Trong đó:
- Đối với các thiết bị này sử dụng hàm:

```
RGCore.shared.device.requestStateAndSettingOf(device: device)
```
2. Đối với các thiết bị mới đang được sử dụng thì sử dụng hàm:

```
RGCore.shared.device.requestStateOfDeviceWith(deviceUUID: device.uuid)

```

### Phần setup để hứng trạng thái của khoá cảm ứng

#### Phần này vẫn subcribe trạng thái của các thiết bị có khoá cảm ứng tương tự như các thiết bị khác, có thêm phần lấy trạng thái khoá cảm ứng từ bên trong setting được response trả về 

Vd:
```
    private func setSubscribeDeviceStateChange() {
        
        if device.productID == "000128104C0C009B"
            || device.productID == "RDMTBM1301010001"
            || device.productID == "DQMTZB01000102" {
            RGCore.shared.device.subscribeStateChangeAndSettingsOf(device: device,
                                                                   observer: self,
                                                                   statusChangedHandler: nil) {[weak self] res, error in
                guard let self = self,
                      res != nil,
                      res!.deviceUUID?.uppercased() == self.device.uuid?.uppercased(),
                      let settings = res?.settings,
                      settings.count > 0 else {
                    return
                }
                
                settings.forEach { setting in
                    switch setting.settingType {
                    case .TouchAllow:
                        if let settingValue = (setting.settingValue as? RGBDeviceTouchSetting) {
                            self.deviceSettingLockTouch = settingValue
                        }
                    default:
                        break
                    }
                }
            }
        } else {
            RGCore.shared.device.subscribeStateChangeOf(devices: [device],
                                                        observer: self,
                                                        statusChangedHandler: {[weak self] res, error in
                guard let self = self,
                      res != nil,
                      res!.deviceUUID?.uppercased() == self.device.uuid?.uppercased(),
                let settingLockButton = res?.stateValues.first(where: {$0.commandValues.first(where: {$0.type == .SETTING_LOCK_BUTTON}) != nil}) else {
                    return
                }
                self.deviceSettingLockButton = settingLockButton.commandValues.first(where: {$0.type == .SETTING_LOCK_BUTTON}) as? RGBDeviceSettingLockButton
            })
        }
        
    }
```
