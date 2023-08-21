## Rogo-SDK-IOS

#Location

import RogoCore

#Lấy list location:

RGCore.shared.user.locations

<Lấy được toàn bộ locations bên trong tài khoản>

#Chọn location:

RGCore.shared.user.setSelectedLocation(location: <#T##RGBLocation#>)

<Truyền vào location mà người dùng chọn>

#Thêm location mới:

RGCore.shared.user.createLocation(label: <#T##String#>, desc: <#T##String#>, completion: <#T##RGBCompletionObject<RGBLocation?>?##RGBCompletionObject<RGBLocation?>?##(_ response: RGBLocation?, Error?) -> Void#>)

Trong đó:
- label: là tên location mới
- desc: là kiểu location (vd: Chung cư, Homestay, Văn phòng,...)
- completion: để check có hoàn thành quá trình location hay không, tác dụng để check không có lỗi hoặc có lỗi thì có thể cho show lên popUp thông báo thành công hoặc thất bại tương ứng

#Sửa thông tin location:

RGCore.shared.user.updateLocations(id: <#T##String#>, label: <#T##String#>, desc: <#T##String#>, completion: <#T##RGBCompletionObject<RGBLocation?>?##RGBCompletionObject<RGBLocation?>?##(_ response: RGBLocation?, (Error)?) -> Void#>)

Trong đó:
-id: uuid của location (Vd: location.uuid)
-label: tên location muốn sửa
-desc: kiểu location muốn sửa
-completion: tương tự như phần tạo thêm location, phần này để check xem có lỗi hay không có lỗi

#Xoá location:

RGCore.shared.user.deletedLocations(id: <#T##String#>, completion: <#T##RGBCompletionObject<Bool>?##RGBCompletionObject<Bool>?##(_ response: Bool, (Error)?) -> Void#>)

Trong đó:
- id: truyền vào uuid của location được chọn để xoá 
- completion: check lỗi

<Nếu bên trong location có device thì khi xoá location sẽ luôn trả về là có lỗi>

