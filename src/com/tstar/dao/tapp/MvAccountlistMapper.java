package com.tstar.dao.tapp;

import com.tstar.model.tapp.MvAccountlist;
import com.tstar.model.tapp.MvAccountlistExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MvAccountlistMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int countByExample(MvAccountlistExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int deleteByExample(MvAccountlistExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int deleteByPrimaryKey(String loginid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int insert(MvAccountlist record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int insertSelective(MvAccountlist record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    List<MvAccountlist> selectByExample(MvAccountlistExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    MvAccountlist selectByPrimaryKey(String loginid);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int updateByExampleSelective(@Param("record") MvAccountlist record, @Param("example") MvAccountlistExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int updateByExample(@Param("record") MvAccountlist record, @Param("example") MvAccountlistExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int updateByPrimaryKeySelective(MvAccountlist record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_ACCOUNTLIST
     *
     * @mbggenerated Fri Dec 26 15:04:48 CST 2014
     */
    int updateByPrimaryKey(MvAccountlist record);
}