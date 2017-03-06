package com.tstar.model.custom;

public class ProJsonCompare {
	private String company = "";
	private String project_name = "";
	
	public String toString(){
		return "\nProject_name:" + this.project_name;
	}
	public String getProject_name() {
		return project_name;
	}
	public void setProject_name(String project_name) {
		this.project_name = project_name;
	}
	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}
}
