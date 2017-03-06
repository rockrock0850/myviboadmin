package com.tstar.dto;

import java.util.List;

public class Promotebanner {

	private String title_pic_android;		
	private String title_pic_ios;
	private String more_url;
	private List<TitleBanner> promote_data;
	public String getTitle_pic_android() {
		return title_pic_android;
	}
	public void setTitle_pic_android(String title_pic_android) {
		this.title_pic_android = title_pic_android;
	}
	public String getTitle_pic_ios() {
		return title_pic_ios;
	}
	public void setTitle_pic_ios(String title_pic_ios) {
		this.title_pic_ios = title_pic_ios;
	}
	public String getMore_url() {
		return more_url;
	}
	public void setMore_url(String more_url) {
		this.more_url = more_url;
	}
	public List<TitleBanner> getPromote_data() {
		return promote_data;
	}
	public void setPromote_data(List<TitleBanner> promote_data) {
		this.promote_data = promote_data;
	}
	
	
	
}
