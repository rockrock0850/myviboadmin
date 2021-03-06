package com.tstar.model.tapp;

import java.sql.Timestamp;


public class SystemLookup {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.SERVICE_ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private String serviceId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.KEY
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private String key;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.VALUE
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private String value;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.STATUS
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private String status;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.CREATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private Timestamp createTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column SYSTEM_LOOKUP.UPDATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    private Timestamp updateTime;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.ID
     *
     * @return the value of SYSTEM_LOOKUP.ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.ID
     *
     * @param id the value for SYSTEM_LOOKUP.ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.SERVICE_ID
     *
     * @return the value of SYSTEM_LOOKUP.SERVICE_ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public String getServiceId() {
        return serviceId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.SERVICE_ID
     *
     * @param serviceId the value for SYSTEM_LOOKUP.SERVICE_ID
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setServiceId(String serviceId) {
        this.serviceId = serviceId == null ? null : serviceId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.KEY
     *
     * @return the value of SYSTEM_LOOKUP.KEY
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public String getKey() {
        return key;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.KEY
     *
     * @param key the value for SYSTEM_LOOKUP.KEY
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setKey(String key) {
        this.key = key == null ? null : key.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.VALUE
     *
     * @return the value of SYSTEM_LOOKUP.VALUE
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public String getValue() {
        return value;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.VALUE
     *
     * @param value the value for SYSTEM_LOOKUP.VALUE
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setValue(String value) {
        this.value = value == null ? null : value.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.STATUS
     *
     * @return the value of SYSTEM_LOOKUP.STATUS
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public String getStatus() {
        return status;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.STATUS
     *
     * @param status the value for SYSTEM_LOOKUP.STATUS
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.CREATE_TIME
     *
     * @return the value of SYSTEM_LOOKUP.CREATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public Timestamp getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.CREATE_TIME
     *
     * @param createTime the value for SYSTEM_LOOKUP.CREATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column SYSTEM_LOOKUP.UPDATE_TIME
     *
     * @return the value of SYSTEM_LOOKUP.UPDATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public Timestamp getUpdateTime() {
        return updateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column SYSTEM_LOOKUP.UPDATE_TIME
     *
     * @param updateTime the value for SYSTEM_LOOKUP.UPDATE_TIME
     *
     * @mbggenerated Thu Feb 05 09:55:45 CST 2015
     */
    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }
}