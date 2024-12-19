
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
- .LIST_SMART_UPDATED: có sự thay đổi về danh sách smart
- .CHANGE_SELECTED_LOCATION: có sự thay đổi về location được chọn
- .LIST_SCENARIO_UPDATED: có sự thay đổi về danh sách các kịch bản
- .LIST_SMART_CMD_UPDATED: có sự thay đổi về lệnh của smart
- .SCHEDULE_SMART_UPDATED: có sự thay đổi về lập lịch trong smart
- .LIST_SMART_TRIGGER_UPDATED: có sự thay đổi về trigger của smart

