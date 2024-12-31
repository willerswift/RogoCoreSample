
# Location

##### import RogoCore

### Lấy list location:
```
RGCore.shared.user.locations
```
- Lấy được toàn bộ locations bên trong tài khoản

Vd:
```
var listLocation: [RGBLocation]

// Khi bạn muốn lấy tên và uuid của 1 location trong danh sách listLoaction, ví dụ lấy tên và uuid của location đầu tiên trong listLocation

let firstLocation = listLocation.first

let name = firstLocation.label

let uuid = firstLocation.uuid

```
// Ngoài ra còn có những trường có thể sử dụng như:

- allDevicesInLocation: tất cả thiết bị bên trong location

- allSmartInLocation: tất cả smart bên trong location

- groups: tất cả nhóm phòng bên trong location

### Chọn location:
```
RGCore.shared.user.setSelectedLocation(locationId: String)
```

- Truyền vào id location mà người dùng chọn

### Thêm location mới:
```
RGCore.shared.user.createLocation(label: String, desc: String, completion: RGBCompletionObject<RGBLocation?>?)
```
Trong đó:
- label: là tên location mới
- desc: là kiểu location (vd: Chung cư, Homestay, Văn phòng,...)
- completion: để check có hoàn thành quá trình location hay không, tác dụng để check không có lỗi hoặc có lỗi thì có thể cho show lên popUp thông báo thành công hoặc thất bại tương ứng

### Sửa thông tin location:
```
RGCore.shared.user.updateLocations(id: String, label: String, desc: String, completion: RGBCompletionObject<RGBLocation?>?)
```
Trong đó:
- id: uuid của location (Vd: location.uuid)
- label: tên location muốn sửa
- desc: kiểu location muốn sửa
- completion: tương tự như phần tạo thêm location, phần này để check xem có lỗi hay không có lỗi

### Xoá location:
```
RGCore.shared.user.deletedLocations(id: String, completion: RGBCompletionObject<Bool>?)
```
Trong đó:
- id: truyền vào uuid của location được chọn để xoá 
- completion: check lỗi

- Nếu error != nil -> xoá thất bại (hiển thị thông báo xoá thất bại) <trong location còn thiết bị sẽ không cho phép xoá location>
