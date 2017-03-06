package com.tstar.dto;



public class QueryCompareProjectDto {
	
	private String op_id = "";
	private String gtype = "";//就是fee_type
	private String period = "";
	private String fee_range = "";
	private String fee_sel = "";
	private String range_from = "";
	private String range_to = "";
	private String voice_on_net = "";
	private String voice_off_net = "";
	private String pstn = "";
	private String sms_on_net = "";
	private String sms_off_net = "";
	private String data_usage = "";
	private String avg_on_net = "";
	private String project_code = "";
	private String cal_rule = "";
	private String apply_type = "";
	private String fee_type = "";
	private String phone_code = "";
	
	@Override
	public String toString() {
		return  "\ncal_rule:"+this.cal_rule+
				"\napply_type:"+this.apply_type+
				"\nop_id:"+this.op_id+
				"\nfee_type:"+this.fee_type+
				"\nfee_range:"+this.fee_range+
				"\nfee_sel:"+this.fee_sel+
				"\nperiod:"+this.period+
				"\nproject_code:"+this.project_code+
				"\nvoice_on_net:"+this.voice_on_net+
				"\nvoice_off_net:"+this.voice_off_net+
				"\npstn:"+this.pstn+
				"\ndata_usage:"+this.data_usage+
				"\nsms_on_net:"+this.sms_on_net+
				"\nsms_off_net:"+this.sms_off_net+
				"\nphone_code:"+this.phone_code+
				"\ngtype:"+this.gtype+
				"\navg_on_net:"+this.avg_on_net;
	}

	public String getPeriod() {
		return period;
	}

	public void setPeriod(String period) {
		this.period = period;
	}

	public String getOp_id() {
		return op_id;
	}

	public void setOp_id(String op_id) {
		this.op_id = op_id;
	}

	public String getGtype() {
		return gtype;
	}

	public void setGtype(String gtype) {
		this.gtype = gtype;
	}

	public String getRange_from() {
		return range_from;
	}

	public void setRange_from(String range_from) {
		this.range_from = range_from;
	}

	public String getRange_to() {
		return range_to;
	}

	public void setRange_to(String range_to) {
		this.range_to = range_to;
	}

	public String getVoice_on_net() {
		return voice_on_net;
	}

	public void setVoice_on_net(String voice_on_net) {
		this.voice_on_net = voice_on_net;
	}

	public String getVoice_off_net() {
		return voice_off_net;
	}

	public void setVoice_off_net(String voice_off_net) {
		this.voice_off_net = voice_off_net;
	}

	public String getPstn() {
		return pstn;
	}

	public void setPstn(String pstn) {
		this.pstn = pstn;
	}

	public String getSms_on_net() {
		return sms_on_net;
	}

	public void setSms_on_net(String sms_on_net) {
		this.sms_on_net = sms_on_net;
	}

	public String getSms_off_net() {
		return sms_off_net;
	}

	public void setSms_off_net(String sms_off_net) {
		this.sms_off_net = sms_off_net;
	}

	public String getData_usage() {
		return data_usage;
	}

	public void setData_usage(String data_usage) {
		this.data_usage = data_usage;
	}

	public String getAvg_on_net() {
		return avg_on_net;
	}

	public void setAvg_on_net(String avg_on_net) {
		this.avg_on_net = avg_on_net;
	}

	public String getFee_sel() {
		return fee_sel;
	}

	public void setFee_sel(String fee_sel) {
		this.fee_sel = fee_sel;
	}

	public String getProject_code() {
		return project_code;
	}

	public void setProject_code(String project_code) {
		this.project_code = project_code;
	}

	public String getFee_range() {
		return fee_range;
	}

	public void setFee_range(String fee_range) {
		this.fee_range = fee_range;
	}

	public String getCal_rule() {
		return cal_rule;
	}

	public void setCal_rule(String cal_rule) {
		this.cal_rule = cal_rule;
	}

	public String getApply_type() {
		return apply_type;
	}

	public void setApply_type(String apply_type) {
		this.apply_type = apply_type;
	}

	public String getFee_type() {
		return fee_type;
	}

	public void setFee_type(String fee_type) {
		this.fee_type = fee_type;
	}

	public String getPhone_code() {
		return phone_code;
	}

	public void setPhone_code(String phone_code) {
		this.phone_code = phone_code;
	}

}
