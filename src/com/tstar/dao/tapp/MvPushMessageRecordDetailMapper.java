package com.tstar.dao.tapp;

import com.tstar.model.tapp.MvPushMessageRecordDetail;
import com.tstar.model.tapp.MvPushMessageRecordDetailExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MvPushMessageRecordDetailMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int countByExample(MvPushMessageRecordDetailExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int deleteByExample(MvPushMessageRecordDetailExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int insert(MvPushMessageRecordDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int insertSelective(MvPushMessageRecordDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    List<MvPushMessageRecordDetail> selectByExample(MvPushMessageRecordDetailExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int updateByExampleSelective(@Param("record") MvPushMessageRecordDetail record, @Param("example") MvPushMessageRecordDetailExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table MV_PUSHMESSAGERECORDDETAIL
     *
     * @mbggenerated Tue May 19 14:05:09 CST 2015
     */
    int updateByExample(@Param("record") MvPushMessageRecordDetail record, @Param("example") MvPushMessageRecordDetailExample example);
}