package com.tstar.dao.tapp;

import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.ProjectsExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ProjectsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int countByExample(ProjectsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByExample(ProjectsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insert(Projects record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int insertSelective(Projects record);

    List<Projects> select();
    
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    List<Projects> selectByExample(ProjectsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    Projects selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExampleSelective(@Param("record") Projects record, @Param("example") ProjectsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByExample(@Param("record") Projects record, @Param("example") ProjectsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKeySelective(Projects record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table PROJECTS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    int updateByPrimaryKey(Projects record);
}