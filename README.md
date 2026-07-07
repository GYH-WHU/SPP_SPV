# GNSS 单点定位与测速系统

本仓库整理了卫星导航算法与程序设计实验中的 GNSS 单点定位与单点测速代码。项目基于 C++ 实现 NovAtel OEM7 数据解码、GPS/BDS 双系统 SPP、SPV、误差改正、实时 Socket 数据接收和结果输出，并提供 MATLAB 图表脚本、定位结果和实验报告。

当前仓库包含源码、已生成定位结果、结果图和报告；原始 `socket_saved_9h.bin` 二进制观测数据未随仓库上传。若要重新运行事后处理，需要自行准备该数据文件，或使用实时采集模式重新保存。

## 主要功能

- NovAtel OEM7 解码：解析 RANGE、GPS/BDS 星历和接收机伪距定位结果。
- SPP 单点定位：基于伪距观测值计算接收机位置和钟差。
- SPV 单点测速：基于观测数据计算接收机速度和钟漂。
- 误差改正：卫星钟差、相对论效应、电离层 Klobuchar、对流层 Hopfield。
- 粗差探测：剔除异常观测值。
- 双系统支持：GPS + BDS 联合定位。
- 实时模式：通过 Socket 连接 `47.114.134.129:7190` 接收数据。
- 数据采集模式：将实时数据流保存为本地二进制文件。
- MATLAB 分析：绘制 dE/dN/dU、综合误差、PDOP、钟差、卫星数和标准差图。

## 项目结构

```text
.
├─ 程序/
│  ├─ C++/
│  │  ├─ main.cpp                 # 交互式入口，0 实时 / 1 事后 / 2 采集
│  │  ├─ RTK_Structs.h            # GNSS 常量、结构体和函数声明
│  │  ├─ DecodeNovOem7Dat.cpp     # OEM7 二进制解码
│  │  ├─ SPPSPV.cpp               # SPP/SPV 解算
│  │  ├─ PV_Clock.cpp             # 卫星位置、速度和钟差
│  │  ├─ ErrorCorrect.cpp         # 电离层、对流层、粗差探测
│  │  ├─ CoorTrans.cpp            # BLH/XYZ/ENU 与高度角方位角
│  │  ├─ TimeChange.cpp           # 时间系统转换
│  │  ├─ Socket.cpp               # 网络接收与数据保存
│  │  └─ OutPutResult.cpp         # 定位结果和 ENU 误差输出
│  └─ matlab/
│     └─ Figure_dENU.m            # 结果图绘制
├─ 定位结果/
│  ├─ 7.28日 半天.txt             # 已生成定位误差结果
│  └─ 结果图/                     # JPG 结果图
├─ 实验报告.pdf
└─ README.md
```

## 编译

Windows + MinGW 示例：

```powershell
cd .\程序\C++
g++ -std=c++11 .\main.cpp .\CoorTrans.cpp .\DecodeNovOem7Dat.cpp .\ErrorCorrect.cpp .\OutPutResult.cpp .\PV_Clock.cpp .\Socket.cpp .\SPPSPV.cpp .\TimeChange.cpp -I <Eigen路径> -lws2_32 -o spp_spv.exe
```

Visual Studio 也可创建控制台工程，加入 `程序/C++/*.cpp` 和 Eigen include path，并链接 `ws2_32.lib`。

## 运行模式

运行：

```powershell
.\spp_spv.exe
```

程序提示输入模式：

```text
1  事后定位
0  实时定位
2  实时数据采集
```

事后定位模式默认读取：

```text
data\socket_saved_9h.bin
```

实时定位和采集模式默认连接：

```text
47.114.134.129:7190
```

输出目录默认是：

```text
Result\
```

因此重新运行前建议在 `程序/C++/` 下准备：

```text
data\socket_saved_9h.bin
Result\
```

如果只查看已有结果，直接使用仓库中的：

```text
定位结果\7.28日 半天.txt
定位结果\结果图\
```

## 结果图

仓库已包含：

```text
定位结果\结果图\dE_Error_Plot.jpg
定位结果\结果图\dN_Error_Plot.jpg
定位结果\结果图\dU_Error_Plot.jpg
定位结果\结果图\Combined_Error_Plot.jpg
定位结果\结果图\PDOP_Plot.jpg
定位结果\结果图\GPS_Clk_Plot.jpg
定位结果\结果图\BDS_Clk_Plot.jpg
定位结果\结果图\Satellite_Count_Plot.jpg
定位结果\结果图\SigmaPos_SigmaVel_Plot.jpg
```

重新绘图时，将 `Calculation_error.txt` 放到 MATLAB 工作目录后运行：

```matlab
cd 程序/matlab
Figure_dENU
```

## 代码模块

| 文件 | 说明 |
| --- | --- |
| `DecodeNovOem7Dat.cpp` | OEM7 数据帧解析与星历/观测值提取 |
| `SPPSPV.cpp` | 卫星信号发射时刻 PVT、SPP、SPV |
| `PV_Clock.cpp` | GPS/BDS 星历轨道和钟差计算 |
| `ErrorCorrect.cpp` | Klobuchar、Hopfield 和粗差探测 |
| `CoorTrans.cpp` | 坐标转换与卫星高度角、方位角 |
| `Socket.cpp` | 实时 Socket 连接和二进制数据保存 |
| `OutPutResult.cpp` | 定位结果、ENU 误差和实时输出 |

## 环境要求

- Windows
- C++11 编译器
- Eigen3
- Windows Socket 库
- MATLAB，用于绘图

## 报告

```text
实验报告.pdf
```

## 作者

GYH-WHU
