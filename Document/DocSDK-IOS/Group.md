## Rogo-SDK-IOS

#Group

import RogoCore

#Lấy ra list group

RGCore.shared.user.selectedLocation?.groups

<Lấy ra toàn bộ group có mặt bên trong location đã chọn, trong đó sẽ có cả group nhóm ảo, do đó có thể filter các group nhóm ảo đi>
Vd: .filter {$0.groupType != .VirtualGroup}   or  .filter {$0.groupType == .Room}
Vd: var listGroup = RGCore.shared.user.selectedLocation?.groups.filter {$0.groupType != .VirtualGroup}

#Thêm group mới

RGCore.shared.group.createGroup(label: <#T##String#>, desc: <#T##String#>, type: <#T##RGBGroupType#>, locationId: <#T##String#>, completion: <#T##((RGBGroup?, (Error)?) -> ())?##((RGBGroup?, (Error)?) -> ())?##(_ info: RGBGroup?, _ error: (Error)?) -> ()#>)

Trong đó:
-label: tên group muốn tạo
-desc: kiểu group muốn tạo (Vd: Phòng khách, phòng ngủ, phòng bếp,...)
-locationId: uuid của location
-type: để phân biệt là loại nhóm ảo hay nhóm phòng, trong type sẽ có 2 thành phần là nhóm phòng và nhóm ảo, tương ứng với ví dụ (Vd: .Room [nhóm phòng], .VirtualGroup [nhóm ảo])
-completion: check lỗi


#Sửa thông tin group

RGCore.shared.group.updateGroup(id: <#T##String#>, label: <#T##String#>, desc: <#T##String#>, completion: <#T##RGBCompletionObject<RGBGroup?>?##RGBCompletionObject<RGBGroup?>?##(_ response: RGBGroup?, (Error)?) -> Void#>)

Trong đó:
-id: uuid của group
-label: tên mới của group
-desc: kiểu của group (Vd: Phòng khách, phòng ngủ, phòng bếp,...)
-completion: check lỗi

#Xoá group

RGCore.shared.group.deletedGroup(id: <#T##String#>, completion: <#T##RGBCompletionObject<Bool>?##RGBCompletionObject<Bool>?##(_ response: Bool, Error?) -> Void#>)

Trong đó:
-id: uuid group
-completion: check lỗi

#Xoá nhóm ảo

RGCore.shared.group.deletedGroup(id: <#T##String#>, completion: <#T##RGBCompletionObject<Bool>?##RGBCompletionObject<Bool>?##(_ response: Bool, Error?) -> Void#>)

<Tương tự như xoá nhóm phòng>
