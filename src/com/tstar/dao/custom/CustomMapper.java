package com.tstar.dao.custom;

import java.util.List;
import java.util.Map;

import com.tstar.model.custom.ProjectDevice;
import com.tstar.model.custom.ProjectRate;
import com.tstar.model.tapp.MvPushMessageUsers;
import com.tstar.model.tapp.MvPushMessageUsersExample;
import com.tstar.model.tapp.RateProjects;

public interface CustomMapper {
    List<ProjectRate> queryProject(Map<String, String> map);
    List<ProjectDevice> queryProjectByRateId(Map<String, String> map);
    List<RateProjects> queryRateProjectsByRateId(String rateId);
    List<RateProjects> queryRateProjectsByRateIdLike(String rateId);
    List<MvPushMessageUsers> queryMvPushMessageUsersSimple(MvPushMessageUsersExample example);
    List<RateProjects> queryRateProjectsByProjectsId(List<String> rateIdList);
}