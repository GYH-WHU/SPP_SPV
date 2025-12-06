# GNSS单点定位与测速系统

## 项目简介

本项目是一个基于C++和MATLAB开发的GNSS（全球导航卫星系统）单点定位（SPP）与单点测速（SPV）解算系统。系统支持GPS和BDS双系统联合定位，能够进行实时和事后两种模式的定位解算，并提供了完整的误差改正与结果可视化功能。

## 项目信息

- **课程**: 卫星导航算法与程序设计1
- **学生**: GYH
- **开发语言**: C++、MATLAB
- **主要功能**: GNSS数据解码、单点定位、单点测速、误差分析

## 主要特性

### 🌟 核心功能

- **双系统支持**: 支持GPS和BDS双系统联合定位解算
- **数据解码**: 支持NovAtel OEM7格式二进制数据解码
- **定位算法**: 
  - 单点定位（SPP - Single Point Positioning）
  - 单点测速（SPV - Single Point Velocity）
- **误差改正**:
  - 电离层延迟改正（Klobuchar模型）
  - 对流层延迟改正（Hopfield模型）
  - 卫星钟差改正
  - 相对论效应改正
- **坐标转换**:
  - ECEF（地心地固坐标系）
  - BLH（大地坐标系：经度、纬度、高程）
  - ENU（东北天坐标系）
- **工作模式**:
  - **事后处理模式**: 读取已保存的二进制数据文件进行解算
  - **实时处理模式**: 通过网络Socket实时接收GNSS数据进行解算
  - **数据采集模式**: 将实时数据流保存为二进制文件

### 📊 结果分析

- **定位精度分析**: 计算ENU坐标系下的定位误差（dE、dN、dU）
- **精度指标**: PDOP、位置标准差（SigmaPos）、速度标准差（SigmaVel）
- **钟差分析**: GPS和BDS接收机钟差统计
- **卫星统计**: GPS、BDS及总卫星数量统计
- **数据可视化**: MATLAB脚本自动生成多维度分析图表

## 项目结构

```
├── 程序/
│   ├── C++/                    # C++核心算法程序
│   │   ├── main.cpp           # 主程序入口
│   │   ├── RTK_Structs.h      # 数据结构和常量定义
│   │   ├── DecodeNovOem7Dat.cpp    # NovAtel OEM7数据解码
│   │   ├── SPPSPV.cpp         # SPP/SPV定位解算
│   │   ├── PV_Clock.cpp       # 卫星位置、速度、钟差计算
│   │   ├── ErrorCorrect.cpp   # 误差改正算法
│   │   ├── CoorTrans.cpp      # 坐标转换函数
│   │   ├── TimeChange.cpp     # 时间转换函数
│   │   ├── Socket.cpp         # Socket网络通信
│   │   └── OutPutResult.cpp   # 结果输出函数
│   └── matlab/                 # MATLAB数据分析与可视化
│       └── Figure_dENU.m      # 误差分析绘图脚本
├── 定位结果/                    # 定位结果数据
│   ├── 7.28日 半天.txt         # 定位结果文本文件
│   └── 结果图/                  # 分析结果图表
│       ├── BDS_Clk_Plot.jpg
│       ├── Combined_Error_Plot.jpg
│       ├── dE_Error_Plot.jpg
│       ├── dN_Error_Plot.jpg
│       ├── dU_Error_Plot.jpg
│       ├── GPS_Clk_Plot.jpg
│       ├── PDOP_Plot.jpg
│       ├── Satellite_Count_Plot.jpg
│       └── SigmaPos_SigmaVel_Plot.jpg
├── 实验报告.pdf                 # 完整的实验报告
└── README.md                   # 项目说明文档
```

## 编译与运行

### 环境要求

- **编译器**: 支持C++11标准的编译器（如Visual Studio、GCC、Clang）
- **依赖库**: 
  - Eigen3（矩阵运算库）
  - Windows Socket API（用于网络通信，Windows平台）
- **MATLAB**: R2018b或更高版本（用于数据可视化）

### 编译步骤

1. **配置依赖库**
   - 安装Eigen3库（可从 [Eigen官网](https://eigen.tuxfamily.org/) 下载）
   - 将Eigen库头文件路径添加到编译器包含目录

2. **编译C++程序**
   ```bash
   # 使用CMake（推荐）
   mkdir build
   cd build
   cmake ..
   cmake --build .
   
   # 或使用IDE直接编译项目
   # Visual Studio: 打开项目文件并编译
   ```

### 运行方式

#### 模式1: 事后处理模式

```bash
# 运行程序，选择模式1
./GNSS_Processor
# 输入: 1
```

程序将从 `data/socket_saved_9h.bin` 读取二进制数据文件进行解算。

**输出文件**:
- `Result/Test.txt`: 卫星信息和定位结果
- `Result/Calculation_error.txt`: ENU误差分析数据

#### 模式2: 实时处理模式

```bash
# 运行程序，选择模式0
./GNSS_Processor
# 输入: 0
# 输入采集时长（小时）: 例如 9.0
```

程序将连接到 `47.114.134.129:7190` 实时接收GNSS数据进行解算。

#### 模式3: 数据采集模式

```bash
# 运行程序，选择模式2
./GNSS_Processor
# 输入: 2
# 输入采集时长（小时）: 例如 9.0
```

程序将实时数据流保存为 `data/socket_saved_9h.bin` 文件。

### MATLAB可视化

运行MATLAB脚本生成分析图表：

```matlab
% 在MATLAB中运行
cd 程序/matlab
Figure_dENU
```

脚本将读取 `Calculation_error.txt` 并生成所有分析图表，保存至 `Result/结果图/` 目录。

## 算法说明

### 单点定位（SPP）

采用伪距观测值的加权最小二乘法进行定位解算：

1. **卫星位置计算**: 基于广播星历计算信号发射时刻的卫星位置
2. **误差改正**: 
   - 卫星钟差改正
   - 电离层延迟改正（Klobuchar模型）
   - 对流层延迟改正（Hopfield模型）
3. **迭代解算**: 利用线性化观测方程迭代求解接收机位置和钟差

### 单点测速（SPV）

基于多普勒观测值或伪距差分进行速度解算：

1. **卫星速度计算**: 基于广播星历计算卫星速度
2. **多普勒观测**: 利用载波相位变化率或多普勒频移
3. **速度解算**: 线性化速度观测方程求解接收机速度

### 误差改正模型

- **电离层改正**: Klobuchar模型（GPS/BDS）
- **对流层改正**: Hopfield模型
- **粗差探测**: 基于统计检验的异常值检测

## 输出结果说明

### 定位结果文件格式

**Calculation_error.txt** 包含以下列：
- 历元编号
- GPS时间（周、周内秒）
- 周内秒
- dE（东向误差，米）
- dN（北向误差，米）
- dU（天顶误差，米）
- PDOP（位置精度因子）
- SigmaPos（位置标准差，米）
- SigmaVel（速度标准差，米/秒）
- GPS接收机钟差（秒）
- BDS接收机钟差（秒）
- 接收机钟漂（秒/秒）
- GPS卫星数
- BDS卫星数
- 总卫星数

### 可视化图表

1. **dE/dN/dU误差图**: 三个方向的定位误差时序图
2. **综合误差图**: RMS误差时序图
3. **PDOP图**: 几何精度因子变化
4. **钟差图**: GPS/BDS接收机钟差时序
5. **标准差图**: 位置和速度标准差
6. **卫星数量图**: GPS、BDS及总卫星数量统计

## 技术特点

- ✅ 支持GPS和BDS双系统联合定位
- ✅ 完整的误差改正模型
- ✅ 实时和事后两种处理模式
- ✅ 网络数据采集功能
- ✅ 自动化的结果分析和可视化
- ✅ 模块化代码设计，易于维护和扩展

## 注意事项

1. **数据格式**: 输入数据必须为NovAtel OEM7格式的二进制文件
2. **网络连接**: 实时模式需要稳定的网络连接和可访问的GNSS数据服务器
3. **文件路径**: 确保数据文件路径正确，输出目录具有写权限
4. **坐标系**: 默认使用WGS84坐标系（GPS）和CGCS2000坐标系（BDS）

## 作者

**GYH**  

## 许可证

本项目仅用于学术研究和教学目的。

## 参考资料

- NovAtel OEM7 Firmware Reference Manual
- 《GPS原理与接收机设计》
- 《GNSS数据处理与应用》
- Eigen库官方文档

---

**最后更新**: 2024年

