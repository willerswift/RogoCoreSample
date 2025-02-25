

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

Bước này check xem mã remoteInfo hiện tại nếu là kiểu raw thì cần gọi hàm get còn nếu là mã protocol thì không cần
Trong khâu này: loại mã raw sẽ được lấy từ trên cloud về còn mã protocol được lấy trực tiếp từ thiết bị qua
```
            if self.remoteInfo?.protocolCtlType == .RGIrRawZip {
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: RGBManufacturer,
                                                          deviceType: RGBProductCategoryType,
                                                          remoteId: Int,
                                                          completion: RGBCompletionObject<[RGBIrRemoteCmdZipData]?)
                                                          ...
            }
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

### Phát hiện điều khiển điều hoà

Sau khi gọi hàm này, hướng điều khiển điều hoà vào thiết bị IR rồi bấm điều khiển để thiết bị IR tiến hành phát hiện loại điều khiển điều hoà

```
        RGCore.shared.device.setIRDetectModeFor(deviceType: RGBProductCategoryType,
                                                hub: RGBDevice,
                                                observer: AnyObject?,
                                                isEnable: Bool,
                                                timeout: Int?,
                                                completion: (_ response: RGBIrRemoteInfo?, (any Error)?) -> Void)
```
Trong đó:

- deviceType: truyền vào loại thiết bị Vd: .AC
- hub: truyền vào thiết bị IR đang sử dụng để phát hiện lệnh điều khiển
- observer: self
- isEnable: true
- timeout: set thời gian timeOut khi gọi lệnh này Vd: 5 (5 giây)
- completion: response trả ra RGBIrRemoteInfo?, ta có thể lấy ra được tên hãng điều hoà phát hiện ra bằng cách
```
               let irAcProtocol = res.acProtocol
               let manufacture = RGBManufacturer.getManufacturerBy(irProtocol: irAcProtocol)
               // manufacture chính là hãng điều hoà mà thiết bị IR vừa phát hiện được
```
Sau đó có thể gọi .addIrRemote để thêm điều khiển vừa phát hiện được
