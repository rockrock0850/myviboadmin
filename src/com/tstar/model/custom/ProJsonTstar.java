package com.tstar.model.custom;

public class ProJsonTstar {
	private String company = "";
	private String project_name = "";
	private String single_project_name = "";
	
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
	public String getSingle_project_name() {
		return single_project_name;
	}
	public void setSingle_project_name(String single_project_name) {
		this.single_project_name = single_project_name;
	}
}
