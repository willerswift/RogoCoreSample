
# Cài đặt thư viện

### Cách 1: Sử dụng *CocoaPods* để lấy SDK về

Các bước cài file *RogoCore* vào project sử dụng *Cocoapods*

#### B1: Để tích hợp *RogoCore* vào dự án Xcode bằng *CocoaPods*, thêm nó vào Podfile

pod 'RogoCore'

#### B2: Sau đó pod install

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



