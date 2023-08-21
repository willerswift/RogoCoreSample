

# DeviceStates

import RogoCore

### Lấy trạng thái của thiết bị

B1: 
```
RGCore.shared.device.requestStateOf(device: RGBDevice)
```
- Truyền vào device dể yêu cầu lấy trạng thái của device đó

B2: 
```
RGCore.shared.device.subscribeStateChangeOf(device: RGBDevice, observer: AnyObject?, statusChangedHandler: RGBCompletionObject<RGBDeviceState?>?)
```
- Đăng ký để lấy trạng thái của của thiết bị mỗi khi trạng thái của thiết bị có sự thay đổi

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
