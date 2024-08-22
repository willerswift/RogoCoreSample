

# Add Remote AC

##### import RogoCore

#### Các hãng điều khiển AC được hỗ trợ

```
    let listACManufacture: [RGBManufacturer] = [.DAIKIN,
                                                .CASPER,
                                                .PANASONIC,
                                                .SAMSUNG,
                                                .MITSUBISHI,
                                                .TOSHIBA,
                                                .MIDEA,
                                                .GREE,
                                                .LG,
                                                .SHARP,
                                                .HITACHI,
                                                .HAIER,
                                                .CARRIER,
                                                .CORONA,
                                                .FUJITSU,
                                                .VESTEL]
```

Có thể sử dụng: lstManufacturers = RGBManufacturer.getListIrAirConditionerManufacturers() để lấy ra danh sách tất cả các hãng điều hoà

### Lấy ra danh sách lệnh của hãng điều hoà được chọn

```
            RGCore.shared.device.getListIrRemotesInfoOf(manufacturer: RGBManufacturer,
                                                        deviceType: RGBProductCategoryType,
                                                        completion: RGBCompletionObject<[RGBIrRemoteInfo]?>)

```
Trong đó:

- manufacturer: truyền vào 1 trong những manufacturer trong listACManufacture
- deviceType: .AC
- completion: trả ra 1 list có kiểu [RGBIrRemoteInfo] 

### Lấy ra list lệnh điều khiển
```
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: RGBManufacturer,
                                                          deviceType: RGBProductCategoryType,
                                                          remoteId: Int,
                                                          completion: RGBCompletionObject<[RGBIrRemoteCmdZipData]?)
```
Trong đó:

- manufacturer: truyền vào 1 trong những manufacturer trong listACManufacture
- deviceType: .AC
- remoteId: truyền vào rid của 1 phần từ remoteInfo trong danh sách [RGBIrRemoteInfo]
Vd:

```
            guard let rid = self.remoteInfo?.rid else, let selecManufacture = self.selectedManufactureType {
                return
            }
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: selecManufacture,
                                                          deviceType: .AC,
                                                          remoteId: rid) { response, error in
                if error == nil {
                    guard let lstCmds = response else {
                        return
                    }
                    self.remoteInfo?.remoteCmdData = lstCmds 
                }
            }

```
Sau khi response trả ra [RGBIrRemoteCmdZipData] thêm nó vào remoteCmdData của remoteInfo

### Điều khiển thử mã điều hoà

```
            RGCore.shared.device.sendVerifyIrAcRemoteCommand(hub: RGBDevice,
                                                             isSetPowerOn: Bool?,
                                                             mode: RGBIrAcModeType?,
                                                             temperature: Int?,
                                                             fanSpeed: RGBIrAcFanType?,
                                                             remoteInfo: RGBIrRemoteInfo)
```
Trong đó:

- hub: truyền vào device hub
- isSetPowerOn: true là điều hoà bật , false: là tắt
- mode: truyền vào mode điều khiển
- fanSpeed: truyền vào mode quạt
- remoteInfo: truyền vào remoteInfo ở hàm bên trên
Vd:
```
        mode = .AC_MODE_AUTO
        fanSpeed = .FAN_SPEED_LOW
```

### Add remote AC

```
                RGCore.shared.device.addIrRemote(protocolType: RGBIrProtocolCtlType,
                                                 remoteInfo: RGBIrRemoteInfo,
                                                 manufacturer: RGBManufacturer,
                                                 label: String,
                                                 productType: RGBProductType,
                                                 group: RGBGroup?,
                                                 toHub: RGBDevice,
                                                 completion: RGBCompletionObject<RGBDevice?>?)
```
Trong đó:

-  protocolType: Mã điều khiển điều hoà gồm có 2 loại mã đó là mã Raw và mã Protocol

Vd: 
```
            irRemoteInfo.protocolCtlType
            
            raw: .RGIrRawZip
            protocol: .RGIrPrtcAc
            
            Riêng đối với trường hợp mã Protocol trước khi gọi addIrRemote ta làm thêm bước truyền vào nhiệt độ thấp nhất nhiệt độ cao nhất và các mode điều hoà cũng như quạt:
            
                var minTemp: Int = 16
                var maxTemp: Int = 30
                let listAcModes = RGBIrAcModeType.allCases.filter{$0.rawValue >= 0}
                let listAcFanModes = RGBIrAcFanType.allCases.filter{$0.rawValue >= 0}
            
                remoteInfo.setValueInfo(tempRange: [minTemp, maxTemp],
                                          acModes: listAcModes,
                                          availableFanValues: listAcFanModes,
                                          tempAllowInModes: listAcModes,
                                          fanAllowInModes: listAcModes)
}
```
Trong đó:

- remoteInfo: truyền vào remoteInfo vừa chọn để điều khiển thử
- manufacturer: truyền vào hãng điều hoà
- label: tên điều khiển điều hoà
- productType: .IR_AirCondition_Remote
- group: truyền vào nhóm phòng muốn thêm điều khiển điều hoà vào
- toHub: truyền vào thiết bị hub
