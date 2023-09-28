
# NotificationEvent

##### import RogoCore

### Sử dụng Notification

###### Vd vể trường hợp sử dụng NotificationEvent:

- Vd trong trường hợp ta thay đổi listDevice:
```
RGBNotificationEvent.addObserverNotification(event: .REFRESH_DEVICE_LIST, observer: self, selector: #selector(self.prepareData))
```
- .REFRESH_DEVICE_LIST : có sự thay đổi danh sách thiết bị
- .LOCATION_UPDATED: có sự thay đổi về Location
- .GROUP_UPDATED: có sự thay đổi nhóm
- ...
