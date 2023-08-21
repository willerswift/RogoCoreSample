# RogoCoreSample
example code for rogo core sdk

### Cách 1: Sử dụng CocoaPods

#### Các bước cài file RogoCore vào project sử dụng cocoapods

B1: Để tích hợp RogoCore vào dự án Xcode bằng CocoaPods, thêm nó vào Podfile

pod 'RogoCore'

B2: Thêm module RogoCore vào AppDelegate

B3: Trong hàm application(_:didFinishLaunchingWithOptions:)

Thêm vào:

        RGCore.shared.config(appKey: "ecde7b0323af44eb890e27c4b5a9d0a8",
                             appSecret: "3e9e598e8a17789e3af931b9b0f8cf6f4670e2a48e38") { response, error in
            guard response == true, error == nil else {
                return
            }
        }

### Cách 2: Sử dụng file SDK

- Kéo thả trực tiếp file RogoCore vào project
