package com.tstar.service;

import java.util.List;

import com.tstar.model.custom.ProjectDevice;
import com.tstar.model.custom.ProjectRate;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.TelecomRate;


public interface ComparsionService {
	public List<ProjectRate> comparseProject(String telId, String upperFee, String lowerFee, String feeType);
	
	public ProjectRate comparseProjectSelectMax(String telId, String upperFee, String lowerFee, String feeType);
	
	public ProjectRate comparseProjectSelectMin(String telId, String upperFee, String lowerFee, String feeType);
	
	public List<ProjectDevice> getProjectByRateId(String rateId);
	
	/**
	 * 取得所有手機，排除STATUS=0
	 * @return
	 */
	public List<Projects> getAllProjects();
	
	public boolean insertNewProjectRate(TelecomRate telecomRate, List<RateProjects> rateProjectsList);
	
	public boolean updateProjectRate(TelecomRate telecomRate, List<RateProjects> rateProjectsList);
	
	/*
	 * Short one line description
	 * <p>
	 * Longer description. If there were any, it would be
     * @param telecomRate
     * @return boolean
	 * @see 更新TelecomRate資料
	 */
	public boolean updateTelecomRate(TelecomRate telecomRate);
	
	public boolean insertRateProjects(RateProjects rateProjects);
	
	public boolean updateRateProjects(RateProjects rateProjects);
	
	public List<TelecomRate> queryTelecomRateByRange(String qryTelecomId, int queryStart, int queryEnd);
	
	public TelecomRate queryTelecomRateById(String id);
	
	public List<RateProjects> queryRateProjectsByRateId(String rateId);
	
	/**
	 * 直接查詢RateProjects資料庫
	 * @param rateId
	 * @param status
	 * @return
	 */
	public List<RateProjects> queryRateProjects(String rateId, boolean isLike, String status);
	
	/**
	 * 根據rateId查詢RateProjects資料庫
	 * @param rateIdList
	 * @param status固定 1
	 * @param linkToBilling固定 Y
	 * @return
	 */
	public List<RateProjects> queryRateProjectsByProjectsId(List<String> rateIdList);
}
