
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

- Tạo smart Automation

```
RGCore.shared.smart.addSmart(with: String, 
                             locationId: String,
                             type: RGBSmartType,
                             subType: RGBSmartSubType,
                             ownerId: String?,
                             completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- with: truyền vào 1 ***String*** là tên của Automation muốn tạo
- locationId: truyền vào ***uuid*** của location
- type: ***.automation***
- subTupe: ***RGBSmartSubType.defaultType***
- ownerId: ***nil***
- completion: response trả ra ***RGBSmart***, check lỗi

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
- Tạo Cmd cho smart Automation
```
RGCore.shared.smart.addSmartCmd(to: RGBSmart,
                                targetId: String,
                                targetElementIds: [String],
                                cmdValue: RGBSmartCmdValue,
                                type: Bool,
                                completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- to: truyền vào Automation muốn tạo lệnh
- targetId: deviceId của thiết bị
- targetElementIds: list ElementId của thiết bị
- cmdValue: truyền vào RGBSmartCmdValue
- completion: trả ra 1 giá trị kiểu RGBSmartCmd, check lỗi

- Kiểu giá trị về thời gian trong automation

Trong đó : .delay (độ trễ), reversing (thời gian đảo ngược trạng thái) - RGBSmartCmdValue 

Vd:
```
var cmdValue: RGBSmartCmdValue
var rTime: Int = 0 (giá trị thời gian đảo ngược)
)

cmdValue.reversing = rTime
```

- Thêm trigger cho automation
```
RGCore.shared.automation.addSmartTrigger(toSmart: RGBSmart, automationType: RGBAutomationEventType, triggers: [RGBSmartTrigger], completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- toSmart: truyền vào smart Automation
- automationType: truyền vào kiểu automation
- triggers: smart.trigger
- completion: trả ra 1 giá trị RGBSmart, check lỗi


- Update trigger cho automation

```
RGCore.shared.automation.updateSmartTrigger(toSmart: RGBSmart, automationType: RGBAutomationEventType, triggers: [RGBSmartTrigger], completion: RGBCompletionObject<RGBSmart?>?)
```

Trong đó:
- toSmart: truyền vào smart Automation
- automationType: truyền vào kiểu automation
- triggers: smart.trigger
- completion: trả ra 1 giá trị RGBSmart, check lỗi

### Xoá Automation
```
RGCore.shared.smart.deleteSmart(uuid: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó: 
- uuid: uuid của Smart Automation muốn xoá
- completion: check lỗi

### Sửa tên Automation
```
RGCore.shared.smart.updateSmartTitle(withSmartId: String, label: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- withSmartId: uuid của Smart Automation muốn đổi tên
- label: điền tên mới của Automation
- completion: response trả ra ***RGBSmart*** chính là Automation sau khi được đổi tên, check lỗi
### 
