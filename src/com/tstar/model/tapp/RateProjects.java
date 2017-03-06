package com.tstar.model.tapp;

public class RateProjects {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.RATE_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String rateId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.STATUS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String status;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.PROJECT_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String projectId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.PRICE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private Integer price;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.PREPAYMENT_AMOUNT
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private Integer prepaymentAmount;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.SINGLE_PHONE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String singlePhone;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column RATE_PROJECTS.LINK_TO_BILLING
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    private String linkToBilling;

	@Override
	public String toString() {
		String msg = "Id:["+this.id+ 
				"]-rateId:["+this.rateId+
				"]-status:["+this.status+
				"]-projectId:["+this.projectId+
				"]-price:["+this.price+
				"]-prepaymentAmount:["+this.prepaymentAmount+
				"]-singlePhone:["+this.singlePhone+
				"]-linkToBilling:["+this.linkToBilling+"]";
		return msg;
	}

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.ID
     *
     * @return the value of RATE_PROJECTS.ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.ID
     *
     * @param id the value for RATE_PROJECTS.ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.RATE_ID
     *
     * @return the value of RATE_PROJECTS.RATE_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getRateId() {
        return rateId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.RATE_ID
     *
     * @param rateId the value for RATE_PROJECTS.RATE_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setRateId(String rateId) {
        this.rateId = rateId == null ? null : rateId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.STATUS
     *
     * @return the value of RATE_PROJECTS.STATUS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getStatus() {
        return status;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.STATUS
     *
     * @param status the value for RATE_PROJECTS.STATUS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.PROJECT_ID
     *
     * @return the value of RATE_PROJECTS.PROJECT_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getProjectId() {
        return projectId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.PROJECT_ID
     *
     * @param projectId the value for RATE_PROJECTS.PROJECT_ID
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setProjectId(String projectId) {
        this.projectId = projectId == null ? null : projectId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.PRICE
     *
     * @return the value of RATE_PROJECTS.PRICE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public Integer getPrice() {
        return price;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.PRICE
     *
     * @param price the value for RATE_PROJECTS.PRICE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setPrice(Integer price) {
        this.price = price;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.PREPAYMENT_AMOUNT
     *
     * @return the value of RATE_PROJECTS.PREPAYMENT_AMOUNT
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public Integer getPrepaymentAmount() {
        return prepaymentAmount;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.PREPAYMENT_AMOUNT
     *
     * @param prepaymentAmount the value for RATE_PROJECTS.PREPAYMENT_AMOUNT
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setPrepaymentAmount(Integer prepaymentAmount) {
        this.prepaymentAmount = prepaymentAmount;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.SINGLE_PHONE
     *
     * @return the value of RATE_PROJECTS.SINGLE_PHONE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getSinglePhone() {
        return singlePhone;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.SINGLE_PHONE
     *
     * @param singlePhone the value for RATE_PROJECTS.SINGLE_PHONE
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setSinglePhone(String singlePhone) {
        this.singlePhone = singlePhone == null ? null : singlePhone.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column RATE_PROJECTS.LINK_TO_BILLING
     *
     * @return the value of RATE_PROJECTS.LINK_TO_BILLING
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getLinkToBilling() {
        return linkToBilling;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column RATE_PROJECTS.LINK_TO_BILLING
     *
     * @param linkToBilling the value for RATE_PROJECTS.LINK_TO_BILLING
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setLinkToBilling(String linkToBilling) {
        this.linkToBilling = linkToBilling == null ? null : linkToBilling.trim();
    }
}