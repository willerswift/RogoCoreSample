

# Schedule

##### import RogoCore

### Lấy list Schedule hiện có bên trong Location
```
RGCore.shared.user.selectedLocation?.allSmartInLocation.filter({$0.smartType == .schedule})
```
### Tạo Smart thuộc type Schedule
```
RGCore.shared.smart.addSmart(with: String, 
                             locationId: String,
                             type: RGBSmartType,
                             subType: RGBSmartSubType,
                             ownerId: String?,
                             completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- with: truyền vào 1 ***String*** là tên của Schedule muốn tạo
- locationId: truyền vào ***uuid*** của location
- type: ***.schedule***
- subTupe: ***RGBSmartSubType.defaultType***
- ownerId: ***nil***
- completion: response trả ra ***RGBSmart***, check lỗi

### Tạo Smart Schedule
```
RGCore.shared.schedule.addSchedule(toSmart: RGBSmart,
                                   time: Int,
                                   weekdays: [Int],
                                   completion: RGBCompletionObject<RGBSchedule?>?)
                                   
```
Trong đó:
- toSmart: truyền vào smart kiểu ***RGBSmart***  ( chính là ***response*** được trả ra ở trên )
- time: giá trị kiểu ***Int***, định dạng cho ***giờ*** và ***phút*** ( Vd: 3h40p => 3*60 + 40  )
- weekdays: truyền vào 1 mảng ***[Int]***, định dạng cho số ngày trong tuần được chọn ( Vd: từ CN-T2. mỗi thứ sẽ được đánh số tag từ 0-6 <Cn: 0, t2: 1, t3:2, t4: 3, t5: 4, t6: 5, t7: 6> ) Vd: muốn truyền vào t2,t3,CN: [1, 2, 0]
- completion: response trả ra ***RGBSchedule***, check lỗi

### Tạo Cmd cho Smart Schedule
```
RGCore.shared.smart.addSmartCmd(to: RGBSmart,
                                targetId: String,
                                targetElementIds: [String],
                                cmdValue: RGBSmartCmdValue,
                                type: Bool,
                                completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- to: truyền vào Schedule muốn tạo lệnh
- targetId: deviceId của thiết bị
- targetElementIds: list ElementId của thiết bị ( Vd: Công tắc 4 nút sẽ có 4 elementId )
- cmdValue: truyền vào RGBSmartCmdValue
- completion: trả ra 1 giá trị kiểu RGBSmartCmd, check lỗi

### Update, sửa thời gian cho Schedule
```
RGCore.shared.schedule.updateSchedule(schedule: RGBSchedule, completion: RGBCompletionObject<RGBSchedule?>?)
```
Trong đó:

- schedule: init lại giá trị time và weekdays mới vào RGBSchedule rồi gọi hàm update
- completion: res trả ra RGBSchedule đã update, check lỗi

### Update, sửa lệnh cho Schedule
```
 RGCore.shared.smart.updateSmartCmd(with: RGBSmart,
                                    smartCmd: RGBSmartCmd,
                                    completion: RGBCompletionObject<RGBSmartCmd?>?)
```
Trong đó:
- with: truyền vào Smart Schedule muốn cập nhật lệnh
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

### Đổi tên Smart Schedule
```
RGCore.shared.smart.updateSmartTitle(withSmartId: String, label: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó:
- withSmartId: uuid của Smart Schedule muốn đổi tên
- label: điền tên mới của Schedule
- completion: response trả ra ***RGBSmart*** chính là Schedule sau khi được đổi tên, check lỗi

### Xoá Smart Schedule
```
RGCore.shared.smart.deleteSmart(uuid: String, completion: RGBCompletionObject<RGBSmart?>?)
```
Trong đó: 
- uuid: uuid của Smart Schedule muốn xoá
- completion: check lỗi

