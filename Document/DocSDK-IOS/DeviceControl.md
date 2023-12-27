

# DeviceControl

##### import RogoCore

### Điều khiển bật tắt tất cả thiết bị
```
RGCore.shared.device.sendControlMessage(group: RGBGroup, productType: RGBProductCategoryType, value: RGBCmdValue)
```
Trong đó:
 
- group: group = RGBGroup(elementID: 49152) <dùng để bật/tắt tất cả thiết bị, hoặc 1 loạt các thiết bị cùng loại, ví dụ như trong trường hợp ta muốn tắt tất cả đèn>

- productType: Kiểu thiết bị muốn bật tắt tất cả
        
        .ALL: Tất cả thiết bị
        .LIGHT: Đèn
        .SWITCH: Công tắc
        ...
- value: value = RGBValueOnOff(on: 1) ( bật: 1, tắt: 0 )

### Điều khiển đơn
```
RGCore.shared.device.sendControlMessage(device: RGBDevice, value: RGBCmdValue, elements: [Int])
```
Trong đó:

- device: truyền vào device lẻ muốn điểu khiển
- element: device.elementIDS ( lấy được list element của thiết bị, vd như công tắc 4 nút thì sẽ có 4 element )
- value: có thể là bật/tắt cũng có thể là gửi 1 giá trị về độ sáng/tông màu cho đèn
###### Vd: 
```
let value = RGBValueBrightness(1000) (giá trị của brightness là từ 0 -> 1000)
                RGBValueKelvin(6500) (giá trị của kelvin là từ 2700K -> 6500K)
                RGBHSVColor(color: UIColor) (điều khiển màu)
                RGBValueOnOff(bật tắt)
                RGBValueOpenClose(đóng mở)
```
### Điều khiển nhóm
```
RGCore.shared.device.sendControlMessage(RGBGroup, productType: RGBProductCategoryType, value: RGBCmdValue)
```
Trong đó:
- group: nhóm ảo muốn điều khiển 
###### Vd lấy ra list nhóm ảo : 
```
RGCore.shared.user.selectedLocation?.groups.filter{$0.groupType == .VirtualGroup}
```
