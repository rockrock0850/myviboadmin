package com.tstar.model.tapp;

import java.util.ArrayList;
import java.util.List;

public class RateProjectsExample {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    protected String orderByClause;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    protected boolean distinct;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    protected List<Criteria> oredCriteria;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public RateProjectsExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public String getOrderByClause() {
        return orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public boolean isDistinct() {
        return distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andIdIsNull() {
            addCriterion("ID is null");
            return (Criteria) this;
        }

        public Criteria andIdIsNotNull() {
            addCriterion("ID is not null");
            return (Criteria) this;
        }

        public Criteria andIdEqualTo(String value) {
            addCriterion("ID =", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotEqualTo(String value) {
            addCriterion("ID <>", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThan(String value) {
            addCriterion("ID >", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThanOrEqualTo(String value) {
            addCriterion("ID >=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThan(String value) {
            addCriterion("ID <", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThanOrEqualTo(String value) {
            addCriterion("ID <=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLike(String value) {
            addCriterion("ID like", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotLike(String value) {
            addCriterion("ID not like", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdIn(List<String> values) {
            addCriterion("ID in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotIn(List<String> values) {
            addCriterion("ID not in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdBetween(String value1, String value2) {
            addCriterion("ID between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotBetween(String value1, String value2) {
            addCriterion("ID not between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andRateIdIsNull() {
            addCriterion("RATE_ID is null");
            return (Criteria) this;
        }

        public Criteria andRateIdIsNotNull() {
            addCriterion("RATE_ID is not null");
            return (Criteria) this;
        }

        public Criteria andRateIdEqualTo(String value) {
            addCriterion("RATE_ID =", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdNotEqualTo(String value) {
            addCriterion("RATE_ID <>", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdGreaterThan(String value) {
            addCriterion("RATE_ID >", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdGreaterThanOrEqualTo(String value) {
            addCriterion("RATE_ID >=", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdLessThan(String value) {
            addCriterion("RATE_ID <", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdLessThanOrEqualTo(String value) {
            addCriterion("RATE_ID <=", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdLike(String value) {
            addCriterion("RATE_ID like", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdNotLike(String value) {
            addCriterion("RATE_ID not like", value, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdIn(List<String> values) {
            addCriterion("RATE_ID in", values, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdNotIn(List<String> values) {
            addCriterion("RATE_ID not in", values, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdBetween(String value1, String value2) {
            addCriterion("RATE_ID between", value1, value2, "rateId");
            return (Criteria) this;
        }

        public Criteria andRateIdNotBetween(String value1, String value2) {
            addCriterion("RATE_ID not between", value1, value2, "rateId");
            return (Criteria) this;
        }

        public Criteria andStatusIsNull() {
            addCriterion("STATUS is null");
            return (Criteria) this;
        }

        public Criteria andStatusIsNotNull() {
            addCriterion("STATUS is not null");
            return (Criteria) this;
        }

        public Criteria andStatusEqualTo(String value) {
            addCriterion("STATUS =", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusNotEqualTo(String value) {
            addCriterion("STATUS <>", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusGreaterThan(String value) {
            addCriterion("STATUS >", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusGreaterThanOrEqualTo(String value) {
            addCriterion("STATUS >=", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusLessThan(String value) {
            addCriterion("STATUS <", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusLessThanOrEqualTo(String value) {
            addCriterion("STATUS <=", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusLike(String value) {
            addCriterion("STATUS like", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusNotLike(String value) {
            addCriterion("STATUS not like", value, "status");
            return (Criteria) this;
        }

        public Criteria andStatusIn(List<String> values) {
            addCriterion("STATUS in", values, "status");
            return (Criteria) this;
        }

        public Criteria andStatusNotIn(List<String> values) {
            addCriterion("STATUS not in", values, "status");
            return (Criteria) this;
        }

        public Criteria andStatusBetween(String value1, String value2) {
            addCriterion("STATUS between", value1, value2, "status");
            return (Criteria) this;
        }

        public Criteria andStatusNotBetween(String value1, String value2) {
            addCriterion("STATUS not between", value1, value2, "status");
            return (Criteria) this;
        }

        public Criteria andProjectIdIsNull() {
            addCriterion("PROJECT_ID is null");
            return (Criteria) this;
        }

        public Criteria andProjectIdIsNotNull() {
            addCriterion("PROJECT_ID is not null");
            return (Criteria) this;
        }

        public Criteria andProjectIdEqualTo(String value) {
            addCriterion("PROJECT_ID =", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdNotEqualTo(String value) {
            addCriterion("PROJECT_ID <>", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdGreaterThan(String value) {
            addCriterion("PROJECT_ID >", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdGreaterThanOrEqualTo(String value) {
            addCriterion("PROJECT_ID >=", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdLessThan(String value) {
            addCriterion("PROJECT_ID <", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdLessThanOrEqualTo(String value) {
            addCriterion("PROJECT_ID <=", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdLike(String value) {
            addCriterion("PROJECT_ID like", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdNotLike(String value) {
            addCriterion("PROJECT_ID not like", value, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdIn(List<String> values) {
            addCriterion("PROJECT_ID in", values, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdNotIn(List<String> values) {
            addCriterion("PROJECT_ID not in", values, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdBetween(String value1, String value2) {
            addCriterion("PROJECT_ID between", value1, value2, "projectId");
            return (Criteria) this;
        }

        public Criteria andProjectIdNotBetween(String value1, String value2) {
            addCriterion("PROJECT_ID not between", value1, value2, "projectId");
            return (Criteria) this;
        }

        public Criteria andPriceIsNull() {
            addCriterion("PRICE is null");
            return (Criteria) this;
        }

        public Criteria andPriceIsNotNull() {
            addCriterion("PRICE is not null");
            return (Criteria) this;
        }

        public Criteria andPriceEqualTo(Integer value) {
            addCriterion("PRICE =", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceNotEqualTo(Integer value) {
            addCriterion("PRICE <>", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceGreaterThan(Integer value) {
            addCriterion("PRICE >", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceGreaterThanOrEqualTo(Integer value) {
            addCriterion("PRICE >=", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceLessThan(Integer value) {
            addCriterion("PRICE <", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceLessThanOrEqualTo(Integer value) {
            addCriterion("PRICE <=", value, "price");
            return (Criteria) this;
        }

        public Criteria andPriceIn(List<Integer> values) {
            addCriterion("PRICE in", values, "price");
            return (Criteria) this;
        }

        public Criteria andPriceNotIn(List<Integer> values) {
            addCriterion("PRICE not in", values, "price");
            return (Criteria) this;
        }

        public Criteria andPriceBetween(Integer value1, Integer value2) {
            addCriterion("PRICE between", value1, value2, "price");
            return (Criteria) this;
        }

        public Criteria andPriceNotBetween(Integer value1, Integer value2) {
            addCriterion("PRICE not between", value1, value2, "price");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountIsNull() {
            addCriterion("PREPAYMENT_AMOUNT is null");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountIsNotNull() {
            addCriterion("PREPAYMENT_AMOUNT is not null");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountEqualTo(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT =", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountNotEqualTo(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT <>", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountGreaterThan(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT >", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountGreaterThanOrEqualTo(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT >=", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountLessThan(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT <", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountLessThanOrEqualTo(Integer value) {
            addCriterion("PREPAYMENT_AMOUNT <=", value, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountIn(List<Integer> values) {
            addCriterion("PREPAYMENT_AMOUNT in", values, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountNotIn(List<Integer> values) {
            addCriterion("PREPAYMENT_AMOUNT not in", values, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountBetween(Integer value1, Integer value2) {
            addCriterion("PREPAYMENT_AMOUNT between", value1, value2, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andPrepaymentAmountNotBetween(Integer value1, Integer value2) {
            addCriterion("PREPAYMENT_AMOUNT not between", value1, value2, "prepaymentAmount");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneIsNull() {
            addCriterion("SINGLE_PHONE is null");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneIsNotNull() {
            addCriterion("SINGLE_PHONE is not null");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneEqualTo(String value) {
            addCriterion("SINGLE_PHONE =", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneNotEqualTo(String value) {
            addCriterion("SINGLE_PHONE <>", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneGreaterThan(String value) {
            addCriterion("SINGLE_PHONE >", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneGreaterThanOrEqualTo(String value) {
            addCriterion("SINGLE_PHONE >=", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneLessThan(String value) {
            addCriterion("SINGLE_PHONE <", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneLessThanOrEqualTo(String value) {
            addCriterion("SINGLE_PHONE <=", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneLike(String value) {
            addCriterion("SINGLE_PHONE like", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneNotLike(String value) {
            addCriterion("SINGLE_PHONE not like", value, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneIn(List<String> values) {
            addCriterion("SINGLE_PHONE in", values, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneNotIn(List<String> values) {
            addCriterion("SINGLE_PHONE not in", values, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneBetween(String value1, String value2) {
            addCriterion("SINGLE_PHONE between", value1, value2, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneNotBetween(String value1, String value2) {
            addCriterion("SINGLE_PHONE not between", value1, value2, "singlePhone");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingIsNull() {
            addCriterion("LINK_TO_BILLING is null");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingIsNotNull() {
            addCriterion("LINK_TO_BILLING is not null");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingEqualTo(String value) {
            addCriterion("LINK_TO_BILLING =", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingNotEqualTo(String value) {
            addCriterion("LINK_TO_BILLING <>", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingGreaterThan(String value) {
            addCriterion("LINK_TO_BILLING >", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingGreaterThanOrEqualTo(String value) {
            addCriterion("LINK_TO_BILLING >=", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingLessThan(String value) {
            addCriterion("LINK_TO_BILLING <", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingLessThanOrEqualTo(String value) {
            addCriterion("LINK_TO_BILLING <=", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingLike(String value) {
            addCriterion("LINK_TO_BILLING like", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingNotLike(String value) {
            addCriterion("LINK_TO_BILLING not like", value, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingIn(List<String> values) {
            addCriterion("LINK_TO_BILLING in", values, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingNotIn(List<String> values) {
            addCriterion("LINK_TO_BILLING not in", values, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingBetween(String value1, String value2) {
            addCriterion("LINK_TO_BILLING between", value1, value2, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingNotBetween(String value1, String value2) {
            addCriterion("LINK_TO_BILLING not between", value1, value2, "linkToBilling");
            return (Criteria) this;
        }

        public Criteria andIdLikeInsensitive(String value) {
            addCriterion("upper(ID) like", value.toUpperCase(), "id");
            return (Criteria) this;
        }

        public Criteria andRateIdLikeInsensitive(String value) {
            addCriterion("upper(RATE_ID) like", value.toUpperCase(), "rateId");
            return (Criteria) this;
        }

        public Criteria andStatusLikeInsensitive(String value) {
            addCriterion("upper(STATUS) like", value.toUpperCase(), "status");
            return (Criteria) this;
        }

        public Criteria andProjectIdLikeInsensitive(String value) {
            addCriterion("upper(PROJECT_ID) like", value.toUpperCase(), "projectId");
            return (Criteria) this;
        }

        public Criteria andSinglePhoneLikeInsensitive(String value) {
            addCriterion("upper(SINGLE_PHONE) like", value.toUpperCase(), "singlePhone");
            return (Criteria) this;
        }

        public Criteria andLinkToBillingLikeInsensitive(String value) {
            addCriterion("upper(LINK_TO_BILLING) like", value.toUpperCase(), "linkToBilling");
            return (Criteria) this;
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated do_not_delete_during_merge Mon Jun 15 17:05:17 CST 2015
     */
    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table RATE_PROJECTS
     *
     * @mbggenerated Mon Jun 15 17:05:17 CST 2015
     */
    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}