package com.tstar.dao.tapp;

import com.tstar.model.tapp.CommercialReference;
import com.tstar.model.tapp.CommercialReferenceExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CommercialReferenceMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int countByExample(CommercialReferenceExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int deleteByExample(CommercialReferenceExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int insert(CommercialReference record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int insertSelective(CommercialReference record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    List<CommercialReference> selectByExample(CommercialReferenceExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    CommercialReference selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int updateByExampleSelective(@Param("record") CommercialReference record, @Param("example") CommercialReferenceExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int updateByExample(@Param("record") CommercialReference record, @Param("example") CommercialReferenceExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int updateByPrimaryKeySelective(CommercialReference record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table COMMERCIAL_REFERENCE
     *
     * @mbggenerated Wed Mar 18 16:33:26 CST 2015
     */
    int updateByPrimaryKey(CommercialReference record);
}