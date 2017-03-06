package com.tstar.dao.tapp;

import com.tstar.model.tapp.SelectList;
import com.tstar.model.tapp.SelectListExample;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface SelectListMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int countByExample(SelectListExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int deleteByExample(SelectListExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int insert(SelectList record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int insertSelective(SelectList record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    List<SelectList> selectByExample(SelectListExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    SelectList selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int updateByExampleSelective(@Param("record") SelectList record, @Param("example") SelectListExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int updateByExample(@Param("record") SelectList record, @Param("example") SelectListExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int updateByPrimaryKeySelective(SelectList record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table SELECT_LIST
     *
     * @mbggenerated Mon Oct 20 14:36:16 CST 2014
     */
    int updateByPrimaryKey(SelectList record);
    
    List<SelectList> selectHierarchy(Map<String, Object> map);
    
    List<SelectList> selectMaxFunctionId(Map<String, String> map);
    
    List<SelectList> selectDisFunctionIdDscr(Map<String, String> map);
    
}