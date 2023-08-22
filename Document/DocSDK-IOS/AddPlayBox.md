

# AddPlayBox

import RogoCore

### Lấy mã kích hoạt

```
RGCore.shared.device.generatePlayboxActiveCode(locationId: String, didGetCodeCompletion: RGBCompletionObject<RGBActiveCode?>?, didAddDeviceCompletion: RGBCompletionObject<Bool?>?)
```
Trong đó: 
- locationId: uuid của location
- didGetCodeCompletion: response trả ra RGBActiveCode?
- didAddDeviceCompletion: check lỗi

