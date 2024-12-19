
# Scenario

##### import RogoCore

### Lấy list Scenario hiện có bên trong Location
```
 RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .scenario})
```
### Tạo Smart thuộc type Scenario
```
RGCore.shared.smart.addSmart(with: String, 
                             locationId: String,
                             type: RGBSmartType,
                             subType: RGBSmartSubType,
                             completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- with: truyền vào 1 ***String*** là tên của Scenario muốn tạo
- locationId: truyền vào ***uuid*** của location
- type: ***.scenario***
- subTupe: ***RGBSmartSubType.scene(sceneType: 0)*** <type mặc định>
- completion: response trả ra ***RGBSmart***, check lỗi

### Thêm lệnh mới cho Scenario
```
RGCore.shared.smart.addSmartCmd(toSmartWithUUID: String,
                                targetId: String,
                                targetElementIds: [String],
                                cmdValue: RGBSmartCmdValue,
                                completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- toSmartWithUUID: truyền vào uuid của Scenario mà bạn muốn tạo lệnh
- targetId: deviceId của thiết bị mà bạn muốn tạo lệnh cho nó
- targetElementIds: list ElementId của thiết bị ( Vd: Công tắc 4 nút sẽ có 4 elementId )
- cmdValue: truyền vào RGBSmartCmdValue
- completion: trả ra 1 giá trị kiểu RGBSmartCmd, check lỗi

### Update, sửa lệnh cho Scenario
```
 RGCore.shared.smart.updateSmartCmd(with: String,
                                    smartCmd: RGBSmartCmd,
                                    completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- with: truyền vào uuid của 1 Smart Scenarỉo muốn cập nhật lệnh
- smartCmd: truyền vào 1 giá trị RGBSmartCmd

###### Vd: Bên trong RGBSmartCmd sẽ có cmdValue: RGBSmartCmdValue chính là lệnh điều khiển cho thiết bị

```
var cmd1: RGBSmartCmdValue?
cmd1?.cmdType = .onOff(isOn: true) 
```
cmd1 chính là 1 RGBSmartCmdValue, có các loại cmd 

.brightnessKelvin(b: Int?, k: Int?): truyền vào giá trị b (độ sáng): 0 -> 1000, k (độ ấm): 2700 -> 6500
.openClose(value: .open): lệnh mở
.openClose(value: .close): lệnh đóng
.onOff(isOn: true): lệnh bật
.onOff(isOn: false): lệnh tắt
...

Vd: 1 RGBSmartCmd

```
let newCmd = RGBSmartCmd(deviceId: String,
                         elementIds: [String],
                         cmdValue: RGBSmartCmdValue?)
```
- completion: trả ra giá trị RGBSmartCmd mới, check lỗi

### Đổi tên cho Smart Scenario

```
RGCore.shared.smart.updateSmartTitle(withSmartId: String,
                                     label: String,
                                     completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- withSmartId: uuid của Smart Scenario muốn đổi tên
- label: điền tên mới của Scenario
- completion: response trả ra ***RGBSmart*** chính là Scenario sau khi được đổi tên, check lỗi

### Xoá Smart Scenario
```
RGCore.shared.smart.deleteSmart(uuid: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó: 
- uuid: uuid của Smart Scenario muốn xoá
- completion: check lỗi

### Kích hoạt Smart Scenario khi bấm vào

RGCore.shared.smart.activeSmart(smart: RGBSmart,
                                completion: RGBCompletionObject<Void?>?)
                                
Trong đó:
- smart: truyền vào Smart Scenario muốn kích hoạt
- completion: check lỗi
