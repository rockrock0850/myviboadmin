package com.tstar.dao.tapp;

import com.tstar.model.tapp.Devices;
import com.tstar.model.tapp.DevicesExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface DevicesMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int countByExample(DevicesExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByExample(DevicesExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insert(Devices record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insertSelective(Devices record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    List<Devices> selectByExample(DevicesExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    Devices selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExampleSelective(@Param("record") Devices record, @Param("example") DevicesExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExample(@Param("record") Devices record, @Param("example") DevicesExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKeySelective(Devices record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table DEVICES
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKey(Devices record);
}