

# Add Remote TV

##### import RogoCore

#### Các hãng điều khiển TV được hỗ trợ

```
    let listTVManufacture: [RGBManufacturer] = [.SAMSUNG,
                                                .SONY,
                                                .LG,
                                                .PANASONIC,
                                                .TCL,
                                                .TOSHIBA]
```
Có thể sử dụng: listTVManufacture = RGBManufacturer.getListIrTvManufacturers() để lấy ra danh sách tất cả các hãng TV

### Lấy ra danh sách lệnh của hãng TV được chọn

```
            RGCore.shared.device.getListIrRemotesInfoOf(manufacturer: RGBManufacturer,
                                                        deviceType: RGBProductCategoryType,
                                                        completion: RGBCompletionObject<[RGBIrRemoteInfo]?>)

```
Trong đó:

- manufacturer: truyền vào 1 trong những manufacturer trong listTVManufacture
- deviceType: .TV
- completion: trả ra 1 list có kiểu [RGBIrRemoteInfo] 

### Lấy ra list lệnh điều khiển
```
            RGCore.shared.device.getIrRemoteCommandDataOf(manufacturer: RGBManufacturer,
                                                          deviceType: RGBProductCategoryType,
                                                          remoteId: Int,
                                                          completion: RGBCompletionObject<[RGBIrRemoteCmdZipData]?>)
```
Trong đó:

- manufacturer: truyền vào 1 manufacturer được chọn trong listTVManufacture 
- deviceType: .TV
- remoteId: truyền vào rid của 1 phần từ remoteInfo trong danh sách [RGBIrRemoteInfo]
Vd:
```
            rid = remoteInfo.rid
```

Sau khi response trả ra [RGBIrRemoteCmdZipData] thêm nó vào remoteCmdData của remoteInfo

### Điều khiển thử TV
```
        RGCore.shared.device.sendVerifyIrTVCommand(hub: RGBDevice,
                                                   commandValue: RGBIrRemoteCmdType,
                                                   remoteInfo: RGBIrRemoteInfo)
```

Trong đó:

- hub: truyền vào device hub
- commandValue: truyền vào các command có kiểu RGBIrRemoteCmdType: .HOME, .POWER, .UP, .RIGHT, .DOWN, .LEFT, .OK, .MUTE, .MENU, .BACK, .VOL_UP, .VOL_DOWN, .CHANNEL_UP, .CHANNEL_DOWN
- remoteInfo: truyền vào remoteInfo ở hàm bên trên

### Add remote TV

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

- protocolType: .RGIrRawZip
- remoteInfo: truyền vào remoteInfo vừa chọn để điều khiển thử
- manufacturer: truyền vào hãng TV
- label: tên điều khiển TV
- productType: .IR_TV_Remote
- group: truyền vào nhóm phòng muốn thêm điều khiển TV
- toHub: truyền vào thiết bị hub


