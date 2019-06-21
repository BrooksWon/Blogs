# title: "Cocoapods 私有库制作"


## 使用CocoaPods创建私有Spec Repo

> 创建私有库之前, 咱们先来创建一个私有的 Spec Repo, 用来存储咱们的私有库的podspec



1. 进入./cocoapods/repos 查看已经存在的spec repo，这个时候我们能看到一个master文件夹

   ```
   cd ~/.cocoapods/repos
   ls
   ```

2. 在私有git服务器上创建自己的spec repo 

   在自己公司的git服务器上创建：

   ```
   # pod repo add [Private Repo Name] [Your GitHub HTTPS clone URL]
   $ pod repo add your-Specs https://gitlab.weiboyi.com/your-Specs.git
   ```

3. 使用第1步中的命令进入目录我们发现多了一个wby-ios-wbyspecs文件夹，到这里我们的私有spec repo就创建好了

   或者我们还可以使用pod repo list命令查看介入如下:

   ```
   your-Specs
   Type: git (master)
   URL:  https://gitlab.weiboyi.com/your-Specs.git
   Path: /Users/j/.cocoapods/repos/your-Specs
   master
   Type: git (master)
   URL:  https://github.com/CocoaPods/Specs.git
   Path: /Users/j/.cocoapods/repos/master
   ```


至此, 私有Spec Repo创建完毕. 下面我们来开始正题:



## Cocoapods 私有库制作关键过程
    1.创建 .podspec，编辑 .podspec（创建命令：pod spec create  your_spec_name）
    3.将自己的项目打成tag，上传至github或者其他代码平台 (项目中包含：.podspec文件)
    4.验证.podspec（验证命令：pod spec lint your_spec_name.podspec --verbose）
    5.注册trunk（注册命令：pod trunk register xxxx@163.com “your_name” --verbose），如果已经注册这一步跳过，可以查看注册信息（查看命令：pod trunk me）
    6.发布（发布命令：pod repo push your_private_specs your_sdk.podspec）
    7.查看自己发布的库（pod search your_spec_name），如果查不到的话，可能需要 pod repo update 一下，或者删除cocoapods的spec源，再pod update一下即可
    8.使用pod search xxx 时，会搜不到我们的库，执行以下命令rm ~/Library/Caches/CocoaPods/search_index.json 再次执行pod search xxx就可以搜索到了

#### podspec文件制作

```
Pod::Spec.new do |s|
  s.name             = 'VCLoadTimeProfiler' #名称
  s.version          = '1.0' #版本号
  s.summary          = 'A short description of VCLoadTimeProfiler.'  #简短介绍，下面是详细介绍

  s.description      = <<-DESC
					TODO: Add long description of the pod here.
                     DESC

  s.homepage         = 'https://github.com/BrooksWon/VCLoadTimeProfiler'  #主页,这里要填写可以访问到的地址，不然验证不通过

# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2' #截图

  s.license          = { :type => 'MIT', :file => 'LICENSE' } #开源协议
  s.author           = { 'BrooksWon' => 'hellocodingman@gmail.com' }  #作者信息
  s.source           = { :git => 'https://github.com/BrooksWon/VCLoadTimeProfiler.git', :tag => s.version.to_s } #项目地址，这里不支持ssh的地址，验证不通过，只支持HTTP和HTTPS，最好使用HTTPS

# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'  #多媒体介绍地址

  s.ios.deployment_target = '8.0' #支持的平台及版本
  s.requires_arc = true #是否使用ARC，如果指定具体文件，则具体的问题使用ARC

  s.source_files = 'VCLoadTimeProfiler/Classes/**/*'  #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置

# s.resource_bundles = {

# 'VCLoadTimeProfiler' => ['VCLoadTimeProfiler/Assets/*.png']

# }   #资源文件地址

# s.public_header_files = 'Pod/Classes/**/*.h'   #公开头文件地址

# s.frameworks = 'UIKit'  #所需的framework，多个用逗号隔开

# s.dependency 'AFNetworking', '~> 2.3'  #依赖关系，该项目所依赖的其他库，如果有多个需要填写多个s.dependency

end
```



## 错误解决方案

错误1:

> ERROR | [iOS] unknown: Encountered an unknown error (The 'Pods-App' target has transitive dependencies that include static binaries:

- 错误原因:

  这个错误是因为依赖库（s.dependency）包含了.a静态库造成的。虽然这并不影响Pod的使用，但是验证是无法通过的。可以通过--use-libraries来让验证通过。

- 解决方案: pod spec lint xxx.podspec --verbose --use-libraries

  在push的时候使用：pod repo push your_private_specs your_sdk.podspec --allow-warnings --use-libraries

错误2:

> pod install 提示搜索不到

- 错误原因: 找不到pod资源

- 解决方案: 在podfile文件头部加上下面的代码

  ```
  source ``'https://github.com/CocoaPods/Specs.git'`  `#官方仓库的地址
  source ``'https://gitlab.xxx.com/your-Specs.git'`  `#你自己的私有spec仓库的地址
  ```

然后执行 pod install

> *pod install* 把*Podfile*内全部的库更新重新安装
>
> *pod install --verbose --no-repo-update* 该命令只安装新添加的库，已更新的库忽略
>
> *pod update* 库名 *--verbose --no-repo-update* 该命令只更新指定的库，其它库忽略

