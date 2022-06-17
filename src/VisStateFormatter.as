string VisStateFormatter(CSceneVehicleVisState@ visState, const string &in featureName) {
    string key = "\"" + featureName + "\":";
    if (featureName == "InputSteer") {
        return key + visState.InputSteer;
    } else if (featureName == "InputIsBraking") {
        return key + visState.InputIsBraking;
    } else if (featureName == "InputGasPedal") {
        return key + visState.InputGasPedal;
    } else if (featureName == "InputBrakePedal") {
        return key + visState.InputBrakePedal;
    } else if (featureName == "InputVertical") {
        return key + visState.InputVertical;
    } else if (featureName == "ReactorBoostLvl") {
        return key + "\"" + tostring(visState.ReactorBoostLvl) + "\"";
    } else if (featureName == "ReactorBoostType") {
        return key + "\"" + tostring(visState.ReactorBoostType) + "\"";
    } else if (featureName == "ReactorAirControl") {
        return key + "\"" + tostring(visState.ReactorAirControl) + "\"";
    } else if (featureName == "ReactorInputsX") {
        return key + visState.ReactorInputsX;
    } else if (featureName == "WorldCarUp") {
        return key + "\"" + tostring(visState.WorldCarUp) + "\"";
    } else if (featureName == "IsGroundContact") {
        return key + visState.IsGroundContact;
    } else if (featureName == "IsReactorGroundMode") {
        return key + visState.IsReactorGroundMode;
    } else if (featureName == "IsWheelsBurning") {
        return key + visState.IsWheelsBurning;
    } else if (featureName == "GroundDist") {
        return key + visState.GroundDist;
    } else if (featureName == "FLGroundContactMaterial") {
        return key + "\"" + tostring(visState.FLGroundContactMaterial) + "\"";
    } else if (featureName == "FLSteerAngle") {
        return key + visState.FLSteerAngle;
    } else if (featureName == "FLWheelRot") {
        return key + visState.FLWheelRot;
    } else if (featureName == "FLWheelRotSpeed") {
        return key + visState.FLWheelRotSpeed;
    } else if (featureName == "FLDamperLen") {
        return key + visState.FLDamperLen;
    } else if (featureName == "FLSlipCoef") {
        return key + visState.FLSlipCoef;
    } else if (featureName == "FLIcing01") {
        return key + visState.FLIcing01;
    } else if (featureName == "FLTireWear01") {
        return key + visState.FLTireWear01;
    } else if (featureName == "FLBreakNormedCoef") {
        return key + visState.FLBreakNormedCoef;
    } else if (featureName == "FRGroundContactMaterial") {
        return key + "\"" + tostring(visState.FRGroundContactMaterial) + "\"";
    } else if (featureName == "FRSteerAngle") {
        return key + visState.FRSteerAngle;
    } else if (featureName == "FRWheelRot") {
        return key + visState.FRWheelRot;
    } else if (featureName == "FRWheelRotSpeed") {
        return key + visState.FRWheelRotSpeed;
    } else if (featureName == "FRDamperLen") {
        return key + visState.FRDamperLen;
    } else if (featureName == "FRSlipCoef") {
        return key + visState.FRSlipCoef;
    } else if (featureName == "FRIcing01") {
        return key + visState.FRIcing01;
    } else if (featureName == "FRTireWear01") {
        return key + visState.FRTireWear01;
    } else if (featureName == "FRBreakNormedCoef") {
        return key + visState.FRBreakNormedCoef;
    } else if (featureName == "RRGroundContactMaterial") {
        return key + "\"" + tostring(visState.RRGroundContactMaterial) + "\"";
    } else if (featureName == "RRSteerAngle") {
        return key + visState.RRSteerAngle;
    } else if (featureName == "RRWheelRot") {
        return key + visState.RRWheelRot;
    } else if (featureName == "RRWheelRotSpeed") {
        return key + visState.RRWheelRotSpeed;
    } else if (featureName == "RRDamperLen") {
        return key + visState.RRDamperLen;
    } else if (featureName == "RRSlipCoef") {
        return key + visState.RRSlipCoef;
    } else if (featureName == "RRIcing01") {
        return key + visState.RRIcing01;
    } else if (featureName == "RRTireWear01") {
        return key + visState.RRTireWear01;
    } else if (featureName == "RRBreakNormedCoef") {
        return key + visState.RRBreakNormedCoef;
    } else if (featureName == "RLGroundContactMaterial") {
        return key + "\"" + tostring(visState.RLGroundContactMaterial) + "\"";
    } else if (featureName == "RLSteerAngle") {
        return key + visState.RLSteerAngle;
    } else if (featureName == "RLWheelRot") {
        return key + visState.RLWheelRot;
    } else if (featureName == "RLWheelRotSpeed") {
        return key + visState.RLWheelRotSpeed;
    } else if (featureName == "RLDamperLen") {
        return key + visState.RLDamperLen;
    } else if (featureName == "RLSlipCoef") {
        return key + visState.RLSlipCoef;
    } else if (featureName == "RLIcing01") {
        return key + visState.RLIcing01;
    } else if (featureName == "RLTireWear01") {
        return key + visState.RLTireWear01;
    } else if (featureName == "RLBreakNormedCoef") {
        return key + visState.RLBreakNormedCoef;
    } else if (featureName == "CurGear") {
        return key + visState.CurGear;
    } else if (featureName == "EngineOn") {
        return key + visState.EngineOn;
    } else if (featureName == "IsTurbo") {
        return key + visState.IsTurbo;
    } else if (featureName == "TurboTime") {
        return key + visState.TurboTime;
    } else if (featureName == "RaceStartTime") {
        return key + visState.RaceStartTime;
    } else if (featureName == "Position") {
        return key + "\"" + tostring(visState.Position) + "\"";
    } else if (featureName == "Left") {
        return key + "\"" + tostring(visState.Left) + "\"";
    } else if (featureName == "Up") {
        return key + "\"" + tostring(visState.Up) + "\"";
    } else if (featureName == "Dir") {
        return key + "\"" + tostring(visState.Dir) + "\"";
    } else if (featureName == "WorldVel") {
        return key + "\"" + tostring(visState.WorldVel) + "\"";
    } else if (featureName == "FrontSpeed") {
        return key + visState.FrontSpeed;
    } else if (featureName == "BulletTimeNormed") {
        return key + visState.BulletTimeNormed;
    } else if (featureName == "SimulationTimeCoef") {
        return key + visState.SimulationTimeCoef;
    } else if (featureName == "AirBrakeNormed") {
        return key + visState.AirBrakeNormed;
    } else if (featureName == "SpoilerOpenNormed") {
        return key + visState.SpoilerOpenNormed;
    } else if (featureName == "WingsOpenNormed") {
        return key + visState.WingsOpenNormed;
    } else if (featureName == "IsTopContact") {
        return key + visState.IsTopContact;
    } else if (featureName == "WetnessValue01") {
        return key + visState.WetnessValue01;
    } else if (featureName == "WaterImmersionCoef") {
        return key + visState.WaterImmersionCoef;
    } else if (featureName == "WaterOverDistNormed") {
        return key + visState.WaterOverDistNormed;
    } else if (featureName == "WaterOverSurfacePos") {
        return key + "\"" + tostring(visState.WaterOverSurfacePos) + "\"";
    // } else if (featureName == "EventType") {
    //     return key + visState.EventType;
    } else if (featureName == "RPM") {
        return key + VehicleState::GetRPM(visState);
    } else if (featureName == "SideSpeed") {
        return key + VehicleState::GetSideSpeed(visState);
    } else if (featureName == "FLWheelDirt") {
        return key + VehicleState::GetWheelDirt(visState, 0);
    } else if (featureName == "FRWheelDirt") {
        return key + VehicleState::GetWheelDirt(visState, 1);
    } else if (featureName == "RLWheelDirt") {
        return key + VehicleState::GetWheelDirt(visState, 2);
    } else if (featureName == "RRWheelDirt") {
        return key + VehicleState::GetWheelDirt(visState, 3);
    } else {
        return "bad_feature: 1";
    }
}