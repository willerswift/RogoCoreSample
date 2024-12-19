

# AddPlayBox

##### import RogoCore

### Lấy mã kích hoạt

```
RGCore.shared.device.generatePlayboxActiveCode(locationId: String, didGetCodeCompletion: RGBCompletionObject<RGBActiveCode?>?, didAddDeviceCompletion: RGBCompletionObject<Bool?>?)
```
Trong đó: 
- locationId: uuid của location
- didGetCodeCompletion: response trả ra RGBActiveCode?
- didAddDeviceCompletion: check lỗi

Sau khi đã lấy được mã kích hoạt xong hãy nhập mã kích hoạt này trên app Box bạn sẽ có thể thêm thiết bị box vào tài khoản của mình
