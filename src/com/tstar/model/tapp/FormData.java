package com.tstar.model.tapp;

import java.sql.Timestamp;

public class FormData {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.FORM_KEY
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String formKey;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.FORM_ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String formId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.COLUMN_NAME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String columnName;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.COLUMN_VALUE
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String columnValue;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.SEQ
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private Short seq;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.STATUS
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private String status;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.CREATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private Timestamp createTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column FORM_DATA.UPDATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    private Timestamp updateTime;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.ID
     *
     * @return the value of FORM_DATA.ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.ID
     *
     * @param id the value for FORM_DATA.ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.FORM_KEY
     *
     * @return the value of FORM_DATA.FORM_KEY
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getFormKey() {
        return formKey;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.FORM_KEY
     *
     * @param formKey the value for FORM_DATA.FORM_KEY
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setFormKey(String formKey) {
        this.formKey = formKey == null ? null : formKey.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.FORM_ID
     *
     * @return the value of FORM_DATA.FORM_ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getFormId() {
        return formId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.FORM_ID
     *
     * @param formId the value for FORM_DATA.FORM_ID
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setFormId(String formId) {
        this.formId = formId == null ? null : formId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.COLUMN_NAME
     *
     * @return the value of FORM_DATA.COLUMN_NAME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getColumnName() {
        return columnName;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.COLUMN_NAME
     *
     * @param columnName the value for FORM_DATA.COLUMN_NAME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setColumnName(String columnName) {
        this.columnName = columnName == null ? null : columnName.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.COLUMN_VALUE
     *
     * @return the value of FORM_DATA.COLUMN_VALUE
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getColumnValue() {
        return columnValue;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.COLUMN_VALUE
     *
     * @param columnValue the value for FORM_DATA.COLUMN_VALUE
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setColumnValue(String columnValue) {
        this.columnValue = columnValue == null ? null : columnValue.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.SEQ
     *
     * @return the value of FORM_DATA.SEQ
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public Short getSeq() {
        return seq;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.SEQ
     *
     * @param seq the value for FORM_DATA.SEQ
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setSeq(Short seq) {
        this.seq = seq;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.STATUS
     *
     * @return the value of FORM_DATA.STATUS
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public String getStatus() {
        return status;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.STATUS
     *
     * @param status the value for FORM_DATA.STATUS
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.CREATE_TIME
     *
     * @return the value of FORM_DATA.CREATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public Timestamp getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.CREATE_TIME
     *
     * @param createTime the value for FORM_DATA.CREATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column FORM_DATA.UPDATE_TIME
     *
     * @return the value of FORM_DATA.UPDATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public Timestamp getUpdateTime() {
        return updateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column FORM_DATA.UPDATE_TIME
     *
     * @param updateTime the value for FORM_DATA.UPDATE_TIME
     *
     * @mbggenerated Mon Mar 16 16:49:46 CST 2015
     */
    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }
}