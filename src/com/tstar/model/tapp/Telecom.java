package com.tstar.model.tapp;

public class Telecom {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TELECOM.ID
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TELECOM.NAME
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    private String name;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TELECOM.STATUS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    private String status;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column TELECOM.ID
     *
     * @return the value of TELECOM.ID
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column TELECOM.ID
     *
     * @param id the value for TELECOM.ID
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column TELECOM.NAME
     *
     * @return the value of TELECOM.NAME
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public String getName() {
        return name;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column TELECOM.NAME
     *
     * @param name the value for TELECOM.NAME
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column TELECOM.STATUS
     *
     * @return the value of TELECOM.STATUS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public String getStatus() {
        return status;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column TELECOM.STATUS
     *
     * @param status the value for TELECOM.STATUS
     *
     * @mbggenerated Wed Oct 01 17:36:16 CST 2014
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }
}