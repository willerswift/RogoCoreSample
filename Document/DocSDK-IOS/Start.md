
# Cài đặt thư viện

### Cách 1: Sử dụng *CocoaPods* để lấy SDK về

Các bước cài file *RogoCore* vào project sử dụng *Cocoapods*

#### B1: Để tích hợp *RogoCore* vào dự án Xcode bằng *CocoaPods*, thêm nó vào Podfile

pod 'RogoCore'

#### B2: Thêm module RogoCore vào AppDelegate

#### B3: Trong hàm application(_:didFinishLaunchingWithOptions:)

Thêm vào:

```
    RGCore.shared.config(appKey: String,
                         appSecret: String) { response, error in
        guard response == true, error == nil else {
            return
        }
    }
```

#### B4: Mở file Podfile sau đó dán đoạn code này vào cuối cùng của file Pod sau đó Pod install lại
```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

### Cách 2: Sử dụng file SDK

Kéo thả trực tiếp file *RogoCore* vào project khi được cung cấp file SDK trực tiếp

Bên trong forder SDK sẽ có SDK *RogoCore.xcframework*

Cách bước thực hiện:

#### B1: Chọn file *RogoCore.xcframework*

#### B2: Mở project muốn sử dụng SDK, sau đó kéo trực tiếp file SDK đã chọn thả vào project

/var/folders/wv/g9h6sr117mj6x8ctwc65q6f40000gn/T/TemporaryItems/NSIRD_screencaptureui_Yor09L/Screenshot 2024-11-07 at 11.47.49.png

#### B3: Chọn như hình, rồi bấm Finish

/var/folders/wv/g9h6sr117mj6x8ctwc65q6f40000gn/T/TemporaryItems/NSIRD_screencaptureui_SHYxHT/Screenshot 2024-11-07 at 11.49.45.png


#### B4: Vào mục General của project, tìm Frameworks, Libraries, and Embedded Content, sau đó chọn Embed & Sign cho RogoCore.framework

/var/folders/wv/g9h6sr117mj6x8ctwc65q6f40000gn/T/TemporaryItems/NSIRD_screencaptureui_rIgCnS/Screenshot 2024-11-07 at 11.50.26.png


