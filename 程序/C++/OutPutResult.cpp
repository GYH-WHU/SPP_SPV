#include "RTK_Structs.h"

/*-----------------------------------------------
    事后定位卫星与接收机的位置输出
------------------------------------------------*/
void OutputSatAndSPPResultToFile(const EPOCHOBS& Obs, const POSRES& pos, const PPRESULT& Result, const std::string& outputFile)
{
    std::ofstream fout_PVT(outputFile, std::ios::app);

    // 设置统一输出格式
    fout_PVT << std::fixed << std::setprecision(3);

    // 输出每颗卫星
    //for (int i = 0; i < Obs.SatNum; i++)
    //{
    //    const SATOBSDATA& sat = Obs.SatObs[i];
    //    const SATPVT& pvt = Obs.SatPVT[i];
    //    if (!pvt.Valid) continue;

    //    // 设置统一输出格式
    //    fout_PVT << std::fixed << std::setprecision(3);

    //    fout_PVT << (sat.System == GPS ? "G" : "C")<< sat.Prn << " "
    //        << "X= " << pvt.SatPos[0] << " " << "Y= " << pvt.SatPos[1] << " " << "Z= " << pvt.SatPos[2] << " ";

    //    // 设置统一输出格式
    //    fout_PVT << std::scientific;

    //    fout_PVT << "Clk= " << pvt.SatClkOft << " ";

    //    // 设置统一输出格式
    //    fout_PVT << std::fixed << std::setprecision(4);

    //    fout_PVT << "Vx= " << pvt.SatVel[0] << " " << "Vy= " << pvt.SatVel[1] << " " << "Vz= " << pvt.SatVel[2] << " ";

    //    // 设置统一输出格式，科学计数法
    //    fout_PVT << std::scientific;

    //    fout_PVT << "Clkd= " << pvt.SatClkSft << " ";

    //    // 设置统一输出格式
    //    fout_PVT << std::fixed << std::setprecision(4);
    //    
    //    fout_PVT << "PIF= " << Obs.ComObs[i].PIF << " "
    //        << "Trop= " << pvt.TropCorr << " "
    //        << "E= " << pvt.Elevation << "deg" << "\n";
    //}
    // 输出格式化结果
    GEOCOOR BLH;
    XYZToBLH(Result.Position, BLH.Blh, R_WGS84, F_WGS84);

    // 设置统一输出格式
    fout_PVT << std::fixed << std::setprecision(3);

    fout_PVT << "SPP: " << Obs.Time.Week << " " << Obs.Time.SecOfWeek << " " << "X: " << Result.Position[0] << " " << "Y: " << Result.Position[1] << " " << "Z: " << Result.Position[2] << " "
        << "B: " << BLH.Blh[0] << " " << "L: " << BLH.Blh[1] << " " << "H: " << BLH.Blh[2] << " "
        << "GPS Clk: " << Result.RcvClkOft[0] << " " << "BDS Clk: " << Result.RcvClkOft[1] << " "
        << "Vx: " << Result.Velocity[0] << " " << "Vy: " << Result.Velocity[1] << " " << "Vz: " << Result.Velocity[2] << " "
        << "PDOP: " << Result.PDOP << " "
        << "SigmaPos: " << Result.SigmaPos << " "
        << "GPSSats:" << Result.GPSSatNum << " " << "BDSSats: " << Result.BDSSatNum << " " << "Sats: " << Result.AllSatNum << "\n";

    double xyz[3] = { 0.0,0.0,0.0 };
    BLHToXYZ(pos.Pos, xyz, R_WGS84, F_WGS84);
    fout_PVT << "BestPos:               X: " << xyz[0] << " Y: " << xyz[1] << " Z: " << xyz[2] << " B: " << pos.Pos[1] << " L: " << pos.Pos[0] << " H: " << pos.Pos[2] << "\n";
}

/*-----------------------------------------------
    实时数据结果输出
------------------------------------------------*/
void OutputResult_RealTime(const PPRESULT* Result, const POSRES* Pos, const EPOCHOBS* Obs)
{
    GEOCOOR blh;
    XYZToBLH(Result->Position, blh.Blh, R_WGS84, F_WGS84);

    printf("SPP: %4d %9.3f ", Obs->Time.Week, Obs->Time.SecOfWeek);
    printf("GPSSats:%2d BDSSats:%2d Sats:%2d ", Result->GPSSatNum, Result->BDSSatNum, Result->AllSatNum);
    printf("B:%13.8f L:%13.8f H:%8.3f ", blh.Blh[0], blh.Blh[1], blh.Blh[2]);
    printf("X:%13.4f Y:%13.4f Z:%13.4f SigmaPos:%7.4f ", Result->Position[0], Result->Position[1], Result->Position[2], Result->SigmaPos);

    // 对齐速度输出
    printf("Vx:%+8.4f Vy:%+8.4f Vz:%+8.4f SigmaVel:%7.4f ", Result->Velocity[0], Result->Velocity[1], Result->Velocity[2], Result->SigmaVel);
    printf("PDOP:%7.4f\n", Result->PDOP);
}

/*-----------------------------------------------
    事后定位卫星与接收机的位置输出
------------------------------------------------*/
void OutputENUResult_RealTime(const EPOCHOBS& Obs, const POSRES& pos, const PPRESULT& Result, const std::string& outputFile)
{
    std::ofstream fout_PVT(outputFile, std::ios::app);

    double R_XYZ[3] = { 0.0,0.0,0.0 };
    double dENU[3] = { 0.0,0.0,0.0 };
    GEOCOOR blh;
    blh.longitude = pos.Pos[0];
    blh.latitude = pos.Pos[1];
    blh.height = pos.Pos[2];

    BLHToXYZ(pos.Pos, R_XYZ, R_WGS84, F_WGS84);
    CompEnudPos(Result.Position, R_XYZ, &blh, dENU);

    fout_PVT << std::fixed << std::setprecision(5);

    fout_PVT << "dENU: " << Result.Time.Week << " " << Result.Time.SecOfWeek << "  dE：" << dENU[0] << " dN：" << dENU[1] << " dU：" << dENU[2] << " PDOP：" << Result.PDOP << " SigmaPos：" << Result.SigmaPos << " SigmaVel：" << Result.SigmaVel << " GPS_RcvClkOft：" << Result.RcvClkOft[0] << " BDS_RcvClkOft：" << Result.RcvClkOft[1] << " RcvSft：" << Result.RcvClkSft << " GPS_Sats：" << Result.GPSSatNum << " BDS_Sats：" << Result.BDSSatNum << " Sum_Sats：" << Result.AllSatNum << endl;
}