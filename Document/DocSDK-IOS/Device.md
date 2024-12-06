

# Device

##### import RogoCore

### Lấy ra tất cả thiết bị bên trong location
```
RGCore.shared.user.selectedLocation?.allDevicesInLocation
```
- Lấy được toàn bộ các device bên trong địa điểm đã chọn

### Lấy danh sách thiết bị theo groupID

###### Vd: listDevice = RGCore.shared.user.selectedLocation?.allDevicesInLocation.filter {$0.groupID == selectedGroup.uuid}

- Filter danh sách thiết bị và chỉ hiển thị các thiết bị có bên trong group đã chọn

### Phân loại thiết bị theo kiểu kết nối

###### Vd: 
```
for device in listDevice {
if device.productType == .BM_DoorSensor or == .Zigbee_Plug or == .IR_AirCondition_Remote }
```
- BM: các thiết bị Bluetooth Mesh
- Zigbee: các thiết bị Zigbee
- IR: các thiết bị điều khiển IR như Điều hoà, quạt, TV

### Phân loại thiết bị theo loại thiết bị

###### Vd: Loại thiết bị là ổ cắm
```
for device in listDevice {
if device.productType?.productCategoryType == .PLUG
```
- Tương tự vs các thiết bị đèn, công tắc,...

#### Cập nhật tên của thiết bị
```
RGCore.shared.device.updateDevice(deviceId: String, label: String?, elementLabels: [String: String]?, completion: RGBCompletionObject<RGBDevice?>?)
```
Trong đó:
- deviceId: truyền vào uuid của device được chọn để đổi tên
- label: truyền vào tên mới cho thiết bị
- elementLabels: đối với những thiết bị có nhiều elements VD: Công tắc 4 nút, ta có thể tiến hành đặt tên cho từng nút, String phía bên trái truyền vào elementId bên phải truyền vào tên muốn đặt, trong trường hợp không muốn đặt tên cho các element trong device ta có thể truyền nil vào đây
- completion: check lỗi

###### Vd:
```
 RGCore.shared.device.updateDevice(device.uuid, label: "newName", elementLabels: nil) { response, error in
            if error == nil {
            //Thành công
            } else {
            //Thất bại
}
```
- respone sẽ trả ra device có tên mới

### Xoá thiết bị
```
RGCore.shared.device.deleteDeviceWith(deviceUUID: String, completion: RGBCompletionObject<RGBDevice?>?)
```
Trong đó:
- deviceUUID: truyền vào uuid của device muốn xoá
- completion: check lỗi

### Cập nhật nhóm cho thiết bị
```
RGCore.shared.device.setGroupForDeviceWith(deviceId: String, groupId: String, completion: RGBCompletionObject<RGBDevice?>?)
```
Trong đó:

- deviceId: truyền vào uuid của device muốn cập nhật nhóm
- groupId: truyền vào uuid của group (Vd: groupId = group?.uuid)
- completion: check lỗi

### Thêm thiết bị trong nhóm ảo
```
RGCore.shared.group.updateGroupMemberElement(elementIds: [Int], ofDeviceWith: String, toGroupdWith: String, observer: AnyObject?, completion: RGBCompletionObject<RGBGroupMember?>?)
```
Trong đó: 
- elementIds: là id của element <Vd: trong 1 công tắc 4 nút, ngoài deviceId của công tắc, ta còn có 4 elementId của 4 nút>
- ofDeviceWith: truyền vào uuid của device
- toGroupdWith: truyền vào id nhóm ảo muốn add element
- observer: ***self***
- completion: check lỗi

### Xoá thiết bị trong nhóm ảo
```
RGCore.shared.group.removeGroupMember(deviceWithUUID: String, fromGroupWith: String, observer: AnyObject?, completion: RGBCompletionObject<RGBGroupMember?>?)
```
Trong đó: 
- deviceWithUUID: truyền vào uuid của device
- fromGroupWith: truyền vào uuid của nhóm ảo
- observer: ***self***
- completion: check lỗi


