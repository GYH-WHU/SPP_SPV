/*	最终结果解算	*/
#include "RTK_Structs.h"

int mode = 1;   // 模式选择，默认为1，事后解算
int main()
{
    printf("请输入模式选择（1为事后定位 0为实时定位）：");
    scanf("%d", &mode);
    printf("你选择了 %d 模式。\n", mode);

    // 初始化数据结构
    EPOCHOBS Obs;       // 观测值
    RAWDAT Eph;         // 观测星历
    PPRESULT Result;    // 解算结果
    POSRES Pos;         // 接收机坐标

    if (mode == 1)
    {
        // 打开观测数据文件
        //FILE* FObs = fopen("data/oem719-202504011900-1.bin", "rb");
        FILE* FObs = fopen("data/socket_saved_9h.bin", "rb");

        if (!FObs) {
            printf("无法打开观测数据文件。\n");
            return -1;
        }

        std::ofstream fout_PVT("Result\\Test.txt");
        if (!fout_PVT)
        {
            printf("无法创建输出卫星位置和接收机位置文件。\n");
            return 0;
        }
        std::ofstream fout_Result("Result\\Calculation_error.txt");
        if (!fout_Result)
        {
            printf("无法创建输出文件。\n");
            return 0;
        }
        unsigned char buff[MAXRAWLEN];
        int lenD = 0, lenR = 0;

        // 循环解码并调用计算函数
        while (!feof(FObs))
        {
            lenR = fread(buff + lenD, sizeof(unsigned char), MAXRAWLEN - lenD, FObs);
            if (lenR <= 0) break;
            lenD += lenR;

            if (DecodeNovOem7Dat(buff, lenD, &Obs, Eph.GpsEph, Eph.BdsEph, &Pos) != 0)  // 解码失败即未return 0则不进行定位
                continue;

            DetectOutlier(&Obs);            // 粗差探测

            if (SPP(&Obs, &Eph, &Result))   // SPP定位解算,未进行SPP解算的历元，不进行SPV计算以及结果输出，继续解码
            {
                SPV(&Obs, &Result);         // SPV定位解算
            }
            else continue;
            //OutputSatAndSPPResultToFile(Obs, Pos, Result, "Result\\Test.txt");           // 输出卫星位置和接收机位置
            OutputENUResult_RealTime(Obs, Pos, Result, "Result\\Calculation_error.txt"); // 输出定位解算误差结果
        }

        // 关闭文件
        fclose(FObs);
        fout_PVT.close();
        fout_Result.close();
        printf("验证完成，结果输出至 Result/Test.txt。\n");
    }

    else if (mode == 0)
    {
        double hour = 0.0;
        cout << "请输入你要读取并保存计算结果的时间长度（小时）：\n";
        cin >> hour;
        std::ofstream fout_PVT("Result\\SatAndSPP_Pos.txt");
        if (!fout_PVT)
        {
            printf("无法创建输出卫星位置和接收机位置文件。\n");
            return 0;
        }
        std::ofstream fout_Result("Result\\Calculation_error.txt");
        if (!fout_Result)
        {
            printf("无法创建输出定位误差文件。\n");
            return 0;
        }
        unsigned char Buff[MAXRAWLEN];
        unsigned char buff[MAXRAWLEN];
        SOCKET NetGps;
        if (OpenSocket(NetGps, "47.114.134.129", 7190) == false)
        {
            printf("This ip & port was not opened.\n");
            return 0;
        }
        int lenR = 0;
        int lenD = 0;

        DWORD startTick = GetTickCount64();  // 获取开始时间（毫秒）
        while (true)
        {
            // 判断是否已到达 hour 小时
            DWORD nowTick = GetTickCount64();
            if (nowTick - startTick >= hour * 60.0 * 60.0 * 1e3) {  // 60000ms = 60s; 9h = 32,400,000ms
                printf("接收已满 %f 小时，保存完毕。\n", hour);
                break;
            }
            Sleep(980);
            if ((lenR = recv(NetGps, (char*)buff, MAXRAWLEN, 0)) > 0)
            {
                memcpy(Buff + lenD, buff, lenR);
                lenD = lenR + lenD;
                memset(buff, 0, MAXRAWLEN);
                if (DecodeNovOem7Dat(Buff, lenD, &Obs, Eph.GpsEph, Eph.BdsEph, &Pos) != 0)  // 解码失败即未return 0则不进行定位
                    continue;

                // 粗差探测并计算可用数据的组合观测值
                DetectOutlier(&Obs);            // 粗差探测

                if (SPP(&Obs, &Eph, &Result))   // SPP定位解算,未进行SPP解算的历元，不进行SPV计算以及结果输出，继续解码
                {
                    SPV(&Obs, &Result);         // SPV定位解算
                }
                else continue;

                OutputResult_RealTime(&Result, &Pos, &Obs); // 结果输出
                //OutputSatAndSPPResultToFile(Obs, Pos, Result, "Result\\SatAndSPP_Pos.txt");           // 输出卫星位置和接收机位置
                OutputENUResult_RealTime(Obs, Pos, Result, "Result\\Calculation_error.txt"); // 输出定位解算误差结果

            }
        }
        fout_PVT.close();
        fout_Result.close();
    }
    else if (mode == 2)
    {
        double hour = 0.0;
        cout << "请输入你要读取并保存数据的时间长度（小时）：\n";
        cin >> hour;
        SaveSocketStreamToFile("47.114.134.129", 7190, "data\\socket_saved_9h.bin", hour);
    }
    return 0;

}