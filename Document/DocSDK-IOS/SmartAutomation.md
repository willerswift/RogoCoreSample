
# Automation

##### import RogoCore

### Lấy list Automation hiện có bên trong Location
```
    let listAutomation = RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .automation})
```
### Phân loại hiển thị automation

##### Automation được phân thành 4 loại

- Công tắc cầu thang
```
let listStaỉrSwitch = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_STAIR_SWITCH.rawValue})
```
- Thông báo
```
let listNotifications = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_NOTIFICATION.rawValue})
```
- Đảo ngược trạng thái
```
let listSelfReverse = listAutomation.filter({$0.subType == RGBSmartAutomationType.TYPE_SELF_REVERSE.rawValue})
```
- Nâng cao
```
let listOther = Array(Set(smarts).subtracting(listNotifications + listStairSwitch + listSelfReverse))
```

### Thêm Automation

### Thêm automation theo tính năng sử dụng

### 1: Loại automation Công tắc cầu thang

#### Các hàm sử dụng khi tạo automation Công tắc cầu thang:

##### Hàm lấy ra list thiết bị hỗ trợ loại automation công tắc cầu thang:

```
RGCore.shared.automation.getListDevicesSupport(animationType: RGBAutomationEventType, from: [RGBDevice])
```
Trong đó:
- animationType: .StairSwitch ( chọn type công tắc cầu thang ), .Notification (thông báo - thông báo khi có sự thay đổi), .SelfReverse (đảo ngược trạng thái - đảo ngược trạng thái hiện tại của công tắc ổ cắm), .Advance (nâng cao - tạo tự động hoá tuỳ chỉnh)

- from: lấy ra những RGBDevice có uuid không trùng devId của RGBSmartTrigger

##### Hàm tạo smart automation Công tắc cầu thang:

```
RGCore.shared.smart.addSmartAutomation(smartTitle: String?,
                                       automationType: RGBSmartAutomationType,
                                       trigger: [RGBSmartTrigger],
                                       commands: [RGBSmartCmd],
                                       initSmartCompletionHandler: RGBCompletionObject<RGBSmart?>?,
                                       addTriggerCompletionHandler: RGBCompletionObject<RGBSmartTrigger?>?,
                                       addCommandCompletionHandler: ((Int, RGBSmartCmd?, (Error)?) -> Void)?,
                                       completion: RGBCompletionObject<RGBSmart?>?
```
Trong đó:

- smartTitle: tên Smart
- automationType: .StairSwitch
- trigger: Đối với loại công tắc cầu thang sẽ truyền vào 2 trigger
- 3 closure còn lại truyền nil

Vd: Tạo 1 trigger Công tắc cầu thang
```
let trigger = RGBSmartTrigger(automationEventType: .StairSwitch,
                             triggerCmdValues: [],
                             triggerElementId: elementId,
                             deviceId: deviceId,
                             locationId: locationId,
                             smartId: nil,
                             triggerType: .OWNER)
```


### 2: Loại automation Thông báo

```
let trigger = RGBSmartTrigger(automationEventType: .Notification,
                             triggerCmdValues: [eventType],
                             triggerElementId: elementId,
                             deviceId: deviceId,
                             timeJob: timeJob,
                             timeConfig: timeConfig,
                             triggerType: .OWNER)
```
Trong đó:

- triggerCmdValues: type RGBSmartTriggerEventType. là sự kiện vd như bấm 1 lần <.BTN_PRESS_SINGLE>, bấm 2 lần <.BTN_PRESS_DOUBLE> ...
- timeJob: truyền vào startTime và endTime, là thời gian hiệu lực của automation này
- timeConfig: Type timeConfig của .Notification là loại .MIN_TIME<thời gian tối thiểu giữa các lần thông báo>  còn của selfReverse là .WAITTING_TIME<set thời gian đảo ngược trạng thái của thiết bị sau 1 khoảng thời gian được cài đặt>, tất cả các loại còn lại là .REVERSE_TIME<giữ trạng thái của thiết bị trong khoảng thời gian được set> 

Sau đó gọi hàm addSmartAutomation tương tự

### 3: Loại automation Đảo ngược trạng thái

Loại automation đảo ngược trạng thái cũng tạo trigger tương tự như thông báo khác ở type của timeConfig là WAITTING_TIME, sau đó cũng thực hiện việc gọi hàm addSmartAutomation tương tự

### 4: Loại automation Nâng cao

Type của automationEventType trong trigger nâng cao
```
automationEventType: .StateChange
```
Phần automation nâng cao cũng tương tự như các phần còn lại vẫn phải tạo trigger, tạo Cmd rồi thả vào hàm addSmartAutomation, trong phần chủ yếu cần chú ý có các loại time:

Trong trường hợp automation Nâng cao: 

```
let type = trigger.triggerCmdValues.contains.NO_MOTION) ? RGBSmartAutomationType.TYPE_NOMOTION_DETECTED_SIMULATE: RGBSmartAutomationType. TYPE_MIX_OR
RCore. shared. smart.addSmartAutomation(smartTitle: smartTitle,
automationType: type, trigger: trigger,
commands: 1stCommands) { response, error in...
```

Trong đó:

- Trong hàm addSmartAutomation thì RGBSmartAutomationType của automation Nâng cao : .TYPE_MIX_OR, chỉ trong trường hợp trigger có value là không phát hiện truyển động thì RGBSmartAutomationType: .TYPE_NOMOTION_DETECTED_SIMULATE

#### Phần set thời gian trong trigger

1. timeJob: Khoảng thời gian hoạt động
2. timeConfig: Type của nó là REVERSE_TIME<giữ trạng thái của thiết bị trong khoảng thời gian được set> 

#### Phần set thời gian trong Cmd

##### Bên trong RGBSmartCmd:

```
                            RGBSmartCmd(deviceId: String,
                                        elementIds: [String],
                                        cmdValue: RGBSmartCmdValue?)
```
Trong đó:

- Ngoài việc truyền vào deviceId và elementIds thì ta còn cần truyền vào cả RGBSmartCmdValue:

```
                            RGBSmartCmdValue(cmdType: RGBSmartCmdType,
                                             delay: Int?,
                                             reversing: Int?)
```

Trong đó: 

- cmdType: Vd: RGBSmartCmdValue(cmdType: .onOff(isOn: true))

3. delay: Phần time delay này có trong bất kì Cmd nào, dùng để set thời gian trễ là bao lâu khi thực thi Cmd này
4. reversing: Là thời gian đảo nguợc trạng thái, Vd: khi bật 1 công tắc thì trong khoảng thời gian cài đặt reversing thì công tắc sẽ đảo ngược thành bật

#### Một số hàm có thể sử dụng

- Lấy ra được list thiết bị hỗ trợ cho loại automation mà người dùng chọn

```
RGCore.shared.automation.getListDevicesSupport(animationType: RGBAutomationType, from: [RGBDevice])
```
Trong đó:
- animationType: .StairSwitch ( chọn type công tắc cầu thang ), .Notification (thông báo - thông báo khi có sự thay đổi), .SelfReverse (đảo ngược trạng thái - đảo ngược trạng thái hiện tại của công tắc ổ cắm), .Advance (nâng cao - tạo tự động hoá tuỳ chỉnh)

- from: lấy ra những RGBDevice có uuid không trùng devId của RGBSmartTrigger

###### Vd:
```
let secondTrigger = viewModel.smart?.triggers != nil && viewModel.smart!.triggers!.count > 1 ? viewModel.smart!.triggers![1] : nil
let lstDevicesSupport = RGCore.shared.automation.getListDevicesSupport(animationType: .StairSwitch,
                                                                               from: RGUIDataManager.shared.currentLstDevices).filter({$0.uuid != secondTrigger?.devID})

```

- Lấy ra list lệnh hỗ trợ loại Automation
```
RGCore.shared.automation.getListTriggerCmdValueTypesSupportOf(device: RGBDevice, automationType: RGBAutomationEventType, smartSubType: RGBSmartAutomationType?)

```
-
Trong đó:
- device: truyền vào device
- automationType: truyền vào loại automation muốn sử dụng (Vd: .SelfReverse)
- smartSubType: truyền vào kiểu smart automation (Vd: RGBSmartAutomationType.TYPE_SELF_REVERSE)

Vd: RGBAutomationEventType trong automation .SelfReverse có .StateChange và .SelfReverse
```
    private func getListAutomationType() -> [RGBAutomationEventType] {
        var lstType: [RGBAutomationEventType] = []
        switch automationType {
        case .StairSwitch:
            lstType = [.StairSwitch]
        case .Notification:
            lstType = [.Notification]
        case .Advance:
            lstType = [.StateChange, .DoorState, .MotionEvent, .SwitchScene, .LuxEvent, .DoorLock]
        case .SelfReverse:
            lstType = [.StateChange, .SelfReverse]
        }
        return lstType
    }
```

### Lấy Id của device và lấy Id của element trong 1 RGBSmart

```
smart.cmds?.first.targetID
```
Trong đó:

- smart chứa 1 list cmd. ví dụ trên lấy ra id của device trong cmd đầu tiên của list

### lấy ra element id của 1 RGBSmart

```
smart.cmds?.first?.cmds
```
Trong đó:

- cmds: [String: RGBSmartCmdValue]?, tương ứng mỗi 1 element sẽ có 1 cmd đi kèm

### Update trigger cho automation

```
RGCore.shared.automation.updateSmartTrigger(toSmart: RGBSmart, automationType: RGBAutomationEventType, triggers: [RGBSmartTrigger], completion: RGBCompletionObject<RGBSmart?>?)
```

Trong đó:
- toSmart: truyền vào smart Automation
- automationType: truyền vào kiểu automation người dùng chọn
- triggers: smart.trigger
- completion: trả ra 1 giá trị RGBSmart, check lỗi

### Update Smart Cmd

```
                RGCore.shared.smart.updateSmartCmd(with: RGBSmart,
                                                   smartCmd: RGBSmartCmd,
                                                   completion: RGBCompletionObject<RGBSmartCmd?>)
``` 

### Sửa tên Automation
```
RGCore.shared.smart.updateSmartTitle(withSmartId: String, label: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- withSmartId: uuid của Smart Automation muốn đổi tên
- label: điền tên mới của Automation
- completion: response trả ra ***RGBSmart*** chính là Automation sau khi được đổi tên, check lỗi

### Xoá Automation
```
RGCore.shared.smart.deleteSmart(uuid: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó: 
- uuid: uuid của Smart Automation muốn xoá
- completion: check lỗi

