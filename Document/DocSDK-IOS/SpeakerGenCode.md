

# Gen code cho Speaker

##### import RogoCore

### Hàm lấy code Speaker
```
        RGCore.shared.device.generateDeviceActiveCode(locationId: String,
                                                      verifyId: String?,
                                                      didGetCodeCompletion: RGBCompletionObject<RGBActiveCode?>?,
                                                      didAddDeviceCompletion: RGBCompletionObject<RGBDevice?>?)
```
                                            
Trong đó:

- locationId: truyền vào locationId hiện tại
- verify: truyền nil
- didGetCodeCompletion: check gen thành công code
- didAddDeviceCompletion: check add device complete
