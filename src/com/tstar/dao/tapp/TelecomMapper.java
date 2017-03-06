package com.tstar.dao.tapp;

import com.tstar.model.tapp.Telecom;
import com.tstar.model.tapp.TelecomExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface TelecomMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int countByExample(TelecomExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByExample(TelecomExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insert(Telecom record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insertSelective(Telecom record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    List<Telecom> selectByExample(TelecomExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    Telecom selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExampleSelective(@Param("record") Telecom record, @Param("example") TelecomExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExample(@Param("record") Telecom record, @Param("example") TelecomExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKeySelective(Telecom record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TELECOM
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKey(Telecom record);
}