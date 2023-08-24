
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
                             ownerId: String?,
                             completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- with: truyền vào 1 ***String*** là tên của Scenario muốn tạo
- locationId: truyền vào ***uuid*** của location
- type: ***.scenario***
- subTupe: ***RGBSmartSubType.defaultType***
- ownerId: ***nil***
- completion: response trả ra ***RGBSmart***, check lỗi

### Thêm lệnh mới cho Scenario
```
RGCore.shared.smart.addSmartCmd(to: RGBSmart,
                                targetId: String,
                                targetElementIds: [String],
                                cmdValue: RGBSmartCmdValue,
                                type: Bool,
                                completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- to: truyền vào Scenario muốn tạo lệnh
- targetId: deviceId của thiết bị
- targetElementIds: list ElementId của thiết bị ( Vd: Công tắc 4 nút sẽ có 4 elementId )
- cmdValue: truyền vào RGBSmartCmdValue
- completion: trả ra 1 giá trị kiểu RGBSmartCmd, check lỗi

### Update, sửa lệnh cho Scenario
```
 RGCore.shared.smart.updateSmartCmd(with: RGBSmart,
                                    smartCmd: RGBSmartCmd,
                                    completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- with: truyền vào Smart Scenarỉo muốn cập nhật lệnh
- smartCmd: truyền vào 1 giá trị RGBSmartCmd

###### Vd:
let newCmd = RGBSmartCmd(deviceId: String,
                         elementIds: [String],
                         cmdValue: RGBSmartCmdValue?)

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
