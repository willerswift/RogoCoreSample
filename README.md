# RogoCoreSample
Example code for RogoCore SDK

### Cách 1: Sử dụng CocoaPods

#### Các bước cài file RogoCore vào project sử dụng cocoapods

B1: Để tích hợp RogoCore vào dự án Xcode bằng CocoaPods, thêm nó vào Podfile

pod 'RogoCore'

B2: Thêm module RogoCore vào AppDelegate

B3: Trong hàm application(_:didFinishLaunchingWithOptions:)

Thêm vào:

        RGCore.shared.config(appKey: String,
                             appSecret: String) { response, error in
            guard response == true, error == nil else {
                return
            }
        }
B4: Mở file Podfile sau đó dán đoạn code này vào cuối cùng của file Pod sau đó Pod install lại
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

- Kéo thả trực tiếp file RogoCore vào project

Bên trong forder SDK sẽ có 3 SDK, trong đó: (hiện tại cả 3 file đã được hợp lại thành ***RogoCore.xcframework*** )
- iphone : SDK dành cho build trên máy thật
- sim-arm64 : SDK dành cho build máy ảo sử dụng chip Apple Silicon
- sim-x86_64: SDK dành cho build máy ảo sử dụng chip Intel

![1](https://github.com/willerswift/RogoCoreSample/assets/116701315/cb5f26d6-09f9-4d2e-a97e-c0ee03d7d561)

#### Cách bước thực hiện:

- B1: Chọn file ***RogoCore.xcframework*** 

- B2: Mở project muốn sử dụng SDK, sau đó kéo trực tiếp file SDK đã chọn thả vào project

![2](https://github.com/willerswift/RogoCoreSample/assets/116701315/7cd578c5-4d5f-48e2-b72c-93b2a388ed23)

- B3: Chọn như hình, rồi bấm Finish

![3](https://github.com/willerswift/RogoCoreSample/assets/116701315/0aacd863-ab6b-41aa-977e-614925bdec98)

- B4: Vào mục ***General*** của project, tìm ***Frameworks, Libraries, and Embedded Content***, sau đó chọn ***Embed & Sign*** cho ***RogoCore.framework***

![4](https://github.com/willerswift/RogoCoreSample/assets/116701315/3c98eae3-10eb-4f15-9cfb-c89b5f6f5d2e)



