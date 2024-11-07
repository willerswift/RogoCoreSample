
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

![1](https://github.com/user-attachments/assets/cfd4e23b-9ffd-4173-9b88-7f07122c3560)

#### B3: Chọn như hình, rồi bấm Finish

![2](https://github.com/user-attachments/assets/7faf358b-08d5-4484-b22d-94aabdd65a8d)

#### B4: Vào mục General của project, tìm Frameworks, Libraries, and Embedded Content, sau đó chọn Embed & Sign cho RogoCore.framework

![3](https://github.com/user-attachments/assets/eee162e5-5223-493a-875c-8c691510bf35)



